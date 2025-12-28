import router from '@ohos.router';

// 1. 定义医生数据模型
// 就像定义一张名片的格式，方便后面存放数据
class Doctor {
  id: number = 0;
  name: string = '';
  title: string = '';       // 职称
  hospital: string = '';    // 医院
  department: string = '';  // 科室
  specialty: string = '';   // 擅长
  fee: number = 0;         // 费用
}

// ⚠️ 注意：这里的 routeName 必须和后面跳转时用的一样
@Entry({ routeName: 'MedicalOnlineConsultPage' })
@Component
export struct OnlineConsultPage {
  // 2. 定义状态变量
  // 搜索框里的文字，用户输入时会变
  @State searchHospital: string = '';
  @State searchDepartment: string = '';

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

  // 3. 筛选逻辑
  handleSearch() {
    this.displayList = this.doctorList.filter((item) => {
      // 检查医院名字是否包含输入的字
      const matchHospital = item.hospital.includes(this.searchHospital);
      // 检查科室名字是否包含输入的字
      const matchDept = item.department.includes(this.searchDepartment);
      // 两个条件都满足才显示
      return matchHospital && matchDept;
    });
  }

  // 4. 重置逻辑
  handleReset() {
    this.searchHospital = '';
    this.searchDepartment = '';
    this.displayList = this.doctorList; // 恢复显示所有
  }

  build() {
    Column() {
      // ================= 顶部标题栏 =================
      Row() {
        // 返回按钮
        Image($r('app.media.icon_back'))
          .width(24).height(24)
          .fillColor(Color.White)
          .onClick(() => {
            router.back(); // 返回上一页
          })

        Text('问诊医生')
          .fontSize(18)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)

        // 空白占位，为了让标题居中
        Blank().width(24)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })

      // ================= 搜索筛选栏 =================
      Row({ space: 10 }) {
        // 医院输入框
        TextInput({ placeholder: '请选择医院', text: this.searchHospital })
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
        TextInput({ placeholder: '请选择科室', text: this.searchDepartment })
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
          Image($r('app.media.icon_search')) // 引用你的图标
            .width(20)
            .height(20)
            .fillColor(Color.White) // 如果是 SVG 图标，这行可以让它变白；如果是 PNG/JPG，这行可能无效但没坏处
            .objectFit(ImageFit.Contain)
        }
        .width(40).height(40)
        .backgroundColor($r('app.color.btn_blue'))
        .onClick(() => this.handleSearch())

        // 重置按钮
        Button() {
          Image($r('app.media.icon_reset')) // 引用你的图标
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
      .padding({ left: 16, right: 16, bottom: 10 })

      // ================= 医生列表 (Grid网格布局) =================
      Grid() {
        ForEach(this.displayList, (doctor: Doctor) => {
          GridItem() {
            // ---- 单个医生卡片 ----
            Column() {
              // 1. 头像
              Image($r('app.media.icon_doctor'))
                .width(50).height(50)
                .objectFit(ImageFit.Contain)
                .fillColor(Color.White) // 变成白色图标
                .margin({ top: 15, bottom: 8 })

              // 2. 名字和职称
              Text(doctor.name + ' ' + doctor.title)
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
                .margin({ bottom: 4 })

              // 3. 医院和科室
              Text(`${doctor.hospital}(${doctor.department})`)
                .fontSize(12)
                .fontColor($r('app.color.text_gray_light'))
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .margin({ bottom: 12 })

              // 4. 擅长介绍 (深色半透明背景区域)
              Column() {
                Text('擅长：' + doctor.specialty)
                  .fontSize(11)
                  .fontColor(Color.White)
                  .maxLines(3)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
              }
              .width('100%')
              .padding(8)
              .backgroundColor('#20000000') // 半透明黑
              .borderRadius({ bottomLeft: 12, bottomRight: 12 }) // 底部圆角
              .flexGrow(1) // 填满剩余空间
            }
            .width('100%')
            .height(180)
            // 渐变背景色
            .linearGradient({
              angle: 135,
              colors: [[$r('app.color.card_gradient_start'), 0.0], [$r('app.color.card_gradient_end'), 1.0]]
            })
            .borderRadius(12)
            .alignItems(HorizontalAlign.Center)
            // 点击卡片事件
            .onClick(() => {
              console.info(`点击了医生: ${doctor.name}`);
              // 如果以后要跳到医生详情页，在这里写 router.pushUrl...
            })
          }
        })
      }
      .columnsTemplate('1fr 1fr') // 两列布局
      .rowsGap(12)
      .columnsGap(12)
      .padding(16)
      .layoutWeight(1) // 占满剩余屏幕高度

    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.bg_page_dark')) // 页面深色背景
  }
}