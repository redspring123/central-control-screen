import { btn } from '../model/btn' // 保持你的引用
import { RouterHelper } from '../model/RouterHelper' //
import router from '@ohos.router';
import { PromptAction } from '@kit.ArkUI';
import call from '@ohos.telephony.call';
import { HomeDataService, EnergyData, NetworkData } from '../model/HomeDataService';
// 引入命名路由页面，确保路由注册生效
import 'medical/src/main/ets/pages/CallPage';
import 'health/src/main/ets/page/WellnessPage';

import { common, ConfigurationConstant } from '@kit.AbilityKit';

@Entry
@Component
export struct MainPage{
  @State showHome: boolean = true;
  @State showScene: boolean = false;
  @State energyData: EnergyData = { power: 0, todayUsage: 0, carbon: 0 };
  @State networkData: NetworkData = { uploadSpeed: '0 Mbps', downloadSpeed: '0 Mbps', quality: '良' };
  private timerId: number = -1;

  private context = getContext(this) as common.UIAbilityContext;
  @State isDarkMode: boolean = false;

  aboutToAppear() {
    // 初始加载
    this.refreshData();
    
    // 同步系统当前的深浅模式状态
    let colorMode = this.context.config.colorMode;
    this.isDarkMode = (colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK);

    // 定时刷新，模拟实时数据变化
    this.timerId = setInterval(() => {
      this.refreshData();
    }, 3000);
  }

  aboutToDisappear() {
    if (this.timerId !== -1) {
      clearInterval(this.timerId);
    }
  }

  refreshData() {
    this.energyData = HomeDataService.getEnergyData();
    this.networkData = HomeDataService.getNetworkData();
  }
  //切换主题
  toggleTheme() {
    this.isDarkMode = !this.isDarkMode;
    let applicationContext = this.context.getApplicationContext();

    if (this.isDarkMode) {
      // 切换到深色模式 (这也将通知其他模块切换到 dark 资源)
      applicationContext.setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
    } else {
      // 切换到浅色模式
      applicationContext.setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT);
    }
  }

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
    RouterHelper.jump(key);
  }

  build() {
    Column() {
      // 1. 顶部导航栏 (保持原样，微调间距)
      Row() {
        // 左侧时间已移除，使用系统状态栏时间
        Blank()

        Row({ space: 15 }) {
          Image($r('app.media.home_icon'))
            .width(24).height(24)
            .opacity(this.showHome ? 1 : 0.5)
            .fillColor(Color.White)//黑色图标反转颜色
          Image($r('app.media.sofa_icon'))
            .width(24).height(24)
            .opacity(this.showScene ? 1 : 0.5)
            .fillColor(Color.White)//黑色图标反转颜色
          Button() {

            Image(this.isDarkMode ? $r('app.media.ic_sun') : $r('app.media.ic_moon'))
              .width(24)
              .height(24)
              .colorFilter([
                0, 0, 0, 0, 255,
                0, 0, 0, 0, 255,
                0, 0, 0, 0, 255,
                0, 0, 0, 1, 0
              ]) // 强制变白
          }
          .type(ButtonType.Normal) // 去掉默认圆角背景
          .backgroundColor(Color.Transparent) // 透明背景
          .onClick(() => {
            this.toggleTheme(); // 绑定点击事件
          })
        }.margin({ left: 20 })
      }
      .backgroundColor($r('app.color.top'))
      .width('100%')
      .padding({ left: 20, right: 20, top: 15, bottom: 15 })

      // 2. 内容区域
      Row({ space: 15 }) {


        // --- A. 左侧区域：Grid + 天气组件 ---
        Column({ space: 5 }) {

          // === 上半部分：8个场景按钮 ===
          Grid() {
            ForEach(this.sceneList, (item: btn) => {
              GridItem() {
                Button() {
                  Row() {
                    // 图标容器
                    Column() {
                      Image($r(`app.media.${item.icon}`))
                        .width($r('app.float.icon_inside_size'))
                        .height($r('app.float.icon_inside_size'))
                        .objectFit(ImageFit.Contain)
                    }
                    .width($r('app.float.icon_box_size'))
                    .height($r('app.float.icon_box_size'))
                    .backgroundColor($r('app.color.bg_icon_container'))
                    .borderRadius(10)
                    .justifyContent(FlexAlign.Center)
                    .alignItems(HorizontalAlign.Center)
                    .margin({ right: 12 })

                    // 文字
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
                // 样式保持统一
                .backgroundColor(this.isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(255, 255, 255, 0.25)')
                .backdropBlur(20)
                .border({ width: 0.5, color: 'rgba(255, 255, 255, 0.2)' })
                .borderRadius($r('app.float.radius_card'))
                .width('100%')
                .height(80) // 按钮高度保持
                .onClick(() => {
                  this.handleItemClick(item.key);
                })
              }
            }, (item: btn) => item.key)
          }
          .columnsTemplate('1fr 1fr')
          .rowsGap(15) // 稍微调小一点行间距，给下方腾出空间
          .columnsGap(12)
          .width('100%')
          .height('60')
          .margin({
            top: $r('app.float.margin_small')
          })
          .layoutWeight(3.5) // 2. 关键：Grid 占据垂直方向 3/4 的空间

          // === 下半部分：天气组件 (新增) ===
          Row() {
            // 左边：图标和温度
            Column() {
              Row() {
                // 请确保 media 下有 weather_icon，如果没有找个现有的代替
                Image($r('app.media.ic_sun'))
                  .width(40)
                  .height(40)
                  .objectFit(ImageFit.Contain)
                  .fillColor(Color.Orange) // 太阳设为橙色
                  .margin({ right: 10 })

                Column() {
                  Text("26°C")
                    .fontSize(28)
                    .fontWeight(FontWeight.Bold)
                    .fontColor($r('app.color.text_white'))

                  Text("多云转晴")
                    .fontSize($r('app.float.font_size_small'))
                    .fontColor($r('app.color.text_white'))
                    .opacity(0.8)
                }
                .alignItems(HorizontalAlign.Start)
              }
            }
            .layoutWeight(1)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Start)
            .padding({ left: 20 })

            // 右边：天气提醒
            Column() {
              Text("温馨提示")
                .fontSize($r('app.float.font_size_small'))
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_white'))
                .margin({ bottom: 5 })

              Text("今日紫外线较强，出门请注意防晒。")
                .fontSize(12) // 字体稍微小一点以便放下更多字
                .fontColor($r('app.color.text_white'))
                .opacity(0.8)
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .layoutWeight(1) // 右边文字区域稍微宽一点
            .alignItems(HorizontalAlign.Start)
            .justifyContent(FlexAlign.Center)
            .padding({ right: 15 })

          }
          .width('100%')
          .margin({
            bottom: ('12fp')
          })
          .layoutWeight(1) // 3. 关键：天气卡片占据垂直方向 1/4 的空间
          // 4. 样式复用：保持和其他卡片一致的玻璃质感
          .backgroundColor(this.isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(255, 255, 255, 0.25)')
          .backdropBlur(20)
          .border({ width: 0.5, color: 'rgba(255, 255, 255, 0.2)' })
          .borderRadius($r('app.float.radius_card'))

        }
        .layoutWeight(1.2) // 整个左侧区域的宽度权重保持不变
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
              Text(`${this.energyData.todayUsage} kWh`)
                .fontSize($r('app.float.font_size_xlarge'))
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_white'))
              Text($r('app.string.card_energy_today'))
                .fontSize($r('app.float.font_size_small'))
                .fontColor($r('app.color.text_gray'))
              Text(`本月碳排放量: ${this.energyData.carbon} kg`)
                .fontSize($r('app.float.font_size_small'))
                .fontColor($r('app.color.text_gray'))
                .margin({ top: $r('app.float.margin_tiny') })
            }
            // .backgroundColor($r('app.color.bg_card')) // 原来的背景色
            // 修改为：动态半透明背景 + 毛玻璃效果
            .backgroundColor(this.isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(255, 255, 255, 0.25)')
            .backdropBlur(20)
            .border({ width: 0.5, color: 'rgba(255, 255, 255, 0.2)' })
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
            // 修改为：动态半透明背景 + 毛玻璃效果
            .backgroundColor(this.isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(255, 255, 255, 0.25)')
            .backdropBlur(20)
            .border({ width: 0.5, color: 'rgba(255, 255, 255, 0.2)' })
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
              'card_consult', // Key
              Color.Green // 传入绿色
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
                    Text(this.networkData.quality)
                      .fontSize($r('app.float.font_size_large'))
                      .fontWeight(FontWeight.Bold)
                      .fontColor($r('app.color.text_white'))
                    Text(`↑ ${this.networkData.uploadSpeed}`)
                      .fontSize($r('app.float.font_size_small'))
                      .fontColor($r('app.color.text_gray'))
                    Text(`↓ ${this.networkData.downloadSpeed}`)
                      .fontSize($r('app.float.font_size_small'))
                      .fontColor($r('app.color.text_gray'))
                      .margin({ top: $r('app.float.margin_tiny') })
                  }
                  .width('50%')
                  .justifyContent(FlexAlign.SpaceBetween)


                  Image($r('app.media.network_speed'))
                    .width($r('app.float.icon_large'))
                    .height($r('app.float.icon_large'))
                    .fillColor('#ff379ee0') // 浅蓝色
                }
                .width('90%')
                .justifyContent(FlexAlign.SpaceBetween)



              }
              .width('100%')
              .height('100%')
              .backgroundColor(Color.Transparent) // 按钮背景透明，由外层 Column 控制
            }
            // 修改为：动态半透明背景 + 毛玻璃效果
            .backgroundColor(this.isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(255, 255, 255, 0.25)')
            .backdropBlur(20)
            .border({ width: 0.5, color: 'rgba(255, 255, 255, 0.2)' })
            .borderRadius($r('app.float.radius_card'))
            .margin($r('app.float.margin_small'))
            .padding($r('app.float.margin_normal'))
            .width('100%')
            .layoutWeight(1)

            // 可视对讲
            Column({space:3}) {
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
                .backgroundColor(this.isDarkMode ? 'rgba(255, 255, 255, 0.2)' : 'rgba(255, 255, 255, 0.2)') // 内部按钮也稍微透明一点
                .borderRadius($r('app.float.radius_card'))
                .margin($r('app.float.margin_tiny'))
                .padding(5)
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
                .backgroundColor(this.isDarkMode ? 'rgba(255, 255, 255, 0.2)' : 'rgba(255, 255, 255, 0.2)') // 内部按钮也稍微透明一点
                .borderRadius($r('app.float.radius_card'))
                .margin($r('app.float.margin_tiny'))
                .padding(5)
              }
              .justifyContent(FlexAlign.Center)
            }
            // 修改为：动态半透明背景 + 毛玻璃效果
            .backgroundColor(this.isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(255, 255, 255, 0.25)')
            .backdropBlur(20)
            .border({ width: 0.5, color: 'rgba(255, 255, 255, 0.2)' })
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
  @Builder InfoCardBuilder(title: Resource, subText: Resource | string, valueText: string, bgIcon: Resource | null, bgIconSize:string |null, isClickable: boolean, jumpKey?: string, iconColor?: ResourceColor) {
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
            .fillColor(iconColor) // 如果传入了颜色，则应用
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
    // 修改为：动态半透明背景 + 毛玻璃效果
    .backgroundColor(this.isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(255, 255, 255, 0.25)')
    .backdropBlur(20)
    .border({ width: 0.5, color: 'rgba(255, 255, 255, 0.2)' })
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