import { NavigationModel } from '../model/NavigationModel';
import router from '@ohos.router';
import  {MenuItem} from '../model/btn'// 定义菜单接口


@Entry({ routeName: 'HealthWellnessPage' })
@Component
export struct WellnessPage {

  // 菜单配置：映射你上传的图片 (注意：文件名必须对应你media目录下的实际文件名，且必须小写)
  private menuList: MenuItem[] = [
    { title: $r('app.string.menu_record'), iconImg: $r('app.media.books'), key: 'card_record' }, // 健康档案 -> books
    { title: $r('app.string.menu_vital'), iconImg: $r('app.media.heart_waves_fill'), key: 'card_vital' }, // 体征 -> heart
    { title: $r('app.string.menu_sport'), iconImg: $r('app.media.running'), key: 'btn_sport_health' }, // 运动 -> running
    { title: $r('app.string.menu_edu'), iconImg: $r('app.media.preach'), key: 'card_edu' }, // 宣教 -> preach
    { title: $r('app.string.menu_consult'), iconImg: $r('app.media.icon_consultation'), key: 'card_consult' }, // 问诊 -> consultation (记得改小写)
    { title: $r('app.string.menu_nurse'), iconImg: $r('app.media.icon_nurse'), key: 'card_nurse' }, // 护士 -> nurse (记得改小写)
    { title: $r('app.string.menu_drug'), iconImg: $r('app.media.medical'), key: 'card_drug' }, // 用药 -> medical
    { title: $r('app.string.menu_order'), iconImg: $r('app.media.icon_order_manage'), key: 'card_order' }, // 订单 -> order_manage (记得改名)
    { title: $r('app.string.menu_rehab'), iconImg: $r('app.media.brain'), key: 'card_rehab' }, // 康复 -> brain
    { title: $r('app.string.menu_more'), iconImg: $r('app.media.more'), key: 'card_more' }, // 更多 -> more
  ];

  build() {
    Column() {
      // ============================================================
      // 1. 顶部导航栏 (返回键 + 个人信息 + 设置)
      // ============================================================
      Row() {
        // 左侧：返回按钮
        Button() {
          Image($r('app.media.icon_back')) // [需补充图片]
            .width(24).height(24)
            .fillColor(Color.White) // 如果是白色透明底图，不需要fillColor；如果是黑色svg需反白
        }
        .backgroundColor(Color.Transparent)
        .onClick(() => {
          NavigationModel.goBack(); // 调用返回逻辑
        })

        // 中间：空白撑开
        Blank()

        // 右侧：用户信息组
        Row({ space: 15 }) {
          // 姓名块
          Row({ space: 5 }) {
            Image($r('app.media.icon_user_small')) // [需补充图片] 小人图标
              .width(16).height(16)
              .objectFit(ImageFit.Contain)
            Text("高子航")
              .fontSize(18)
              .fontColor(Color.White)
              .fontWeight(FontWeight.Bold)
          }

          // 电话块
          Row({ space: 5 }) {
            Image($r('app.media.icon_phone_small')) // [需补充图片] 手机图标
              .width(16).height(16)
              .objectFit(ImageFit.Contain)
            Text("17722827718")
              .fontSize(16)
              .fontColor(Color.White)
          }

          // 设置按钮
          Image($r('app.media.icon_settings')) // [需补充图片] 设置图标
            .width(24).height(24)
            .margin({ left: 10 })
        }
      }
      .width('100%')
      .height($r('app.float.header_height'))
      .padding({ left: 20, right: 20 })
      .backgroundColor($r('app.color.header_background')) // 深色底

      // ============================================================
      // 2. 主体布局 (左右分栏)
      // ============================================================
      Row({ space: 20 }) {

        // --- 左侧列 (权重 2) ---
        Column({ space: 20 }) {

          // 2.1 顶部个人详情卡片
          Row() {
            // 头像
            Image($r('app.media.user_avatar')) // [需补充图片]
              .width(60).height(60)
              .borderRadius(30)
              .margin({ right: 20 })

            Column({ space: 5 }) {
              Text("高子航").fontSize(22).fontColor(Color.White).fontWeight(FontWeight.Bold)
              Row({ space: 10 }) {
                Text("男").fontSize(14).fontColor(Color.White)
                Text("28岁").fontSize(14).fontColor(Color.White)
              }
            }.alignItems(HorizontalAlign.Start)

            Blank()

            Column({ space: 5 }) {
              Text("广东省第二人民医院").fontSize(16).fontColor(Color.White)
              Text("入住: 神经内科").fontSize(14).fontColor($r('app.color.text_cyan'))
            }.alignItems(HorizontalAlign.End)
          }
          .width('100%')
          .padding(20)
          .backgroundColor($r('app.color.bg_card'))
          .borderRadius($r('app.float.card_radius'))

          // 2.2 核心展示区 (悬浮气泡 + 右侧状态与呼叫)
          Row({ space: 20 }) {

            // A. 左侧：5个悬浮气泡 (替代3D模型)
            Stack() {

              // 气泡1：体温 (左上)
              this.HealthBubble("36.4°C", "体温", -110, -100)
              // 气泡2：心率 (右上)
              this.HealthBubble("78次", "心率/min", 90, -110)
              // 气泡3：血糖 (左中)
              this.HealthBubble("5.6", "血糖", -130, 20)
              // 气泡4：血氧 (右中)
              this.HealthBubble("98%", "血氧", 110, 40)
              // 气泡5：血压 (底部)
              this.HealthBubble("115/80", "血压", -20, 130)
            }
            .layoutWeight(1.5)
            .height('100%')
            .backgroundColor('rgba(0,0,0,0.2)') // 深色底
            .borderRadius($r('app.float.card_radius'))
            .clip(true)

            // B. 右侧：状态显示 + 一键呼叫
            Column({ space: 20 }) {

              // 上部分：环境与安防状态
              Column() {
                // 环境数据
                Row() {
                  Image($r('app.media.icon_sun')).width(16).height(16).margin({ right: 5 }) // [需补充]
                  Text("光照: 13Lx").fontSize(12).fontColor(Color.White)
                  Blank()
                  Image($r('app.media.icon_co2')).width(16).height(16).margin({ right: 5 }) // [需补充]
                  Text("CO2: 1305").fontSize(12).fontColor(Color.White)
                }.width('100%').margin({ bottom: 15 })

                Divider().color('rgba(255,255,255,0.2)').margin({ bottom: 15 })

                // 状态图标
                Row({ space: 20 }) {
                  Column() {
                    Image($r('app.media.icon_fall')).width(30).height(30) // [需补充]
                    Text("未摔倒").fontSize(14).fontColor(Color.White).margin({ top: 5 })
                  }
                  Column() {
                    Image($r('app.media.icon_bed_status')).width(30).height(30) // [需补充]
                    Text("离床").fontSize(14).fontColor(Color.White).margin({ top: 5 })
                  }
                }.justifyContent(FlexAlign.Center).width('100%')
              }
              .layoutWeight(1)
              .width('100%')
              .padding(15)
              .backgroundColor($r('app.color.bg_card'))
              .borderRadius($r('app.float.card_radius'))

              // 下部分：一键呼叫 (大按钮)
              Button() {
                Row({ space: 10 }) {
                  Image($r('app.media.icon_call_large')) // [需补充]
                    .width(32).height(32)
                    .fillColor(Color.White)
                  Text("一键呼叫")
                    .fontSize(22)
                    .fontColor(Color.White)
                    .fontWeight(FontWeight.Bold)
                }
              }
              .width('100%')
              .height(100)
              .backgroundColor($r('app.color.btn_call_bg')) // 红色背景
              .borderRadius($r('app.float.card_radius'))
              .onClick(() => {
                // 调用接口：一键呼叫
                NavigationModel.handleJump('btn_one_key_call');
              })
            }
            .layoutWeight(1)
            .height('100%')
          }
          .layoutWeight(1)
        }
        .layoutWeight(2)
        .height('100%')

        // --- 右侧列 (Grid 菜单 - 使用你提供的10张图) ---
        Column() {
          Grid() {
            ForEach(this.menuList, (item: MenuItem) => {
              GridItem() {
                Column() {
                  // 图标区域
                  Image(item.iconImg)
                    .width(48)
                    .height(48)
                    .objectFit(ImageFit.Contain)
                    .margin({ bottom: 10 })

                  Text(item.title)
                    .fontSize(16)
                    .fontColor(Color.White)
                }
                .width('100%').height('100%')
                .justifyContent(FlexAlign.Center)
                .backgroundColor($r('app.color.bg_card')) // 确保你的 color.json 里的 bg_card 是半透明的
                .borderRadius($r('app.float.card_radius'))
                .onClick(() => {
                  NavigationModel.handleJump(item.key);
                })
              }
            })
          }
          .columnsTemplate('1fr 1fr') // 2 列
          // 【关键修正】↓↓↓ 加上这行，把高度平均分成 5 行 ↓↓↓
          .rowsTemplate('1fr 1fr 1fr 1fr 1fr')
          .rowsGap(12).columnsGap(12)
          .width('100%').height('100%')
        }
        .layoutWeight(1)
        .height('100%')
      }
      .width('100%')
      .layoutWeight(1)
      .padding(20)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.bg_page')) // 全局深色背景
    .backgroundImage($r('app.media.bg_wellness'))
    .backgroundImageSize(ImageSize.Cover)
  }

  // --- 气泡构建函数 ---
  @Builder HealthBubble(value: string, label: string, x: number, y: number) {
    Column() {
      Text(value)
        .fontSize(20)
        .fontColor($r('app.color.text_cyan'))
        .fontWeight(FontWeight.Bold)
      Text(label)
        .fontSize(12)
        .fontColor($r('app.color.text_gray'))
    }
    .width(90)
    .height(90)
    .borderRadius(45)
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r('app.color.bubble_bg')) // 半透明黑底
    .border({ width: 1, color: $r('app.color.bubble_border') }) // 蓝色描边
    .shadow({ radius: 10, color: $r('app.color.bubble_border') }) // 发光效果
    .offset({ x: x, y: y }) // 绝对定位偏移
  }
}