import { RouterHelper } from '../model/RouterHelper'
import { btn } from '../model/btn'
import { HomeDataService, EnergyData, NetworkData, WeatherData } from '../model/HomeDataService';
import { common, ConfigurationConstant } from '@kit.AbilityKit';

// 1. 定义卡片库的元数据（用于在添加列表中显示）
interface CardMeta {
  key: string;
  name: string;
}

// 2. 卡片库（这里定义了所有可能被添加的卡片）
const CARD_LIBRARY: CardMeta[] = [
  { key: 'energy', name: '家庭能耗' },
  { key: 'security', name: '家庭安防' },
  { key: 'network', name: '家庭网络' },
  { key: 'health', name: '居家康养' },
  { key: 'consult', name: '在线问诊' },
  { key: 'intercom', name: '可视对讲' },
  { key: 'music', name: '背景音乐' }, // 新增示例
  { key: 'robot', name: '扫地机器人' }, // 新增示例
  { key: 'curtain', name: '智能窗帘' }, // 新增示例
  { key: 'light', name: '全屋灯光' }   // 新增示例
];

@Entry
@Component
export struct MainPage {
  // === 状态变量 ===
  @State showHome: boolean = true;
  @State showScene: boolean = false;
  @State energyData: EnergyData = { power: 0, todayUsage: 0, carbon: 0 };
  @State networkData: NetworkData = { uploadSpeed: '0 Mbps', downloadSpeed: '0 Mbps', quality: '良' };
  @State weatherTempText: string = '26°C';
  @State weatherConditionText: string = '多云转晴';
  @State weatherTipText: string = '今日紫外线较强，出门请注意防晒。';
  @State weatherIcon: string = 'sun';
  @State isDarkMode: boolean = false;
  private timerId: number = -1;
  private context = getContext(this) as common.UIAbilityContext;

  // === 核心逻辑：当前展示的卡片 Key 列表 ===
  // 数组的顺序决定了 Grid 中的显示顺序。默认放4个。
  @State displayedCards: string[] = ['energy', 'security', 'health', 'network'];

  // === 弹窗控制器：用于添加卡片 ===
  dialogController: CustomDialogController = new CustomDialogController({
    builder: AddCardDialog({
      // 传入当前已存在的卡片，用于过滤（不显示已经添加的）
      currentKeys: this.displayedCards,
      // 传入添加回调
      onAdd: (key: string) => {
        // 核心逻辑：往数组里 push 一个 key，界面自动刷新
        if (this.displayedCards.length < 6) {
          this.displayedCards.push(key);
        }
      }
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: true // 使用自定义样式，去掉默认白色背景
  });

  // 左侧固定按钮列表
  private sceneList: btn[] = [
    { key: 'btn_warm_home', icon: 'login' },
    { key: 'btn_safe_leave', icon: 'logout' },
    { key: 'btn_full_temp', icon: 'full_temp' },
    { key: 'btn_dehumidify', icon: 'dehumidify' },
    { key: 'btn_ventilation', icon: 'ventilation' },
    { key: 'btn_more_scenes', icon: 'foreground' },
    { key: 'btn_one_key_call', icon: 'ventilation' },
    { key: 'btn_sport_health', icon: 'foreground' }
  ];

  aboutToAppear() {
    this.refreshData();
    let colorMode = this.context.config.colorMode;
    this.isDarkMode = (colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
    this.timerId = setInterval(() => { this.refreshData(); }, 3000);
  }

  aboutToDisappear() {
    if (this.timerId !== -1) clearInterval(this.timerId);
  }

  refreshData() {
    this.energyData = HomeDataService.getEnergyData();
    this.networkData = HomeDataService.getNetworkData();
    const w: WeatherData = HomeDataService.getWeatherData();
    const t = Math.round(w.tempC);
    this.weatherTempText = `${isNaN(t) ? 0 : t}°C`;
    this.weatherConditionText = w.condition;
    this.weatherTipText = w.tip;
    this.weatherIcon = w.icon || 'sun';
  }

  toggleTheme() {
    this.isDarkMode = !this.isDarkMode;
    let applicationContext = this.context.getApplicationContext();
    applicationContext.setColorMode(this.isDarkMode ? ConfigurationConstant.ColorMode.COLOR_MODE_DARK : ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT);
  }

  // =====================================================================================
  // 核心 Builder 分发器：根据 Key 决定渲染哪个卡片
  // 这就是你的“卡片库”的实体化过程
  // =====================================================================================
  @Builder RenderCardByKey(key: string) {
    if (key === 'energy') {
      this.EnergyCard()
    } else if (key === 'security') {
      this.SecurityCard()
    } else if (key === 'network') {
      this.NetworkCard()
    } else if (key === 'intercom') {
      this.IntercomCard()
    } else if (key === 'consult') {
      this.InfoCardBuilder($r('app.string.card_consult_title'), $r('app.string.card_consult_time'), '服务中', $r('app.media.video_call'), '60fp', true, 'card_consult', Color.Green)
    } else if (key === 'health') {
      this.InfoCardBuilder($r('app.string.card_health_title'), $r('app.string.card_health_sleep'), '睡眠优', $r('app.media.sleep_quality'), '100fp', true, 'card_health')
    } else {
      // 默认/其他未实现的卡片占位
      this.PlaceholderCard(key)
    }
  }

  // =====================================================================================
  // 具体卡片实现 (你的积木)
  // =====================================================================================

  // 1. 能耗卡片
  @Builder EnergyCard() {
    Column() {
      Text($r('app.string.card_energy_title')).fontSize($r('app.float.font_size_normal')).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_white'))
      Text(`${this.energyData.todayUsage} kWh`).fontSize($r('app.float.font_size_xlarge')).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_white'))
      Text($r('app.string.card_energy_today')).fontSize($r('app.float.font_size_small')).fontColor($r('app.color.text_gray'))
      Text(`本月碳排: ${this.energyData.carbon} kg`).fontSize($r('app.float.font_size_small')).fontColor($r('app.color.text_gray')).margin({ top: 5 })
    }
    .width('100%').height('100%')
    .alignItems(HorizontalAlign.Start).justifyContent(FlexAlign.Center)
  }

  // 2. 安防卡片
  @Builder SecurityCard() {
    Column() {
      Text($r('app.string.card_security_title')).fontSize($r('app.float.font_size_normal')).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_white'))
      Text($r('app.string.card_security_status')).fontSize($r('app.float.font_size_xlarge')).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_red'))
      Row({ space: 10 }) {
        Image($r('app.media.alarm_active')).width(24).height(24).fillColor('#4CAF50')
        Image($r('app.media.alarm_exit')).width(24).height(24).fillColor('#F44336')
      }.margin({ top: 10 })
    }
    .width('100%').height('100%')
    .alignItems(HorizontalAlign.Start).justifyContent(FlexAlign.Center)
  }

  // 3. 网络卡片
  @Builder NetworkCard() {
    Row() {
      Column() {
        Text($r('app.string.card_network_title')).fontSize($r('app.float.font_size_normal')).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_white'))
        Text(this.networkData.quality).fontSize($r('app.float.font_size_large')).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_white'))
        Text(`↑ ${this.networkData.uploadSpeed}`).fontSize(10).fontColor($r('app.color.text_gray'))
        Text(`↓ ${this.networkData.downloadSpeed}`).fontSize(10).fontColor($r('app.color.text_gray'))
      }.alignItems(HorizontalAlign.Start)
      Blank()
      Image($r('app.media.network_speed')).width(40).height(40).fillColor('#ff379ee0')
    }
    .width('100%').height('100%')
    .alignItems(VerticalAlign.Center)
  }

  // 4. 可视对讲
  @Builder IntercomCard() {
    Column({space: 5}) {
      Text($r('app.string.card_intercom_title')).fontSize($r('app.float.font_size_normal')).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_white'))
      Row({space: 10}) {
        Column() { Image($r('app.media.door_intercom')).width(24).height(24); Text("对讲").fontSize(10).fontColor(Color.White) }
        Column() { Image($r('app.media.camera_monitor')).width(24).height(24); Text("监控").fontSize(10).fontColor(Color.White) }
      }
    }
    .width('100%').height('100%')
    .alignItems(HorizontalAlign.Start).justifyContent(FlexAlign.Center)
  }

  // 5. 通用卡片
  @Builder InfoCardBuilder(title: Resource, subText: Resource | string, valueText: string, bgIcon: Resource | null, bgIconSize:string |null, isClickable: boolean, jumpKey?: string, iconColor?: ResourceColor) {
    Row() {
      Column() {
        Text(title).fontSize($r('app.float.font_size_normal')).fontColor($r('app.color.text_white')).fontWeight(FontWeight.Bold)
        Text(valueText).fontSize($r('app.float.font_size_large')).fontColor($r('app.color.text_white')).fontWeight(FontWeight.Bold).margin({ top: 5, bottom: 2 })
        if (subText) Text(subText).fontSize($r('app.float.font_size_small')).fontColor($r('app.color.text_gray'))
      }.layoutWeight(1).height('100%').alignItems(HorizontalAlign.Start).justifyContent(FlexAlign.Center)
      if (bgIcon) {
        Image(bgIcon).width(40).height(40).objectFit(ImageFit.Contain).fillColor(iconColor)
      }
    }.width('100%').height('100%')
    .onClick(() => { if (isClickable && jumpKey) RouterHelper.jump(jumpKey); })
  }

  // 6. 占位卡片（用于未实现的）
  @Builder PlaceholderCard(name: string) {
    Column() {
      Text(name).fontSize(16).fontWeight(FontWeight.Bold).fontColor(Color.White)
      Text("暂未开发").fontSize(12).fontColor(Color.Gray)
    }.width('100%').height('100%').justifyContent(FlexAlign.Center)
  }


  // =====================================================================================
  // UI 布局
  // =====================================================================================
  build() {
    Column() {
      // 1. 顶部栏 (简化)
      Row() {
        Blank()
        Row({ space: 15 }) {
          Image($r('app.media.home_icon')).width(24).height(24).fillColor(Color.White).opacity(this.showHome ? 1 : 0.5)
          Image($r('app.media.sofa_icon')).width(24).height(24).fillColor(Color.White).opacity(this.showScene ? 1 : 0.5)
          Button() { Image(this.isDarkMode ? $r('app.media.ic_sun') : $r('app.media.ic_moon')).width(24).height(24).fillColor(Color.White) }
          .type(ButtonType.Normal).backgroundColor(Color.Transparent)
          .onClick(() => this.toggleTheme())
        }.margin({ left: 20 })
      }.backgroundColor($r('app.color.top')).width('100%').padding(15)

      // 2. 主体内容
      Row({ space: 15 }) {

        // --- A. 左侧：8个按钮 + 天气 (保持原样) ---
        Column({ space: 5 }) {
          // Grid 场景按钮
          Grid() {
            ForEach(this.sceneList, (item: btn) => {
              GridItem() {
                Button() {
                  Row() {
                    Column() { Image($r(`app.media.${item.icon}`)).width(20).height(20) }
                    .width(36).height(36).backgroundColor($r('app.color.bg_icon_container')).borderRadius(10).justifyContent(FlexAlign.Center).margin({ right: 10 })
                    Text($r(`app.string.${item.key}`)).fontSize(14).fontColor(Color.White).layoutWeight(1)
                  }.width('100%').padding(8)
                }
                .type(ButtonType.Normal)
                .backgroundColor(this.isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(255, 255, 255, 0.25)')
                .backdropBlur(20).border({ width: 0.5, color: 'rgba(255, 255, 255, 0.2)' }).borderRadius(12)
                .width('100%').height(60)
                .onClick(() => RouterHelper.jump(item.key))
              }
            }, (item: btn) => item.key)
          }.columnsTemplate('1fr 1fr').rowsGap(10).columnsGap(10).layoutWeight(3.5)

          // 天气卡片 (复用样式)
          Row() {
            Image($r(`app.media.ic_${this.weatherIcon}`)).width(40).height(40).margin({ right: 10, left: 10 })
            Column() {
              Text(this.weatherTempText).fontSize(24).fontWeight(FontWeight.Bold).fontColor(Color.White)
              Text(this.weatherConditionText).fontSize(12).fontColor(Color.White).opacity(0.8)
            }.alignItems(HorizontalAlign.Start)
            Blank()
            Text(this.weatherTipText).fontSize(12).fontColor(Color.White).opacity(0.8).maxLines(2).textOverflow({overflow:TextOverflow.Ellipsis}).width('40%').margin({right:10})
          }
          .width('100%').layoutWeight(1)
          .backgroundColor(this.isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(255, 255, 255, 0.25)')
          .backdropBlur(20).border({ width: 0.5, color: 'rgba(255, 255, 255, 0.2)' }).borderRadius(12)
        }
        .layoutWeight(1.2).height('100%')

        // --- B. 右侧：可增删的卡片 Grid (核心修改) ---
        // 将原来的两列 Column 改为一个统一的 Grid
        Grid() {
          // 1. 渲染已添加的卡片
          ForEach(this.displayedCards, (key: string, index: number) => {
            GridItem() {
              Stack({ alignContent: Alignment.TopEnd }) {
                // (1) 卡片内容主体
                Column() {
                  this.RenderCardByKey(key)
                }
                .width('100%').height('100%')
                .padding(15)

                // (2) 删除按钮 (视觉删除)
                Button() {
                  Image($r('app.media.ic_public_cancel')) // 请准备一个叉号图标
                    .width(16).height(16)
                    .fillColor('rgba(255,255,255,0.6)')
                }
                .type(ButtonType.Circle)
                .backgroundColor('rgba(0,0,0,0.2)')
                .width(24).height(24)
                .margin({ top: 5, right: 5 })
                .onClick(() => {
                  // 核心删除逻辑：从数组中移除该元素，UI会自动重新排列（往前挤）
                  this.displayedCards.splice(index, 1);
                })
              }
              // 卡片通用玻璃样式
              .backgroundColor(this.isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(255, 255, 255, 0.25)')
              .backdropBlur(20)
              .border({ width: 0.5, color: 'rgba(255, 255, 255, 0.2)' })
              .borderRadius(16)
              .width('100%')
              .height('100%')
            }
          }, (key: string) => key) // 必须用 key 保证渲染性能

          // 2. 渲染“添加”按钮 (如果有空位才显示)
          if (this.displayedCards.length < 6) {
            GridItem() {
              Button() {
                Column() {
                  Text("+").fontSize(40).fontColor('rgba(255,255,255,0.5)').fontWeight(FontWeight.Lighter)
                  Text("添加卡片").fontSize(12).fontColor('rgba(255,255,255,0.5)')
                }
              }
              .type(ButtonType.Normal)
              .backgroundColor('rgba(255, 255, 255, 0.05)') // 比其他卡片更淡一点
              .border({ width: 1, color: 'rgba(255, 255, 255, 0.1)', style: BorderStyle.Dashed }) // 虚线边框
              .borderRadius(16)
              .width('100%')
              .height('100%')
              .onClick(() => {
                this.dialogController.open()
              })
            }
          }

        }
        .columnsTemplate('1fr 1fr') // 固定两列
        .rowsTemplate('1fr 1fr 1fr') // 固定三行
        .rowsGap(15)
        .columnsGap(15)
        .layoutWeight(3) // 占据右侧空间
        .height('100%')

      }
      .width('100%').layoutWeight(1).padding(15)
    }
    .width('100%').height('100%')
    .backgroundColor($r('app.color.bg_page'))
    .backgroundImage($r('app.media.bg')).backgroundImageSize(ImageSize.Cover)
  }
}

// =====================================================================================
// 底部弹窗：卡片库列表 (添加卡片)
// =====================================================================================
@CustomDialog
struct AddCardDialog {
  controller: CustomDialogController
  currentKeys: string[] = [] // 接收已存在的 key
  onAdd: (key: string) => void = () => {}

  build() {
    Column() {
      Text("添加卡片到桌面")
        .fontSize(18).fontWeight(FontWeight.Bold).fontColor(Color.Black)
        .margin({ top: 20, bottom: 10 })
        .width('100%').textAlign(TextAlign.Start).padding({left: 20})

      Grid() {
        // 遍历所有可能的卡片
        ForEach(CARD_LIBRARY, (item: CardMeta) => {
          GridItem() {
            Button() {
              Column({space: 5}) {
                // 这里可以用更丰富的图标
                Image($r('app.media.home_icon')) // 暂时用通用图标，实际可用 item.key 映射
                  .width(24).height(24).fillColor('#007DFF')
                Text(item.name)
                  .fontSize(14).fontColor(Color.Black)
              }
            }
            .type(ButtonType.Normal)
            .width('100%').height(80)
            .backgroundColor('#F5F7FA')
            .borderRadius(12)
            .opacity(this.currentKeys.includes(item.key) ? 0.4 : 1) // 如果已添加，变灰
            .enabled(!this.currentKeys.includes(item.key)) // 如果已添加，禁用
            .onClick(() => {
              this.onAdd(item.key)
              this.controller.close()
            })
          }
        })
      }
      .columnsTemplate('1fr 1fr 1fr') // 3列
      .rowsGap(10).columnsGap(10)
      .padding(15)
      .height(200)

      Button("取消")
        .fontColor(Color.Gray)
        .backgroundColor(Color.Transparent)
        .onClick(() => this.controller.close())
        .margin({ bottom: 10 })
    }
    .width('90%')
    .backgroundColor(Color.White)
    .borderRadius(24)
  }
}