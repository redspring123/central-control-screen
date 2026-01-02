import router from '@ohos.router';
// [重要] 引入目标页面文件，确保 @Entry 装饰器执行，从而注册命名路由
import './DoctorChatPage';
import './DoctorEditPage';
import { Doctor } from '../model/DoctorModel';
import { DoctorDao } from '../database/DoctorDao';
import { UserInfo } from 'auth';
import { AppDatabase } from 'utils';

@Entry({ routeName: 'MedicalOnlineConsultPage' })
@Component
export struct OnlineConsultPage {
  // 2. 定义状态变量
  @State searchName: string = '';       // [新增] 搜索医生名字
  @State searchHospital: string = '';   // 搜索医院
  @State searchDepartment: string = ''; // 搜索科室
  @State isAdmin: boolean = false;      // [新增] 是否为管理员

  // 医生总数据（数据库）
  @State doctorList: Doctor[] = [];

  // 当前显示在界面上的列表（筛选后的结果）
  @State displayList: Doctor[] = [];

  // 页面加载时，默认显示所有医生
  async aboutToAppear() {
    // await DoctorDao.initMockData(); // 移除模拟数据初始化
    
    // 检查管理员权限
    const currentUser = AppStorage.get<UserInfo>('currentUser');
    if (currentUser && currentUser.isAdmin) {
      this.isAdmin = true;
    }

    this.loadData();
  }

  onPageShow() {
    this.loadData();
  }

  async loadData() {
    this.doctorList = await DoctorDao.getDoctors(this.searchName, this.searchHospital, this.searchDepartment);
    this.displayList = this.doctorList;
  }

  // 3. 筛选逻辑 [修改]
  handleSearch() {
    this.loadData();
  }

  // 4. 重置逻辑 [修改]
  handleReset() {
    this.searchName = '';       // [新增] 清空名字输入
    this.searchHospital = '';
    this.searchDepartment = '';
    this.loadData();
  }

  async handleDelete(id: number) {
    await DoctorDao.deleteDoctor(id);
    this.loadData();
  }

  @Builder DoctorMenu(doctor: Doctor) {
    Menu() {
      MenuItem({ content: '编辑' })
        .onClick(() => {
          router.pushNamedRoute({
            name: 'DoctorEditPage',
            params: { id: doctor.id }
          });
        })
      MenuItem({ content: '删除' })
        .onClick(() => {
          this.handleDelete(doctor.id);
        })
    }
  }


  build() {
    Column() {
      // ================= 顶部标题栏 =================
      Row() {
        Image($r('app.media.icon_back'))
          .width(24).height(24)
          .fillColor(Color.White)
          .onClick(() => {
            router.back();
          })

        Text('问诊医生')
          .fontSize(18)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)

        if (this.isAdmin) {
          Row() {
            Text('Debug')
              .fontSize(12)
              .fontColor(Color.Yellow)
              .margin({ right: 8 })
              .onClick(() => {
                AppDatabase.dumpToLog();
              })
            Text('添加')
              .fontSize(16)
              .fontColor(Color.White)
              .onClick(() => {
                 router.pushNamedRoute({ name: 'DoctorEditPage' });
              })
          }
        } else {
          Blank().width(32) // 占位，保持标题居中
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })

      // ================= 搜索筛选区域 =================
      Column({ space: 10 }) {
        // [新增] 第一行：医生姓名搜索
        TextInput({ placeholder: '请输入医生姓名查找', text: this.searchName })
          .width('100%')
          .height(40)
          .placeholderColor('#888888')
          .fontColor(Color.White)
          .backgroundColor($r('app.color.input_bg'))
          .borderRadius(8)
          .onChange((value: string) => {
            this.searchName = value;
          })

        // 第二行：医院 + 科室 + 按钮
        Row({ space: 10 }) {
          // 医院输入框
          TextInput({ placeholder: '筛选医院', text: this.searchHospital })
            .layoutWeight(1)
            .height(40)
            .placeholderColor('#888888')
            .fontColor(Color.White)
            .backgroundColor($r('app.color.input_bg'))
            .borderRadius(8)
            .onChange((value: string) => {
              this.searchHospital = value;
            })

          // 科室输入框
          TextInput({ placeholder: '筛选科室', text: this.searchDepartment })
            .layoutWeight(1)
            .height(40)
            .placeholderColor('#888888')
            .fontColor(Color.White)
            .backgroundColor($r('app.color.input_bg'))
            .borderRadius(8)
            .onChange((value: string) => {
              this.searchDepartment = value;
            })

          // 搜索按钮
          Button() {
            Image($r('app.media.icon_search'))
              .width(20)
              .height(20)
              .fillColor(Color.White)
              .objectFit(ImageFit.Contain)
          }
          .width(40).height(40)
          .backgroundColor($r('app.color.btn_blue'))
          .onClick(() => this.handleSearch())

          // 重置按钮
          Button() {
            Image($r('app.media.icon_reset'))
              .width(20)
              .height(20)
              .fillColor(Color.White)
              .objectFit(ImageFit.Contain)
          }
          .width(40).height(40)
          .backgroundColor($r('app.color.btn_blue'))
          .onClick(() => this.handleReset())
        }
        .width('100%')
      }
      .padding({ left: 16, right: 16, bottom: 10 }) // 给整个搜索区加边距

      // ================= 医生列表 (Grid网格布局) =================
      Grid() {
        ForEach(this.displayList, (doctor: Doctor) => {
          GridItem() {
            Stack({ alignContent: Alignment.TopEnd }) {
              Column() {
                Image($r('app.media.icon_doctor'))
                  .width(50).height(50)
                  .objectFit(ImageFit.Contain)
                  .fillColor(Color.White)
                  .margin({ top: 15, bottom: 8 })

                Text(doctor.name + ' ' + doctor.title)
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(Color.White)
                  .margin({ bottom: 4 })

                Text(`${doctor.hospital}(${doctor.department})`)
                  .fontSize(12)
                  .fontColor($r('app.color.text_gray_light'))
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                .margin({ bottom: 6 })

              Text(`挂号费: ¥${doctor.fee}`)
                .fontSize(12)
                .fontColor('#FFC107')
                .fontWeight(FontWeight.Medium)
                .margin({ bottom: 8 })

                Column() {
                  Text('擅长：' + doctor.specialty)
                    .fontSize(11)
                    .fontColor(Color.White)
                    .maxLines(3)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
                .width('100%')
                .padding(8)
                .backgroundColor('#20000000')
                .borderRadius({ bottomLeft: 12, bottomRight: 12 })
                .flexGrow(1)
              }
              .width('100%')
              .height(180)
              .linearGradient({
                angle: 135,
                colors: [[$r('app.color.card_gradient_start'), 0.0], [$r('app.color.card_gradient_end'), 1.0]]
              })
              .borderRadius(12)
              .alignItems(HorizontalAlign.Center)
              .onClick(() => {
                console.info(`点击了医生: ${doctor.name}`);
                try {
                  router.pushNamedRoute({
                    name: 'DoctorChatPage',
                    params: doctor
                  });
                } catch (e) {
                  console.error(`路由跳转异常: ${JSON.stringify(e)}`);
                }
              })

              // 管理员操作按钮
              if (this.isAdmin) {
                Text('管理')
                  .fontSize(12)
                  .fontColor(Color.White)
                  .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                  .backgroundColor('#40000000')
                  .borderRadius(4)
                  .margin(8)
                  .bindMenu(this.DoctorMenu(doctor))
              }
            }
          }
        })
      }
      .columnsTemplate('1fr 1fr')
      .rowsGap(12)
      .columnsGap(12)
      .padding(16)
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.bg_page_dark'))
  }
}