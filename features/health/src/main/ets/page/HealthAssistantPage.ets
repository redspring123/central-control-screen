import router from '@ohos.router';
import { UserRepo, UserProfile, UserInfo } from 'auth';

interface ChatMessage {
  id: number;
  role: 'user' | 'ai';
  content: string;
}

@Entry({ routeName: 'HealthAssistantPage' })
@Component
export struct HealthAssistantPage {
  @State messageList: ChatMessage[] = [];
  @State inputText: string = '';
  @State isTyping: boolean = false;
  @State userProfile: UserProfile | null = null;
  private scroller: Scroller = new Scroller();

  aboutToAppear() {
    this.loadUserProfile();
    // 初始欢迎语
    this.addAiMessage("你好！我是你的健康小助手。我可以根据你的身体数据为你提供健康建议。");
  }

  async loadUserProfile() {
    const currentUser = AppStorage.get<UserInfo>('currentUser');
    if (currentUser) {
      try {
        const profile = await UserRepo.getUserProfile(currentUser.id);
        if (profile) {
          this.userProfile = profile;
          // 可以在这里根据画像主动发起第一轮分析
          this.analyzeHealthInitial();
        }
      } catch (e) {
        console.error('加载用户画像失败:', JSON.stringify(e));
      }
    }
  }

  analyzeHealthInitial() {
    if (!this.userProfile) return;
    
    let info = `我看到你的档案：${this.userProfile.gender}性，${this.userProfile.age}岁`;
    if (this.userProfile.height && this.userProfile.weight) {
      info += `，身高${this.userProfile.height}cm，体重${this.userProfile.weight}kg。`;
      // 简单的 BMI 计算
      const heightM = this.userProfile.height / 100;
      const bmi = this.userProfile.weight / (heightM * heightM);
      info += `\n你的BMI指数为：${bmi.toFixed(1)}。`;
    }
    this.addAiMessage(info + "\n有什么我可以帮你的吗？");
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
    // 简单延时确保列表渲染后滚动
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

    // --- 预留 AI 接口位置 ---
    // TODO: 这里将来替换为真实的 AI API 调用
    // const response = await callAiApi(text, this.userProfile);
    
    // 模拟网络延迟
    setTimeout(() => {
      this.isTyping = false;
      this.mockAiResponse(text);
    }, 1500);
  }

  mockAiResponse(userText: string) {
    let reply = "收到，这是一个很好的问题。";
    if (userText.includes("运动")) {
      reply = "根据你的年龄和体重，我建议你每周进行至少150分钟的中等强度有氧运动，比如快走或游泳。";
    } else if (userText.includes("饮食") || userText.includes("吃")) {
      reply = "建议保持均衡饮食，多摄入蔬菜水果，减少高糖高油食物的摄入。";
    } else {
      reply = "我现在还在学习中，稍后我会接入更强大的大脑来回答你的问题！(API 预留位)";
    }
    this.addAiMessage(reply);
  }

  build() {
    Column() {
      // 1. 标题栏
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_left'))//系统内置图标
          .fontSize(24)
          .fontColor([Color.Black])
          .onClick(() => router.back())
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
                // AI 头像
                Image($r('app.media.icon_heart_rate')) // 假设有个健康图标，或者用通用图标
                  .width(40).height(40)
                  .backgroundColor('#E3F2FD')
                  .borderRadius(20)
                  .padding(8)
                  .margin({ right: 10 })
                
                // AI 消息气泡
                Text(msg.content)
                  .fontSize(16)
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
        TextInput({ placeholder: '请输入你的健康问题...', text: this.inputText })
          .layoutWeight(1)
          .height(40)
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
