import router from '@ohos.router';
// 1. 引入后端（虽然我们不改它，但要读取它）
import { HealthSportsViewModel } from '../viewmodel/HealthSportsViewModel';

// 2. 【前端接口定义】
// 这是前端自己定的规则：不管后端给我什么，我最后都要变成这些样子来显示
// 这样前端UI代码就和后端数据结构彻底解耦了
interface UISportsData {
  stepsStr: string;      // 步数（字符串格式，如 "8,520"）
  stepsPercent: number;  // 步数进度（0-100）
  kcalStr: string;       // 卡路里
  kcalPercent: number; // [新增] 热量百分比
  heartRateStr: string;  // 心率
  sleepStr: string;      // 睡眠
  distanceStr: string;   // 距离
  bloodPressureStr: string; // 血压
  spo2Str: string;          // 血氧
  tempStr: string;          // 体温
  stressStr: string;
  sleepDateStr: string;
  stressDateStr: string;
  heartDateStr: string;
  bpDateStr: string;      // 血压日期
  spo2DateStr: string;    // 血氧日期
  tempDateStr: string;    // 体温日期
  stepsProgressStr: string; // 用于显示 "5200/10000"
  kcalProgressStr: string;  // 用于显示 "300/1200"
}

@Entry({ routeName: 'HealthSportsPage' })
@Component
export struct HealthSportsPage {
  // 3. 【前端状态】
  // 这是页面的"唯一真实数据源"，默认给一些空数据占位
  @State ui: UISportsData = {
    stepsStr: '--',
    stepsPercent: 0,
    kcalStr: '--',
    kcalPercent: 0, // [新增] 初始化
    heartRateStr: '--',
    sleepStr: '--',
    distanceStr: '--',
    bloodPressureStr: '--/--',
    spo2Str: '--%',
    tempStr: '--°C',
    stressStr: '--',
    sleepDateStr: '--/--',
    stressDateStr: '--/--',
    heartDateStr: '--/--',
    bpDateStr: '--/--',
    spo2DateStr: '--/--',
    tempDateStr: '--/--',
    stepsProgressStr: '0/10000',
    kcalProgressStr: '0/500'
  };

  aboutToAppear() {
    // =========================================================
    // 4. 【接口预留区 - 数据适配层】 (重点！)
    // 这里是前端和后端唯一的"握手"地方。
    // 如果以后后端变了，你只需要改这个函数，下面的UI代码完全不用动。
    // =========================================================

    // 假设1：如果你的后端需要调用 loadDataFromDatabase() 来触发加载
    // HealthSportsViewModel.loadDataFromDatabase && HealthSportsViewModel.loadDataFromDatabase();
    
    // 或者创建一个实例来使用方法
    // const viewModel = new HealthSportsViewModel();
    // viewModel.loadDataFromDatabase && viewModel.loadDataFromDatabase();

    // 创建 ViewModel 实例
    const viewModel = new HealthSportsViewModel();
    
    // 获取一次数据
    (async () => {
      try {
        // 获取后端数据
        const sportsData = await viewModel.getTodaySports();

        const currentSteps = sportsData.steps?.current || 0;
        const goalSteps = sportsData.steps?.goal || 10000; // 获取后端目标，若无则默认10000

        this.ui.stepsStr = currentSteps.toString();
        // [核心修改] 动态计算百分比
        this.ui.stepsPercent = (currentSteps / goalSteps) * 100;
        // [核心修改] 拼接 "当前/目标" 字符串
        this.ui.stepsProgressStr = `${currentSteps}/${goalSteps}`;
        // 开始映射 (Mapping)
        this.ui.stepsStr = (sportsData.steps?.current || 0).toString();
        this.ui.stepsPercent = (sportsData.steps?.current || 0) / 10000 * 100; // 假设目标1万步
        this.ui.kcalStr = (sportsData.calories?.current || 0) + ' kcal';
        this.ui.distanceStr = (sportsData.steps?.distance || 0) + ' km';

        // 映射热量 [修改这里]
        const currentKcal = sportsData.calories?.current || 0;
        const goalKcal = sportsData.calories?.goal || 500; // 获取后端目标

        this.ui.kcalStr = currentKcal.toString();
        // [核心修改] 动态计算百分比
        this.ui.kcalPercent = (currentKcal / goalKcal) * 100;
        // [核心修改] 拼接 "当前/目标" 字符串
        this.ui.kcalProgressStr = `${currentKcal}/${goalKcal}`;

        // 获取健康数据
        const healthData = await viewModel.getHealthData();
        this.ui.heartRateStr = (healthData.heart.heartRate || 0) + ' bpm';
        this.ui.sleepStr = (healthData.sleep.deepSleep || 0) + ' h';
        // 血压: 收缩压/舒张压
        this.ui.bloodPressureStr = `${healthData.bloodPressure.systolic}/${healthData.bloodPressure.diastolic} mmHg`;

        // 血氧
        this.ui.spo2Str = (healthData.bloodOxygen.spo2 || 0) + ' %';

        // 体温
        this.ui.tempStr = (healthData.temperature.value || 0).toFixed(1) + ' °C'; // 保留1位小数

        // 压力
        this.ui.stressStr = (healthData.stress.value || 0).toString();
        this.ui.sleepDateStr = healthData.sleep.date || '--/--';
        this.ui.stressDateStr = healthData.stress.date || '--/--';
        this.ui.heartDateStr = healthData.heart.date || '--/--';
        this.ui.bpDateStr = healthData.bloodPressure.date || '--/--';
        this.ui.spo2DateStr = healthData.bloodOxygen.date || '--/--';
        this.ui.tempDateStr = healthData.temperature.date || '--/--';
      } catch (error) {
        console.error('获取运动健康数据失败:', error);
      }
    })();
  }

  // =========================================================
  // 5. 【UI 渲染层】
  // 下面的代码只读 this.ui，完全不认识 Backend 是谁
  // =========================================================
  build() {
    Stack() {
      // 1. 背景层
      Image($r('app.media.bg_wellness'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      // 2. 遮罩层（让背景变暗，文字更清楚）
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0,0,0, 0.45)')

      // 3. 内容层
      Column() {
        // (1) 顶部导航栏 (保持不变)
        Row() {
          Image($r('app.media.icon_back'))
            .width(24).height(24)
            .fillColor(Color.White)
            .onClick(() => router.back()) // 点击返回
          Text('运动健康')
            .fontSize(20)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 16 })
        }
        .width('100%')
        .padding({ top: 40, left: 20 }) // 留出状态栏高度
        .alignItems(VerticalAlign.Center)
        // =============================================
        // (2) 核心仪表盘 (双圆环)
        Row() {
          // --- 左侧圆环：步数 ---
          Stack({ alignContent: Alignment.Center }) {
            // 背景圈
            Progress({ value: 100, total: 100, type: ProgressType.Ring })
              .width(150)
              .color('rgba(255,255,255,0.1)')
              .style({ strokeWidth: 12 })

            // 进度圈 (使用动态计算的 stepsPercent)
            Progress({ value: this.ui.stepsPercent, total: 100, type: ProgressType.Ring })
              .width(150)
              .color('#0A84FF')
              .style({ strokeWidth: 12 })

            Column() {
              Text('步数')
                .fontSize(12)
                .fontColor('rgba(255,255,255,0.6)')
              Text(this.ui.stepsPercent.toFixed(0) + '%')
                .fontSize(28) // 字体大小可以根据需要微调，比如改成 32 看起来更显眼
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)

              // [修改] 这里不再写死 '0/10000'，而是使用变量
              Text(this.ui.stepsProgressStr)
                .fontSize(10)
                .fontColor('rgba(255,255,255,0.4)')
                .margin({ top: 2 })
            }
          }
          .layoutWeight(1)

          // --- 右侧圆环：热量 ---
          Stack({ alignContent: Alignment.Center }) {
            // 背景圈
            Progress({ value: 100, total: 100, type: ProgressType.Ring })
              .width(150)
              .color('rgba(255,255,255,0.1)')
              .style({ strokeWidth: 12 })

            // 进度圈 (使用动态计算的 kcalPercent)
            Progress({ value: this.ui.kcalPercent, total: 100, type: ProgressType.Ring })
              .width(150)
              .color('#FF9F0A')
              .style({ strokeWidth: 12 })

            Column() {
              Text('热量')
                .fontSize(12)
                .fontColor('rgba(255,255,255,0.6)')
              // 【修改这里】 原来是 this.ui.kcalStr，改为百分比字符串
              Text(this.ui.kcalPercent.toFixed(0) + '%')
                .fontSize(28)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)

              // [修改] 这里不再写死，而是使用变量
              Text(this.ui.kcalProgressStr)
                .fontSize(10)
                .fontColor('rgba(255,255,255,0.4)')
                .margin({ top: 2 })
            }
          }
          .layoutWeight(1)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({ left: 10, right: 10 })
        .margin({ top: 30, bottom: 30 })

        // =========================================================
        // (3) 数据卡片网格 (按要求排序：睡眠、压力、心率、血压、血氧、体温)
        // =========================================================
        Grid() {
          // 1. 睡眠
          GridItem() {
            // [修改] 传入 this.ui.sleepDateStr
            this.DataCard('睡眠', this.ui.sleepStr, this.ui.sleepDateStr, $r('app.media.icon_sleep_quality'), '#30D158')
          }

          // 2. 压力
          GridItem() {
            this.DataCard('压力', this.ui.stressStr, this.ui.stressDateStr, $r('app.media.icon_pressure'), '#00D1FF')
          }

          // 3. 心率
          GridItem() {
            this.DataCard('心率', this.ui.heartRateStr, this.ui.heartDateStr, $r('app.media.icon_heart_rate'), '#FF375F')
          }

          // 4. 血压
          GridItem() {
            this.DataCard('血压', this.ui.bloodPressureStr, this.ui.bpDateStr, $r('app.media.icon_bloodpressure'), '#5E5CE6')
          }

          // 5. 血氧
          GridItem() {
            this.DataCard('血氧', this.ui.spo2Str, this.ui.spo2DateStr, $r('app.media.icon_blood_oxygen'), '#64D2FF')
          }

          // 6. 体温
          GridItem() {
            this.DataCard('体温', this.ui.tempStr, this.ui.tempDateStr, $r('app.media.icon_body_temperature'), '#FFD60A')
          }
        }
        .columnsTemplate('1fr 1fr')
        .rowsGap(12)
        .columnsGap(12)
        .padding({ left: 16, right: 16, bottom: 20 })
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
      .width('100%')
      .height('100%')
    }
  }

  // 封装的卡片组件
  // [修改] 增加 date 参数
  @Builder DataCard(title: string, value: string, date: string, icon: Resource, color: string) {
    Column() {
      // 1. 标题栏
      Row() {
        Image(icon)
          .width(20)
          .height(20)
          .fillColor(Color.White)
        Text(title)
          .fontSize(14)
          .fontColor('rgba(255,255,255,0.8)')
          .margin({ left: 8 })
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)

      // 2. 数值栏
      Text(value)
        .fontSize(24)
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.White)
        .margin({ top: 10 }) // 稍微减小间距

      // 3. [新增] 日期显示
      Text(date)
        .fontSize(12)
        .fontColor('rgba(255,255,255,0.5)') // 灰色小字
        .margin({ top: 4 })
    }
    .width('100%')
    .height(110)
    .backgroundColor('rgba(255, 255, 255, 0.1)')
    .backdropBlur(20)
    .borderRadius(16)
    .padding(16)
    .alignItems(HorizontalAlign.Start)
    .border({ width: { left: 4 }, color: color })
  }
}