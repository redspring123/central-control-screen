import router from '@ohos.router';

@Entry({ routeName: 'CallPage' })
@Component
export struct CallPage {
  @State callDuration: number = 0;
  private timer: number = -1;

  aboutToAppear() {
    // 模拟通话计时
    this.timer = setInterval(() => {
      this.callDuration++;
    }, 1000);
  }

  aboutToDisappear() {
    if (this.timer !== -1) {
      clearInterval(this.timer);
    }
  }

  // 格式化时间 00:00
  formatTime(seconds: number): string {
    let min = Math.floor(seconds / 60);
    let sec = seconds % 60;
    return `${min.toString().padStart(2, '0')}:${sec.toString().padStart(2, '0')}`;
  }

  build() {
    Stack() {
      // 1. 背景层：模拟对方视频画面 (这里用颜色代替，实际可放 Image)
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('#2C3E50') // 深色背景模拟视频通话

      // 2. 内容层
      Column() {
        // 顶部：医生信息
        Column({ space: 10 }) {
          Image($r('app.media.icon_nurse')) // 假设有个医生/护士头像，如果没有请替换为 app.media.app_icon
            .width(100)
            .height(100)
            .borderRadius(50)
            .backgroundColor(Color.White)
            .margin({ top: 80 })
          
          Text("李医生")
            .fontSize(24)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
          
          Text("正在通话中...")
            .fontSize(16)
            .fontColor('#CCCCCC')
        }

        Blank() // 占位，把下面内容挤到底部

        // 中间：计时器
        Text(this.formatTime(this.callDuration))
          .fontSize(40)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Medium)
          .margin({ bottom: 50 })

        // 底部：挂断按钮
        Row() {
          Column() {
            Button() {
              Image($r('app.media.icon_call_large')) // 这里应该放挂断图标，暂时用头像代替或画个红圆
                .width(30)
                .height(30)
            }
            .width(70)
            .height(70)
            .backgroundColor('#FF3B30') // 红色挂断
            .borderRadius(35)
            .onClick(() => {
              router.back(); // 挂断返回
            })
            
            Text("挂断")
              .fontColor(Color.White)
              .fontSize(14)
              .margin({ top: 10 })
          }
        }
        .margin({ bottom: 80 })
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }
}
