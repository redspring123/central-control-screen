import router from '@ohos.router';
import { AiService } from '../utils/AiService';
import { UserRepo, UserProfile, UserInfo } from 'auth';
import { AppDatabase } from 'utils';
import { relationalStore } from '@kit.ArkData';

interface ChatMessage {
  id: number;
  role: 'user' | 'ai';
  content: string;
}

// 接收参数的接口
interface DoctorParams {
  id: number;
  name: string;
  title: string;
  hospital: string;
  department: string;
  specialty: string;
}

@Entry({ routeName: 'DoctorChatPage' })
@Component
export struct DoctorChatPage {
  @State messageList: ChatMessage[] = [];
  @State inputText: string = '';
  @State isTyping: boolean = false;
  @State doctorInfo: DoctorParams | null = null;
  @State userProfile: UserProfile | null = null;
  private scroller: Scroller = new Scroller();

  aboutToAppear() {
    // 获取路由参数
    const params = router.getParams() as DoctorParams;
    if (params) {
      this.doctorInfo = params;
      // 初始欢迎语
      this.addAiMessage(`您好，我是${this.doctorInfo.hospital}${this.doctorInfo.department}的${this.doctorInfo.name}医生。请问您哪里不舒服？`);
    } else {
      this.addAiMessage("您好，请问有什么可以帮您？");
    }
    // 加载用户画像
    this.loadUserProfile();
  }

  async loadUserProfile() {
    const currentUser = AppStorage.get<UserInfo>('currentUser');
    if (currentUser) {
      try {
        const profile = await UserRepo.getUserProfile(currentUser.id);
        if (profile) {
          this.userProfile = profile;
        }
      } catch (e) {
        console.error('加载用户画像失败:', JSON.stringify(e));
      }
    }
  }

  async getFullContext(): Promise<string> {
    let context = "";

    // 1. 用户画像
    if (this.userProfile) {
      context += `[患者基本信息]
      性别：${this.userProfile.gender}
      年龄：${this.userProfile.age}
      身高：${this.userProfile.height}cm
      体重：${this.userProfile.weight}kg\n`;
    }

    // 2. 今日健康数据 (直接查询数据库)
    try {
      const store: relationalStore.RdbStore = AppDatabase.getStore();
      const predicates = new relationalStore.RdbPredicates('health_daily');
      // 获取今日日期 YYYY-MM-DD
      const date = new Date();
      const year = date.getFullYear();
      const month = (date.getMonth() + 1).toString().padStart(2, '0');
      const day = date.getDate().toString().padStart(2, '0');
      const todayStr = `${year}-${month}-${day}`;

      predicates.equalTo('date', todayStr);
      // 假设当前用户ID为1，或者从AppStorage获取
      const currentUser = AppStorage.get<UserInfo>('currentUser');
      const userId = currentUser ? currentUser.id : 1;
      predicates.equalTo('user_id', userId);
      
      const resultSet = await store.query(predicates);
      if (resultSet.goToFirstRow()) {
        // 手动读取字段
        const steps = resultSet.getLong(resultSet.getColumnIndex('steps_current'));
        const heartRate = resultSet.getLong(resultSet.getColumnIndex('heart_rate'));
        const bpSystolic = resultSet.getLong(resultSet.getColumnIndex('bp_systolic'));
        const bpDiastolic = resultSet.getLong(resultSet.getColumnIndex('bp_diastolic'));
        const temp = resultSet.getDouble(resultSet.getColumnIndex('temperature'));
        const stress = resultSet.getLong(resultSet.getColumnIndex('stress_value'));
        const sleep = resultSet.getDouble(resultSet.getColumnIndex('sleep_total'));
        const spo2 = resultSet.getLong(resultSet.getColumnIndex('spo2'));

        context += `[患者今日体征数据]
        步数：${steps}
        心率：${heartRate} bpm
        血压：${bpSystolic}/${bpDiastolic} mmHg
        体温：${temp.toFixed(1)}°C
        压力值：${stress}
        睡眠：${sleep.toFixed(1)}小时
        血氧：${spo2}%\n`;
      }
      resultSet.close();
    } catch (e) {
      console.warn('获取健康数据失败', JSON.stringify(e));
    }

    return context;
  }

  addAiMessage(content: string) {
    this.messageList.push({
      id: Date.now(),
      role: 'ai',
      content: content
    });
    this.scrollToBottom();
  }

  addUserMessage(content: string) {
    this.messageList.push({
      id: Date.now(),
      role: 'user',
      content: content
    });
    this.scrollToBottom();
  }

  scrollToBottom() {
    setTimeout(() => {
      this.scroller.scrollEdge(Edge.Bottom);
    }, 100);
  }

  async sendMessage() {
    if (!this.inputText.trim()) return;

    const text = this.inputText;
    this.inputText = ''; // 清空输入框
    this.addUserMessage(text);

    this.isTyping = true;

    // --- 构造医生人设 (Context) ---
    let systemPrompt = "你是一个专业的医生。";
    
    // 1. 注入医生身份
    if (this.doctorInfo) {
      systemPrompt = `你现在扮演一位真实的医生。
      你的名字是：${this.doctorInfo.name}。
      你的职称是：${this.doctorInfo.title}。
      你所在的医院是：${this.doctorInfo.hospital}。
      你所在的科室是：${this.doctorInfo.department}。
      你的擅长领域是：${this.doctorInfo.specialty}。
      
      请根据你的身份和擅长领域，用专业、亲切、负责任的口吻回答患者的咨询。
      如果患者询问你的个人信息，请根据上述设定回答。
      对于你擅长领域的问题，请给出专业的建议；对于不擅长的领域，建议患者咨询相关科室。
      回答要简洁明了，不要长篇大论。`;
    }

    // 2. 注入患者数据 (新增)
    const patientContext = await this.getFullContext();
    if (patientContext) {
      systemPrompt += `\n\n以下是当前咨询患者的实时档案和体征数据，请结合这些数据进行诊断：\n${patientContext}`;
    }

    // --- 调用真实 API ---
    try {
      const aiReply = await AiService.chatWithAi(text, systemPrompt);
      this.isTyping = false;
      this.addAiMessage(aiReply);
    } catch (e) {
      this.isTyping = false;
      this.addAiMessage("抱歉，网络连接不稳定，请稍后再试。");
    }
  }

  build() {
    Column() {
      // 1. 标题栏
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(24)
          .fontColor([Color.Black]) // 强制黑色
          .onClick(() => router.back())
        
        Column() {
          Text(this.doctorInfo ? `${this.doctorInfo.name}医生` : '在线问诊')
            .fontSize(18).fontWeight(FontWeight.Bold)
            .fontColor(Color.Black)
          if (this.doctorInfo) {
            Text(`${this.doctorInfo.department} | ${this.doctorInfo.title}`)
              .fontSize(12).fontColor(Color.Gray).margin({ top: 2 })
          }
        }.alignItems(HorizontalAlign.Start).margin({ left: 15 })
      }
      .width('100%')
      .padding(15)
      .backgroundColor(Color.White)
      .shadow({ radius: 2, color: 'rgba(0,0,0,0.1)', offsetY: 2 })

      // 2. 聊天列表
      List({ scroller: this.scroller, space: 15 }) {
        ForEach(this.messageList, (msg: ChatMessage) => {
          ListItem() {
            Row() {
              if (msg.role === 'ai') {
                // 医生头像
                Image($r('app.media.icon_doctor'))
                  .width(40).height(40)
                  .backgroundColor('#E3F2FD')
                  .borderRadius(20)
                  .padding(5)
                  .margin({ right: 10 })
                  .fillColor('#007DFF') // 医生图标用蓝色
                
                // 消息气泡
                Text(msg.content)
                  .fontSize(16)
                  .fontColor(Color.Black)
                  .backgroundColor(Color.White)
                  .padding(12)
                  .borderRadius({ topLeft: 0, topRight: 12, bottomLeft: 12, bottomRight: 12 })
                  .layoutWeight(1)
                  .shadow({ radius: 2, color: 'rgba(0,0,0,0.05)' })
              } else {
                // 用户消息气泡 (右侧)
                Blank()
                Text(msg.content)
                  .fontSize(16)
                  .fontColor(Color.White)
                  .backgroundColor('#007DFF')
                  .padding(12)
                  .borderRadius({ topLeft: 12, topRight: 0, bottomLeft: 12, bottomRight: 12 })
                  .margin({ right: 10 })
                  .constraintSize({ maxWidth: '70%' })
                
                // 用户头像
                Image($r('app.media.user_icon'))
                  .width(40).height(40)
                  .borderRadius(20)
                  .backgroundColor('#F5F5F5')
              }
            }
            .width('100%')
            .alignItems(VerticalAlign.Top)
            .justifyContent(msg.role === 'ai' ? FlexAlign.Start : FlexAlign.End)
          }
        }, (msg: ChatMessage) => msg.id.toString())
      }
      .layoutWeight(1)
      .width('100%')
      .padding(15)
      .backgroundColor('#F5F7FA')

      // 3. 输入区
      Row() {
        TextInput({ placeholder: '请描述您的症状...', text: this.inputText })
          .layoutWeight(1)
          .height(40)
          .fontColor(Color.Black)
          .placeholderColor(Color.Gray)
          .backgroundColor(Color.White)
          .borderRadius(20)
          .padding({ left: 15, right: 15 })
          .onChange((value) => this.inputText = value)
          .onSubmit(() => this.sendMessage())

        Button("发送")
          .height(40)
          .margin({ left: 10 })
          .onClick(() => this.sendMessage())
          .enabled(!this.isTyping)
      }
      .width('100%')
      .padding(10)
      .backgroundColor(Color.White)
    }
    .width('100%')
    .height('100%')
  }
}
