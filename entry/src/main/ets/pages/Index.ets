import { btn } from '../model/btn'


@Entry
@Component
struct MainPage {
  @State showHome: boolean = true;
  @State showScene: boolean = false;


  private sceneList :btn[]= [
    { key: 'btn_warm_home', icon: 'temp_home' },
    { key: 'btn_safe_leave', icon: 'temp_home' },
    { key: 'btn_full_temp', icon: 'full_temp' },
    { key: 'btn_dehumidify', icon: 'dehumidify' },
    { key: 'btn_ventilation', icon: 'ventilation' },
    { key: 'btn_more_scenes', icon: 'foreground' },
    { key: 'btn_one_key_call', icon: 'ventilation' },
    { key: 'btn_sport_health', icon: 'foreground' }
  ];

  build() {
    Column() {
      // 1. 顶部导航栏 (保持原样)
      Row({ space: $r('app.float.space_row_extra') }) {
        Text($r('app.string.time_placeholder'))
          .fontSize($r('app.float.font_size_large'))
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_white'))

        Image($r('app.media.home_icon'))
          .width($r('app.float.icon_normal'))
          .height($r('app.float.icon_normal'))
          .margin($r('app.float.margin_small'))
          .opacity(this.showHome ? 1 : 0.5)

        Image($r('app.media.sofa_icon'))
          .width($r('app.float.icon_normal'))
          .height($r('app.float.icon_normal'))
          .margin($r('app.float.margin_small'))
          .opacity(this.showScene ? 1 : 0.5)
      }
      .backgroundColor($r('app.color.bg_page'))
      .padding($r('app.float.margin_small'))
      .width('100%')


      // 2. 内容区域：使用 Row 实现三列布局
      // 采用 Grid 实现左侧场景的 2x4 排列
      Row({ space: $r('app.float.space_row_wide') }) {

        // --- A. 左侧：8个场景按钮 (2列 x 4行)
        Grid() {
          ForEach(this.sceneList, (item: btn) => {
            GridItem() {
              Button() {
                Row({ space: $r('app.float.space_row') }) {
                  Column()
                  {
                    Image($r(`app.media.${item.icon}`))
                      .width($r('app.float.icon_normal'))
                      .height($r('app.float.icon_normal'))
                  }
                  .width('30%')
                  Column()
                  {
                    Text($r(`app.string.${item.key}`))
                      .fontSize($r('app.float.font_size_normal'))
                      .fontColor($r('app.color.text_white'))
                  }
                  .width('50%')

                }
                // 修正：确保 Row 内子组件垂直居中对齐
                .width('100%')
                .alignItems(VerticalAlign.Center)
                .justifyContent(FlexAlign.SpaceAround)

              }
              .backgroundColor($r('app.color.bg_card'))
              .borderRadius($r('app.float.radius_card'))
              .width(120)
              .height($r('app.float.card_height_default'))
            }
            .margin($r('app.float.margin_small'))
          }, (item: btn) => item.key) // 使用 key 作为唯一标识
        }
        .columnsTemplate('1fr 1fr') // 2 列，每列平均分配空间
        .columnsGap($r('app.float.margin_small'))
        .rowsGap($r('app.float.margin_small'))
        .layoutWeight(1.2) // 赋予权重，占据第一列空间，略宽于普通卡片

        // --- B. 中间 + 右侧：卡片区域 (使用 Row 包裹两个 Column，实现剩下的两列)
        Row({ space: $r('app.float.space_row_wide') }) {

          // --- B1. 中间列：家庭能耗 + 家庭安防 + 在线问诊 (内容已完整补充)
          Column() {
            // 家庭能耗
            Column() {
              Text($r('app.string.card_energy_title'))
                .fontSize($r('app.float.font_size_normal'))
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_white'))
              Text($r('app.string.card_energy_power'))
                .fontSize($r('app.float.font_size_xlarge'))
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_white'))
              Text($r('app.string.card_energy_today'))
                .fontSize($r('app.float.font_size_small'))
                .fontColor($r('app.color.text_gray'))
              Text($r('app.string.card_energy_carbon'))
                .fontSize($r('app.float.font_size_small'))
                .fontColor($r('app.color.text_gray'))
                .margin({ top: $r('app.float.margin_tiny') })
            }
            .backgroundColor($r('app.color.bg_card'))
            .borderRadius($r('app.float.radius_card'))
            .margin($r('app.float.margin_small'))
            .padding($r('app.float.margin_normal'))
            .width('100%')
            .layoutWeight(1)

            // 家庭安防
            Column() {
              Text($r('app.string.card_security_title'))
                .fontSize($r('app.float.font_size_normal'))
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_white'))
              Text($r('app.string.card_security_status'))
                .fontSize($r('app.float.font_size_xlarge'))
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_red'))
              Text($r('app.string.card_security_desc'))
                .fontSize($r('app.float.font_size_small'))
                .fontColor($r('app.color.text_gray'))
                .margin({ top: $r('app.float.margin_tiny') })

              Row({ space: $r('app.float.space_row') }) {
                Button() {
                  Image($r('app.media.alarm_active'))
                    .width($r('app.float.icon_small'))
                    .height($r('app.float.icon_small'))
                }
                .backgroundColor($r('app.color.btn_green'))
                .borderRadius($r('app.float.radius_card'))
                .margin($r('app.float.margin_tiny'))

                Button() {
                  Image($r('app.media.alarm_exit'))
                    .width($r('app.float.icon_small'))
                    .height($r('app.float.icon_small'))
                }
                .backgroundColor($r('app.color.btn_red'))
                .borderRadius($r('app.float.radius_card'))
                .margin($r('app.float.margin_tiny'))
              }
              .justifyContent(FlexAlign.Center)
            }
            .backgroundColor($r('app.color.bg_card'))
            .borderRadius($r('app.float.radius_card'))
            .margin($r('app.float.margin_small'))
            .padding($r('app.float.margin_normal'))
            .width('100%')
            .layoutWeight(1)

            // 在线问诊
            Column() {
              Button() {
                Row()
                {
                  Column() {
                    Text($r('app.string.card_consult_title'))
                      .fontSize($r('app.float.font_size_normal'))
                      .fontWeight(FontWeight.Bold)
                      .fontColor($r('app.color.text_white'))
                    Text($r('app.string.card_consult_time'))
                      .fontSize($r('app.float.font_size_small'))
                      .fontColor($r('app.color.text_gray'))
                      .margin({ top: $r('app.float.margin_tiny') })
                  }
                  .width('60%')
                  .justifyContent(FlexAlign.SpaceBetween)

                  Image($r('app.media.video_call'))
                    .width($r('app.float.icon_large'))
                    .height($r('app.float.icon_large'))
                }
                .justifyContent(FlexAlign.SpaceBetween)

              }
              .backgroundColor($r('app.color.bg_card'))
              .width('100%')
              .height('100%')
            }
            .backgroundColor($r('app.color.bg_card'))
            .borderRadius($r('app.float.radius_card'))
            .margin($r('app.float.margin_small'))
            .padding($r('app.float.margin_normal'))
            .width('100%')
            .layoutWeight(1)
          }
          .layoutWeight(1.5) // 赋予权重，作为中间列

          // --- B2. 右侧列：居家康养 + 家庭网络 + 可视对讲 (内容已完整补充)
          Column() {
            // 居家康养
            Row() {
              Button()
              {
                Row()
                {
                  Column()
                  {
                    Text($r('app.string.card_health_title'))
                      .fontSize($r('app.float.font_size_normal'))
                      .fontWeight(FontWeight.Bold)
                      .fontColor($r('app.color.text_white'))
                    Text($r('app.string.card_health_sleep'))
                      .fontSize($r('app.float.font_size_large'))
                      .fontWeight(FontWeight.Bold)
                      .fontColor($r('app.color.text_white'))
                    Text($r('app.string.card_health_value'))
                      .fontSize($r('app.float.font_size_small'))
                      .fontColor($r('app.color.text_gray'))
                      .margin({ top: $r('app.float.margin_tiny') })
                  }
                  .backgroundColor($r('app.color.bg_card'))
                  .borderRadius($r('app.float.radius_card'))
                  .margin($r('app.float.margin_small'))
                  .padding($r('app.float.margin_normal'))
                  .width('100%')
                  .layoutWeight(1)

                  Image($r('app.media.sleep_quality'))
                    .width($r('app.float.image_health_size'))
                    .height($r('app.float.image_health_size'))
                    .borderRadius($r('app.float.radius_card'))
                    .margin({ top: $r('app.float.margin_small') })
                    .layoutWeight(1)
                }
              }
              .backgroundColor($r('app.color.bg_card'))

            }
            .backgroundColor($r('app.color.bg_card'))
            .borderRadius($r('app.float.radius_card'))
            .margin($r('app.float.margin_small'))
            .padding($r('app.float.margin_normal'))
            .width('100%')
            .layoutWeight(1)

            // 家庭网络
            Column() {
              Button()
              {
                Row()
                {
                  Column()
                  {
                    Text($r('app.string.card_network_title'))
                      .fontSize($r('app.float.font_size_normal'))
                      .fontWeight(FontWeight.Bold)
                      .fontColor($r('app.color.text_white'))
                    Text($r('app.string.card_network_quality'))
                      .fontSize($r('app.float.font_size_large'))
                      .fontWeight(FontWeight.Bold)
                      .fontColor($r('app.color.text_white'))
                    Text($r('app.string.card_network_speed_up'))
                      .fontSize($r('app.float.font_size_small'))
                      .fontColor($r('app.color.text_gray'))
                    Text($r('app.string.card_network_speed_down'))
                      .fontSize($r('app.float.font_size_small'))
                      .fontColor($r('app.color.text_gray'))
                      .margin({ top: $r('app.float.margin_tiny') })
                  }
                  .width('50%')
                  .justifyContent(FlexAlign.SpaceBetween)


                  Image($r('app.media.network_speed'))
                    .width($r('app.float.icon_large'))
                    .height($r('app.float.icon_large'))
                }
                .width('90%')
                .justifyContent(FlexAlign.SpaceBetween)



              }
              .width('100%')
              .height('100%')
              .backgroundColor($r('app.color.bg_card'))
            }
            .backgroundColor($r('app.color.bg_card'))
            .borderRadius($r('app.float.radius_card'))
            .margin($r('app.float.margin_small'))
            .padding($r('app.float.margin_normal'))
            .width('100%')
            .layoutWeight(1)

            // 可视对讲
            Column() {
              Text($r('app.string.card_intercom_title'))
                .fontSize($r('app.float.font_size_normal'))
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_white'))

              Row({ space: $r('app.float.space_row') }) {
                Button() {
                  Image($r('app.media.door_intercom'))
                    .width($r('app.float.icon_normal'))
                    .height($r('app.float.icon_normal'))
                }
                .backgroundColor($r('app.color.bg_card'))
                .borderRadius($r('app.float.radius_card'))
                .margin($r('app.float.margin_tiny'))

                Button() {
                  Image($r('app.media.camera_monitor'))
                    .width($r('app.float.icon_normal'))
                    .height($r('app.float.icon_normal'))
                }
                .backgroundColor($r('app.color.bg_card'))
                .borderRadius($r('app.float.radius_card'))
                .margin($r('app.float.margin_tiny'))
              }
              .justifyContent(FlexAlign.Center)
            }
            .backgroundColor($r('app.color.bg_card'))
            .borderRadius($r('app.float.radius_card'))
            .margin($r('app.float.margin_small'))
            .padding($r('app.float.margin_normal'))
            .width('100%')
            .layoutWeight(1)
          }
          .layoutWeight(1.5) // 赋予权重，作为右侧列
        }
        .layoutWeight(3) // 右侧卡片区域占据主 Row 的大部分空间
        .height('100%') // 确保卡片区域占满垂直空间

      }
      .width('100%')
      .layoutWeight(1) // 内容区域占据剩余所有垂直空间
      .padding($r('app.float.margin_small'))
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.bg_page'))
    .backgroundImage($r('app.media.bg'))
    .backgroundImageSize(ImageSize.Cover)
  }
}