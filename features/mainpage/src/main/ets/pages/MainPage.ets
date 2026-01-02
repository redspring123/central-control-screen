import { RouterHelper } from '../model/RouterHelper'
import { btn } from '../model/btn'
import router from '@ohos.router';
import { HomeDataService, EnergyData, NetworkData, WeatherData } from '../model/HomeDataService';
import { AppDatabase } from 'utils';
import { HealthDataService } from 'health';
// 引入命名路由页面，确保路由注册生效
import 'medical/src/main/ets/pages/CallPage';
import 'health/src/main/ets/page/WellnessPage';
import 'health/src/main/ets/page/HealthAssistantPage';
import 'auth/src/main/ets/pages/ProfilePage';
import 'forum/src/main/ets/pages/ForumPage';
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
  { key: 'forum', name: '健康论坛' },
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
  @State currentBreakpoint: string = 'md';
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

  async aboutToAppear() {
    // 初始化数据库
    await AppDatabase.init(this.context);
    // 初始化健康服务
    await HealthDataService.init(this.context);
    
    this.refreshData();
    let colorMode = this.context.config.colorMode;
    this.isDarkMode = (colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
    this.timerId = setInterval(() => { this.refreshData(); }, 3000);
  }

  aboutToDisappear() {
    if (this.timerId !== -1) clearInterval(this.timerId);
  }

  async refreshData() {
    this.energyData = await HomeDataService.getEnergyData();
    this.networkData = await HomeDataService.getNetworkData();
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
      // 使用百分比 '35%' 代替固定尺寸，适配不同屏幕
      this.InfoCardBuilder($r('app.string.card_consult_title'), $r('app.string.card_consult_time'), '服务中', $r('app.media.video_call'), '35%', true, 'card_consult', Color.Green)
    } else if (key === 'health') {
      // 使用百分比 '50%' 代替固定尺寸 '100fp'
      this.InfoCardBuilder($r('app.string.card_health_title'), $r('app.string.card_health_sleep'), '睡眠优', $r('app.media.sleep_quality'), '50%', true, 'card_health')
    }
    // 🆕 新增：健康论坛卡片
    else if (key === 'forum') {
      this.InfoCardBuilder(
        $r('app.string.forum_title'),                  // 标题
        '今日热帖: 12',              // 副标题 (可以绑定动态变量)
        '去交流',                    // 状态/操作文字
        $r('app.media.ic_public_message'), // 🆕 请确保你有这个图标，或者使用 $r('app.media.ic_forum')
        '45%',                       // 图标大小
        true,                        // 可点击
        'HealthForumPage'            // 🚀 跳转路由名称 (需与 ForumPage 的 @Entry routeName 一致)
      )
    }else {
      // 默认/其他未实现的卡片占位
      this.PlaceholderCard(key)
    }
  }

  // =====================================================================================
  // 具体卡片实现 (你的积木)
  // =====================================================================================

  // 1. 能耗卡片
  @Builder EnergyCard() {
    Column({ space: 5 }) {
      Text($r('app.string.card_energy_title')).fontSize($r('app.float.font_size_large')).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_white'))
      Text(`${this.energyData.todayUsage} kWh`).fontSize($r('app.float.font_size_xlarge')).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_white'))
      Text($r('app.string.card_energy_today')).fontSize($r('app.float.font_size_small')).fontColor($r('app.color.text_gray'))
      Text(`本月碳排: ${this.energyData.carbon} kg`).fontSize($r('app.float.font_size_small')).fontColor($r('app.color.text_gray'))
    }
    .width('100%').height('100%')
    .alignItems(HorizontalAlign.Center).justifyContent(FlexAlign.Center) // 改为居中
  }

  // 2. 安防卡片
  @Builder SecurityCard() {
    Column({ space: 5 }) {
      Text($r('app.string.card_security_title')).fontSize($r('app.float.font_size_large')).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_white'))
      Text($r('app.string.card_security_status')).fontSize($r('app.float.font_size_xlarge')).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_red'))
      Row({ space: 20 }) { // 增加间距
        Image($r('app.media.alarm_active')).width(32).height(32).fillColor('#4CAF50') // 增大图标
        Image($r('app.media.alarm_exit')).width(32).height(32).fillColor('#F44336') // 增大图标
      }.margin({ top: 10 })
    }
    .width('100%').height('100%')
    .alignItems(HorizontalAlign.Center).justifyContent(FlexAlign.Center) // 改为居中
  }

  // 3. 网络卡片
  @Builder NetworkCard() {
    Row() {
      Column() {
        Text($r('app.string.card_network_title')).fontSize($r('app.float.font_size_large')).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_white'))
        Text(this.networkData.quality).fontSize($r('app.float.font_size_large')).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_white'))
        Text(`↑ ${this.networkData.uploadSpeed}`).fontSize(12).fontColor($r('app.color.text_gray'))
        Text(`↓ ${this.networkData.downloadSpeed}`).fontSize(12).fontColor($r('app.color.text_gray'))
      }.alignItems(HorizontalAlign.Start) // 网络卡片保持左对齐可能更好看，或者也改居中？这里先保持左对齐，配合右侧大图标
      Blank()
      Image($r('app.media.network_speed')).width(48).height(48).fillColor('#ff379ee0') // 增大图标
    }
    .width('100%').height('100%')
    .alignItems(VerticalAlign.Center)
    .padding({ left: 10, right: 10 }) // 增加内边距防止贴边
  }

  // 4. 可视对讲
  @Builder IntercomCard() {
    Column({space: 10}) {
      Text($r('app.string.card_intercom_title')).fontSize($r('app.float.font_size_large')).fontWeight(FontWeight.Bold).fontColor($r('app.color.text_white'))
      Row({space: 20}) {
        Column() { Image($r('app.media.door_intercom')).width(32).height(32); Text("对讲").fontSize(12).fontColor(Color.White).margin({top:5}) }
        Column() { Image($r('app.media.camera_monitor')).width(32).height(32); Text("监控").fontSize(12).fontColor(Color.White).margin({top:5}) }
      }
    }
    .width('100%').height('100%')
    .alignItems(HorizontalAlign.Center).justifyContent(FlexAlign.Center) // 改为居中
  }

  // 5. 通用卡片
  @Builder InfoCardBuilder(title: Resource, subText: Resource | string, valueText: string, bgIcon: Resource | null, bgIconSize: string | number | null, isClickable: boolean, jumpKey?: string, iconColor?: ResourceColor) {
    Row() {
      Column() {
        Text(title).fontSize($r('app.float.font_size_large')).fontColor($r('app.color.text_white')).fontWeight(FontWeight.Bold)
        Text(valueText).fontSize($r('app.float.font_size_large')).fontColor($r('app.color.text_white')).fontWeight(FontWeight.Bold).margin({ top: 5, bottom: 2 })
        if (subText) Text(subText).fontSize($r('app.float.font_size_small')).fontColor($r('app.color.text_gray'))
      }.layoutWeight(1).height('100%').alignItems(HorizontalAlign.Start).justifyContent(FlexAlign.Center)
      if (bgIcon) {
        // 优先使用传入的尺寸，否则默认 48
        Image(bgIcon)
          .width(bgIconSize ? bgIconSize : 48)
          .height(bgIconSize ? bgIconSize : 48)
          .objectFit(ImageFit.Contain)
          .fillColor(iconColor)
      }
    }.width('100%').height('100%')
    .padding({ left: 10, right: 5 }) // 增加内边距
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
        // 个人信息入口
        Image($r('app.media.user_icon'))
          .width(24).height(24)
          .margin({ right: 10 })
          .onClick(() => {
            router.pushNamedRoute({ name: 'ProfilePage' });
          })

        Blank()
        Row({ space: 15 }) {
          Image($r('app.media.home_icon')).width(24).height(24).fillColor(Color.White).opacity(this.showHome ? 1 : 0.5)
          Image($r('app.media.sofa_icon')).width(24).height(24).fillColor(Color.White).opacity(this.showScene ? 1 : 0.5)
          Button() { Image(this.isDarkMode ? $r('app.media.ic_sun') : $r('app.media.ic_moon')).width(24).height(24).fillColor(Color.White) }
          .type(ButtonType.Normal).backgroundColor(Color.Transparent)
          .onClick(() => this.toggleTheme())

          // 模拟数据按钮
          Button("模拟数据")
            .fontSize(12)
            .height(28)
            .backgroundColor('#40FFFFFF')
            .fontColor(Color.White)
            .borderRadius(14)
            .onClick(async () => {
              // 1. 模拟写入数据
              await HomeDataService.simulateData();
              await HealthDataService.simulateData();
              
              // 2. 刷新界面
              this.refreshData();
              
              // 3. 提示用户
              // promptAction.showToast({ message: '数据已更新' }); // 需要 import promptAction
            })

        }.margin({ left: 20 })
      }.backgroundColor($r('app.color.top')).width('100%').padding(15)

      // 2. 主体内容：使用 GridRow 实现响应式布局 (手机竖排，平板横排)
      Scroll() {
        GridRow({
          columns: 12,
          gutter: { x: 15, y: 15 }, // 水平和垂直间距
          breakpoints: { value: ["600vp", "840vp"], reference: BreakpointsReference.WindowSize }
        }) {

          // --- A. 左侧：场景按钮 + 天气 ---
          // sm(手机): 占满12列 (换行显示)
          // md(平板): 占4列 (左侧显示)
          GridCol({ span: { sm: 12, md: 4, lg: 3 } }) {
            Column({ space: 10 }) { // 增加间距
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
              }
              .columnsTemplate('1fr 1fr')
              .rowsGap(10).columnsGap(10)
              .height(this.showHome ? (this.currentBreakpoint === 'sm' ? 280 : 280) : 0) // 简单适配

              // 天气卡片
              Row() {
                Image($r(`app.media.ic_${this.weatherIcon}`)).width(40).height(40).margin({ right: 10, left: 10 })
                Column() {
                  Text(this.weatherTempText).fontSize(24).fontWeight(FontWeight.Bold).fontColor(Color.White)
                  Text(this.weatherConditionText).fontSize(12).fontColor(Color.White).opacity(0.8)
                }.alignItems(HorizontalAlign.Start)
                Blank()
                Text(this.weatherTipText).fontSize(12).fontColor(Color.White).opacity(0.8).maxLines(2).textOverflow({overflow:TextOverflow.Ellipsis}).width('40%').margin({right:10})
              }
              .width('100%').height(80) // 固定高度
              .backgroundColor(this.isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(255, 255, 255, 0.25)')
              .backdropBlur(20).border({ width: 0.5, color: 'rgba(255, 255, 255, 0.2)' }).borderRadius(12)

              // AI 健康助手入口
              Row() {
                SymbolGlyph($r('sys.symbol.heart_fill'))//系统内置图标
                  .fontSize(32)
                  .width(40)
                  .height(40)
                  .margin({ right: 10, left: 10 })
                  .fontColor([Color.Red])
                Column() {
                  Text("健康助手").fontSize(18).fontWeight(FontWeight.Bold).fontColor(Color.White)
                  Text("AI 智能分析").fontSize(12).fontColor(Color.White).opacity(0.8)
                }.alignItems(HorizontalAlign.Start)
                Blank()
              }
              .width('100%').height(80)
              .backgroundColor(this.isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(255, 255, 255, 0.25)')
              .backdropBlur(20).border({ width: 0.5, color: 'rgba(255, 255, 255, 0.2)' }).borderRadius(12)
              .onClick(() => {
                router.pushNamedRoute({ name: 'HealthAssistantPage' });
              })
            }
          }

          // --- B. 右侧：可增删的卡片 Grid ---
          // sm(手机): 占满12列
          // md(平板): 占8列
          GridCol({ span: { sm: 12, md: 8, lg: 9 } }) {
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

                    // (2) 删除按钮
                    Button() {
                      Image($r('app.media.ic_public_cancel'))
                        .width(16).height(16)
                        .fillColor('rgba(255,255,255,0.6)')
                    }
                    .type(ButtonType.Circle)
                    .backgroundColor('rgba(0,0,0,0.2)')
                    .width(24).height(24)
                    .margin({ top: 5, right: 5 })
                    .onClick(() => {
                      this.displayedCards.splice(index, 1);
                    })
                  }
                  .backgroundColor(this.isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(255, 255, 255, 0.25)')
                  .backdropBlur(20)
                  .border({ width: 0.5, color: 'rgba(255, 255, 255, 0.2)' })
                  .borderRadius(16)
                  .width('100%')
                  .height(this.currentBreakpoint === 'sm' ? 180 : '100%') // 手机模式下给个固定高度，平板模式下撑满
                }
              }, (key: string) => key)

              // 2. 渲染“添加”按钮
              if (this.displayedCards.length < 6) {
                GridItem() {
                  Button() {
                    Column() {
                      Text("+").fontSize(40).fontColor('rgba(255,255,255,0.5)').fontWeight(FontWeight.Lighter)
                      Text("添加卡片").fontSize(12).fontColor('rgba(255,255,255,0.5)')
                    }
                  }
                  .type(ButtonType.Normal)
                  .backgroundColor('rgba(255, 255, 255, 0.05)')
                  .border({ width: 1, color: 'rgba(255, 255, 255, 0.1)', style: BorderStyle.Dashed })
                  .borderRadius(16)
                  .width('100%')
                  .height(this.currentBreakpoint === 'sm' ? 180 : '100%')
                  .onClick(() => {
                    this.dialogController.open()
                  })
                }
              }

            }
            .columnsTemplate('1fr 1fr')
            .rowsTemplate(this.currentBreakpoint === 'sm' ? undefined : '1fr 1fr 1fr') // 手机模式下不固定行数，允许滚动
            .rowsGap(15)
            .columnsGap(15)
            .height(this.currentBreakpoint === 'sm' ? undefined : '100%') // 手机模式下高度自适应
          }

        }
        .onBreakpointChange((breakpoint: string) => {
          this.currentBreakpoint = breakpoint;
        })
        .width('100%').padding(15)
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .align(Alignment.TopStart)
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
