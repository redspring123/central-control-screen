import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

@Entry({ routeName: 'HealthSportsPage' })
@Component
export struct SportsPage {
  build() {
    Column() {
      // 顶部标题栏，含返回按钮
      Row({ space: 10 }) {
        Button() {
          Image($r('app.media.icon_back'))
            .width(20).height(20)
            .objectFit(ImageFit.Contain)
            .fillColor(Color.White)
        }
        .type(ButtonType.Normal)
        .backgroundColor(Color.Transparent)
        .onClick(() => {
          try {
            router.back();
          } catch (e) {
            try { promptAction.showToast({ message: $r('app.string.btn_back') }); } catch (err) { console.error('showToast failed', err); }
          }
        })

        Text($r('app.string.menu_sport'))
          .fontSize($r('app.float.text_title'))
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_white'))
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
      }
      .padding({ left: 16, right: 16, top: 18, bottom: 18 })
      .height(72)

      // 把导航栏下面的内容放到一个带背景图的容器中，确保导航栏本身不被背景覆盖
      Column() {
        // 统计卡片行：热量消耗 & 步数
        Row({ space: 12 }) {
          // 热量消耗
          Column() {
            Row({ space: 8 }) {
              Image($r('app.media.icon_kcal'))
                .width(36).height(36)
                .objectFit(ImageFit.Contain)
              Column() {
                Text($r('app.string.kcal_label'))
                  .fontSize($r('app.float.text_norm'))
                  .fontColor($r('app.color.text_gray'))
                Text('420 kcal')
                  .fontSize($r('app.float.text_xlarge'))
                  .fontWeight(FontWeight.Bold)
                  .fontColor($r('app.color.text_white'))
              }
            }
            .padding($r('app.float.page_padding'))
          }
          .backgroundColor($r('app.color.bg_card'))
          .borderRadius($r('app.float.card_radius'))
          .layoutWeight(1)
          .height(120)

          // 步数
          Column() {
            Row({ space: 8 }) {
              Image($r('app.media.icon_run'))
                .width(36).height(36)
                .objectFit(ImageFit.Contain)
              Column() {
                Text($r('app.string.steps_label'))
                  .fontSize(16)
                  .fontColor($r('app.color.text_gray'))
                Text('6,432 步')
                  .fontSize(32)
                  .fontWeight(FontWeight.Bold)
                  .fontColor($r('app.color.text_white'))
              }
            }
            .padding($r('app.float.page_padding'))
          }
          .backgroundColor($r('app.color.bg_card'))
          .borderRadius($r('app.float.card_radius'))
          .layoutWeight(1)
          .height(120)
        }
        .padding({ left: 16, right: 16, top: 8 })

        // 主要内容：示例卡片和统计
        Column({ space: 12 }) {
          // 合并并放大为单个主要记录卡片
          Column() {
            Text($r('app.string.sport_record'))
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_gray'))
            Text('6,432 步')
              .fontSize(40)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_white'))
              .margin({ top: 8, bottom: 12 })

            // 运动历史（放大字号便于阅读）
            Text('- 05-01: 5,200 步\n- 05-02: 7,100 步\n- 05-03: 6,432 步')
              .fontSize(18)
              .fontColor($r('app.color.text_white'))
              .lineHeight(26)
          }
          .backgroundColor($r('app.color.bg_card'))
          .borderRadius($r('app.float.card_radius'))
          .padding($r('app.float.page_padding'))
          .height(240)
          .justifyContent(FlexAlign.Center)

          // 开始记录按钮（保持在卡片下方）
          Button() {
            Row({ space: 10 }) {
              Image($r('app.media.running'))
                .width(20).height(20)
                .objectFit(ImageFit.Contain)
              Text($r('app.string.record_start'))
                .fontSize($r('app.float.text_norm'))
                .fontColor($r('app.color.text_white'))
            }
          }
          .backgroundColor($r('app.color.btn_call_bg'))
          .borderRadius($r('app.float.card_radius'))
          .padding($r('app.float.page_padding'))
          .onClick(() => {
            try { promptAction.showToast({ message: '开始记录运动（示例）' }); } catch (e) { console.error('showToast failed', e); }
          })
        }
        .padding({ left: 16, right: 16, top: 8 })
        .width('100%')
        .layoutWeight(1)
      }
      .backgroundImage($r('app.media.bg_wellness'))
      .backgroundImageSize(ImageSize.Cover)
      .backgroundColor($r('app.color.bg_page'))

    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.bg_page'))
  }
}
