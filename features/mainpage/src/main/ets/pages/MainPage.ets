import { btn } from '../model/btn' // 保持你的引用
import { RouterHelper } from '../model/RouterHelper' //
import router from '@ohos.router';
import { PromptAction } from '@kit.ArkUI';
// 引入命名路由页面，确保路由注册生效
import 'medical/src/main/ets/pages/CallPage';
import 'health/src/main/ets/page/WellnessPage';

@Entry
@Component
export struct MainPage{
  @State showHome: boolean = true;
  @State showScene: boolean = false;

  // 保持你的数据结构不变
  private sceneList: btn[] = [
    { key: 'btn_warm_home', icon: 'login' },//将原来的temp_home改为进门login图标
    { key: 'btn_safe_leave', icon: 'logout' },//将原来的temp_home改为出门logout图标
    { key: 'btn_full_temp', icon: 'full_temp' },
    { key: 'btn_dehumidify', icon: 'dehumidify' },
    { key: 'btn_ventilation', icon: 'ventilation' },
    { key: 'btn_more_scenes', icon: 'foreground' },
    { key: 'btn_one_key_call', icon: 'ventilation' }, // 需跳转
    { key: 'btn_sport_health', icon: 'foreground' }   // 需跳转
  ];

  // 处理点击事件
  private handleItemClick(key: string) {
    if (key === 'btn_one_key_call') {
      // 1. 弹窗确认
      let uiContext = this.getUIContext();
      let promptAction: PromptAction = uiContext.getPromptAction();
      
      try {
        promptAction.showDialog({
          title: '一键呼叫',
          message: '是否立即呼叫家庭医生？',
          buttons: [
            { text: '取消', color: '#8E8E93' },
            { text: '立即呼叫', color: '#FF3B30' }
          ]
        }, (err, data) => {
          if (err) {
            console.error('showDialog err: ' + err);
            return;
          }
          // 点击了第二个按钮 (索引为1)
          if (data.index === 1) {
            // 跳转到通话界面 (使用命名路由)
            router.pushNamedRoute({ name: 'CallPage' });
          }
        });
      } catch (error) {
        console.error('showDialog error: ' + error);
      }
    } else if (key === 'btn_sport_health') {
      // 2. 跳转到运动健康/居家康养 (使用命名路由)
      router.pushNamedRoute({ name: 'HealthWellnessPage' });
    } else {
      // 其他按钮逻辑
      RouterHelper.jump(key);
    }
  }

  build() {
    Column() {
      // 1. 顶部导航栏 (保持原样，微调间距)
      Row() {
        Text("08:08") // 假设这是时间占位
          .fontSize($r('app.float.font_size_large'))
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_white'))

        Row({ space: 15 }) {
          Image($r('app.media.home_icon'))
            .width(24).height(24)
            .opacity(this.showHome ? 1 : 0.5)
            .fillColor(Color.White)//黑色图标反转颜色
          Image($r('app.media.sofa_icon'))
            .width(24).height(24)
            .opacity(this.showScene ? 1 : 0.5)
            .fillColor(Color.White)//黑色图标反转颜色
        }.margin({ left: 20 })
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 15, bottom: 15 })

      // 2. 内容区域
      Row({ space: 15 }) {

        // --- A. 左侧：8个场景按钮 (优化版) ---
        Grid() {
          ForEach(this.sceneList, (item: btn) => {
            GridItem() {
              Button() {
                Row() {
                  // 1. 图标容器 (Icon Box) - 解决图标看不清的问题
                  Column() {
                    Image($r(`app.media.${item.icon}`))
                      .width($r('app.float.icon_inside_size'))
                      .height($r('app.float.icon_inside_size'))
                      .objectFit(ImageFit.Contain)
                    // 如果你的PNG是黑色的，可以尝试反转颜色，或者保持原样，因为背景现在是半透明白，黑色也能看清
                    //.fillColor(Color.White) // 如果是SVG解开此行
                  }
                  .width($r('app.float.icon_box_size'))
                  .height($r('app.float.icon_box_size'))
                  .backgroundColor($r('app.color.bg_icon_container')) // 半透明背景
                  .borderRadius(10)
                  .justifyContent(FlexAlign.Center)
                  .alignItems(HorizontalAlign.Center)
                  .margin({ right: 12 })

                  // 2. 文字
                  Text($r(`app.string.${item.key}`))
                    .fontSize($r('app.float.font_size_normal'))
                    .fontColor($r('app.color.text_white'))
                    .fontWeight(FontWeight.Medium)
                    .layoutWeight(1)
                }
                .width('100%')
                .padding(10)
                .justifyContent(FlexAlign.Start)
              }
              .type(ButtonType.Normal)
              .backgroundColor($r('app.color.bg_card'))
              .borderRadius($r('app.float.radius_card'))
              .width('100%')
              .height(80)
              // 绑定点击事件，处理跳转
              .onClick(() => {
                this.handleItemClick(item.key);
              })
            }
          }, (item: btn) => item.key)
        }
        .columnsTemplate('1fr 1fr')
        .rowsGap(12)
        .columnsGap(12)
        .layoutWeight(1.2)
        .height('100%')

        // --- B. 中间 + 右侧：卡片区域 ---
        Row({ space: 15 }) {

          // === B1. 中间列 ===
          Column({ space: 15 }) {
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

            // 3. 在线问诊 (需跳转 -> card_consult)
            this.InfoCardBuilder(
              $r('app.string.card_consult_title'), // 标题
              $r('app.string.card_consult_time'),  // 副标题或状态
              '服务中',
              $r('app.media.video_call'), // 背景大图标
              '60fp',
              true, // 可点击
              'card_consult' // Key
            )
          }
          .layoutWeight(1.5)
          .height('100%')

          // === B2. 右侧列 ===
          Column({ space: 15 }) {

            // 4. 居家康养 (需跳转 -> card_health)
            this.InfoCardBuilder(
              $r('app.string.card_health_title'),
              $r('app.string.card_health_sleep'),
              '睡眠优',
              $r('app.media.sleep_quality'), // 背景图
              '100fp',
              true,
              'card_health'
            )


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
            Column({space:10}) {
              Text($r('app.string.card_intercom_title'))
                .fontSize($r('app.float.font_size_normal'))
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_white'))
                .padding(20)

              Row({ space: 30 }) {
                Button() {
                  Row({space:10})
                  {
                    Image($r('app.media.door_intercom'))
                      .width($r('app.float.icon_normal'))
                      .height($r('app.float.icon_normal'))
                    Text("门禁对讲")
                      .fontColor($r('app.color.text_white'))
                      .fontSize($r('app.float.font_size_small'))

                  }
                }
                .backgroundColor($r('app.color.bg_card'))
                .borderRadius($r('app.float.radius_card'))
                .margin($r('app.float.margin_tiny'))

                Button() {
                  Row({space:10})
                  {
                    Image($r('app.media.camera_monitor'))
                      .width($r('app.float.icon_normal'))
                      .height($r('app.float.icon_normal'))
                    Text("视频监视")
                      .fontColor($r('app.color.text_white'))
                      .fontSize($r('app.float.font_size_small'))

                  }

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
          .layoutWeight(1.5)
          .height('100%')

        }
        .layoutWeight(3)
        .height('100%')
      }
      .width('100%')
      .layoutWeight(1)
      .padding($r('app.float.card_padding'))
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.bg_page'))
    // 你的背景图
    .backgroundImage($r('app.media.bg'))
    .backgroundImageSize(ImageSize.Cover)
  }

  // --- 辅助构建函数：通用卡片 ---
  // 这种写法可以极大减少重复代码，并且统一风格
  @Builder InfoCardBuilder(title: Resource, subText: Resource | string, valueText: string, bgIcon: Resource | null, bgIconSize:string |null, isClickable: boolean, jumpKey?: string) {
    // 1. 外层容器改为 Row，实现左右布局
    Row() {

      // --- 左半部分：文字区域 ---
      Column() {
        Text(title)
          .fontSize($r('app.float.font_size_normal'))
          .fontColor($r('app.color.text_white'))
          .fontWeight(FontWeight.Bold)

        // 数值和标题稍微拉开一点距离
        Text(valueText)
          .fontSize($r('app.float.font_size_large'))
          .fontColor($r('app.color.text_white'))
          .fontWeight(FontWeight.Bold)
          .margin({ top: 8, bottom: 4 }) // 增加上下间距

        if (subText) {
          Text(subText)
            .fontSize($r('app.float.font_size_small'))
            .fontColor($r('app.color.text_gray'))
        }
      }
      .layoutWeight(1) // 关键：占据左侧剩余空间
      .height('100%')
      .alignItems(HorizontalAlign.Start) // 文字左对齐
      .justifyContent(FlexAlign.Center)  // 文字整体在垂直方向居中
      .padding({ left: 10, right: 5 })   // 关键：给左边加 padding，别贴着边缘

      // --- 右半部分：图片区域 ---
      if (bgIcon) {
        Column() {
          Image(bgIcon)
            .width(bgIconSize) // 设置合适的尺寸
            .height(bgIconSize)
            .objectFit(ImageFit.Contain)
          // .fillColor(Color.White) // 如果是SVG且需要变白，请解开此注释
        }
        .layoutWeight(1) // 关键：占据右侧空间，与左侧平分或按比例分配
        .height('100%')
        .justifyContent(FlexAlign.Center) // 垂直居中
        .alignItems(HorizontalAlign.Center) // 水平居中
      } else {
        // 如果没有图片，用空白占位或者让左侧撑满
        Blank().layoutWeight(1)
      }
    }
    // 卡片通用样式
    .width('100%')
    .layoutWeight(1) // 垂直方向均分
    .backgroundColor($r('app.color.bg_card'))
    .borderRadius($r('app.float.radius_card'))
    .margin($r('app.float.margin_small'))
    .padding($r('app.float.margin_normal')) // 卡片整体内边距
    .onClick(() => {
      if (isClickable && jumpKey) {
        RouterHelper.jump(jumpKey);
      }
    })
  }
}