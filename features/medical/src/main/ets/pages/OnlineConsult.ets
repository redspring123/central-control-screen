import router from '@ohos.router';
// [重要] 引入目标页面文件，确保 @Entry 装饰器执行，从而注册命名路由
import './DoctorChatPage';

// 1. 定义医生数据模型
class Doctor {
  id: number = 0;
  name: string = '';
  title: string = '';       // 职称
  hospital: string = '';    // 医院
  department: string = '';  // 科室
  specialty: string = '';   // 擅长
  fee: number = 0;          // 费用
}

@Entry({ routeName: 'MedicalOnlineConsultPage' })
@Component
export struct OnlineConsultPage {
  // 2. 定义状态变量
  @State searchName: string = '';       // [新增] 搜索医生名字
  @State searchHospital: string = '';   // 搜索医院
  @State searchDepartment: string = ''; // 搜索科室

  // 医生总数据（模拟数据库）
  @State doctorList: Doctor[] = [
    { id: 1, name: '张扬', title: '主任医生', hospital: '广东省第二人民医院', department: '神经内科', specialty: '心血管疾病、脑血管意外后遗症康复', fee: 50 },
    { id: 2, name: '李子傲', title: '主任医生', hospital: '广东省第二人民医院', department: '神经内科', specialty: '高血压、失眠、焦虑症、头痛', fee: 50 },
    { id: 3, name: '王康', title: '副主任医师', hospital: '中山一院', department: '骨科', specialty: '颈椎病、腰椎间盘突出、脊柱侧弯', fee: 60 },
    { id: 4, name: '陈美', title: '主治医师', hospital: '市一医院', department: '皮肤科', specialty: '皮炎、湿疹、痤疮、过敏', fee: 30 },
    {
      id: 5, name: '赵敏', title: '副主任医师', hospital: '广州市妇女儿童医疗中心', department: '妇科',
      specialty: '月经不调、妇科炎症、宫颈疾病、备孕指导', fee: 45
    },
    {
      id: 6, name: '钱伟', title: '主治医师', hospital: '广州市妇女儿童医疗中心', department: '儿科',
      specialty: '小儿感冒、发烧、咳嗽、消化不良、生长发育', fee: 35
    },
    {
      id: 7, name: '孙强', title: '主任医师', hospital: '中山大学中山眼科中心', department: '眼科',
      specialty: '近视矫正、白内障、青光眼、眼底病变', fee: 80
    },
    {
      id: 8, name: '周杰', title: '主治医师', hospital: '广东省口腔医院', department: '口腔科',
      specialty: '牙齿矫正、种植牙、智齿拔除、牙周治疗', fee: 40
    }
  ];

  // 当前显示在界面上的列表（筛选后的结果）
  @State displayList: Doctor[] = [];

  // 页面加载时，默认显示所有医生
  aboutToAppear() {
    this.displayList = this.doctorList;
  }

  // 3. 筛选逻辑 [修改]
  handleSearch() {
    this.displayList = this.doctorList.filter((item) => {
      // [新增] 检查名字
      const matchName = item.name.includes(this.searchName);
      // 检查医院名字
      const matchHospital = item.hospital.includes(this.searchHospital);
      // 检查科室名字
      const matchDept = item.department.includes(this.searchDepartment);

      // 三个条件必须同时满足 (如果是空字符串，includes也会返回true，所以不影响)
      return matchName && matchHospital && matchDept;
    });
  }

  // 4. 重置逻辑 [修改]
  handleReset() {
    this.searchName = '';       // [新增] 清空名字输入
    this.searchHospital = '';
    this.searchDepartment = '';
    this.displayList = this.doctorList; // 恢复显示所有
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

        Blank().width(24)
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
                .margin({ bottom: 12 })

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