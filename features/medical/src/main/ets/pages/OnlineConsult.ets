import router from '@ohos.router';

@Entry({ routeName: 'MedicalOnlineConsultPage' })
@Component
export struct OnlineConsultPage {
  build() {
    Column() {
      // Top bar with Back button and centered title
      Row() {
        // Back button
        Button() {
          Image($r('app.media.icon_back'))
            .width(24).height(24)
            .fillColor(Color.White)
        }
        .backgroundColor(Color.Transparent)
        .onClick(() => {
          // go back to previous page
          try { router.back(); } catch (e) { console.error('back failed', e); }
        })

        // Spacer to push title to center
        Blank().layoutWeight(1)

        Text($r('app.string.online_consult_title') || '在线问诊')
          .fontSize($r('app.float.font_size_large'))
          .fontColor($r('app.color.text_white'))
          .fontWeight(FontWeight.Bold)

        // Matching spacer on the right so title stays centered
        Blank().layoutWeight(1)
      }
      .alignItems(VerticalAlign.Center)
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })
      .backgroundColor($r('app.color.bg_header') || $r('app.color.bg_primary'))

      // Doctor list - showing multiple doctors
      List() {
        ListItem() {
          // Doctor card — richer info similar to project style
          Column() {
            Row({ space: 12 }) {
              Image($r('app.media.icon_doctor'))
                .width(80)
                .height(80)
                .objectFit(ImageFit.Contain)
                .borderRadius(8)

              Column() {
                Row() {
                  Column() {
                    Text('张医生')
                      .fontSize($r('app.float.font_size_xlarge'))
                      .fontWeight(FontWeight.Bold)
                      .fontColor($r('app.color.text_primary'))

                    Text('主任医师 · 心内科')
                      .fontSize($r('app.float.font_size_small'))
                      .fontColor($r('app.color.text_gray'))
                      .margin({ top: 4 })
                  }

                  // fee and rating aligned to the right within the card row
                  Column() {
                    Text('¥50')
                      .fontSize($r('app.float.font_size_normal'))
                      .fontColor($r('app.color.primary'))
                      .fontWeight(FontWeight.Bold)
                      .alignSelf(ItemAlign.End)

                    Text('评分 4.8')
                      .fontSize($r('app.float.font_size_small'))
                      .fontColor($r('app.color.text_gray'))
                      .alignSelf(ItemAlign.End)
                      .margin({ top: 6 })
                  }
                  .justifyContent(FlexAlign.Center)
                  .layoutWeight(1)
                }

                // tags / brief intro
                Text('从事心血管疾病临床工作15年，擅长高血压、冠心病等。')
                  .fontSize($r('app.float.font_size_small'))
                  .fontColor($r('app.color.text_gray'))
                  .maxLines(2)
                  .margin({ top: 8 })
              }
              .justifyContent(FlexAlign.Center)
            }
            .padding($r('app.float.margin_normal'))
            .backgroundColor($r('app.color.bg_card'))
            .borderRadius($r('app.float.radius_card'))
            .margin($r('app.float.margin_small'))
          }
        }
        
        // Additional doctors
        ListItem() {
          Column() {
            Row({ space: 12 }) {
              Image($r('app.media.icon_doctor'))
                .width(80)
                .height(80)
                .objectFit(ImageFit.Contain)
                .borderRadius(8)

              Column() {
                Row() {
                  Column() {
                    Text('李医生')
                      .fontSize($r('app.float.font_size_xlarge'))
                      .fontWeight(FontWeight.Bold)
                      .fontColor($r('app.color.text_primary'))

                    Text('副主任医师 · 内分泌科')
                      .fontSize($r('app.float.font_size_small'))
                      .fontColor($r('app.color.text_gray'))
                      .margin({ top: 4 })
                  }

                  Column() {
                    Text('¥40')
                      .fontSize($r('app.float.font_size_normal'))
                      .fontColor($r('app.color.primary'))
                      .fontWeight(FontWeight.Bold)
                      .alignSelf(ItemAlign.End)

                    Text('评分 4.7')
                      .fontSize($r('app.float.font_size_small'))
                      .fontColor($r('app.color.text_gray'))
                      .alignSelf(ItemAlign.End)
                      .margin({ top: 6 })
                  }
                  .justifyContent(FlexAlign.Center)
                  .layoutWeight(1)
                }

                Text('从事内分泌疾病临床工作12年，擅长糖尿病、甲状腺疾病等。')
                  .fontSize($r('app.float.font_size_small'))
                  .fontColor($r('app.color.text_gray'))
                  .maxLines(2)
                  .margin({ top: 8 })
              }
              .justifyContent(FlexAlign.Center)
            }
            .padding($r('app.float.margin_normal'))
            .backgroundColor($r('app.color.bg_card'))
            .borderRadius($r('app.float.radius_card'))
            .margin($r('app.float.margin_small'))
          }
        }
        
        ListItem() {
          Column() {
            Row({ space: 12 }) {
              Image($r('app.media.icon_doctor'))
                .width(80)
                .height(80)
                .objectFit(ImageFit.Contain)
                .borderRadius(8)

              Column() {
                Row() {
                  Column() {
                    Text('王医生')
                      .fontSize($r('app.float.font_size_xlarge'))
                      .fontWeight(FontWeight.Bold)
                      .fontColor($r('app.color.text_primary'))

                    Text('主治医师 · 呼吸科')
                      .fontSize($r('app.float.font_size_small'))
                      .fontColor($r('app.color.text_gray'))
                      .margin({ top: 4 })
                  }

                  Column() {
                    Text('¥35')
                      .fontSize($r('app.float.font_size_normal'))
                      .fontColor($r('app.color.primary'))
                      .fontWeight(FontWeight.Bold)
                      .alignSelf(ItemAlign.End)

                    Text('评分 4.6')
                      .fontSize($r('app.float.font_size_small'))
                      .fontColor($r('app.color.text_gray'))
                      .alignSelf(ItemAlign.End)
                      .margin({ top: 6 })
                  }
                  .justifyContent(FlexAlign.Center)
                  .layoutWeight(1)
                }

                Text('从事呼吸系统疾病临床工作10年，擅长慢性支气管炎、哮喘等。')
                  .fontSize($r('app.float.font_size_small'))
                  .fontColor($r('app.color.text_gray'))
                  .maxLines(2)
                  .margin({ top: 8 })
              }
              .justifyContent(FlexAlign.Center)
            }
            .padding($r('app.float.margin_normal'))
            .backgroundColor($r('app.color.bg_card'))
            .borderRadius($r('app.float.radius_card'))
            .margin($r('app.float.margin_small'))
          }
        }
      }
      .layoutWeight(1)
      .padding({ bottom: 16 })

      // Action buttons for consultation types
      Row({ space: 12 }) {
        Button() {
          Text('图文问诊')
            .fontSize($r('app.float.font_size_normal'))
            .fontColor($r('app.color.text_white'))
        }
        .width('45%')
        .backgroundColor($r('app.color.primary'))
        .borderRadius($r('app.float.radius_button'))
        .padding($r('app.float.padding_button') || { left: 16, right: 16, top: 10, bottom: 10 })
        .onClick(() => { console.log('图文问诊 clicked'); })

        Button() {
          Text('视频问诊')
            .fontSize($r('app.float.font_size_normal'))
            .fontColor($r('app.color.text_white'))
        }
        .width('45%')
        .backgroundColor($r('app.color.secondary') || $r('app.color.bg_accent'))
        .borderRadius($r('app.float.radius_button'))
        .padding($r('app.float.padding_button') || { left: 16, right: 16, top: 10, bottom: 10 })
        .onClick(() => { console.log('视频问诊 clicked'); })
      }
      .margin({ left: 16, right: 16, top: 8 })
      .justifyContent(FlexAlign.Center)

      // Spacer to push content up
      Blank().layoutWeight(1)

    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.bg_page'))
  }
}
