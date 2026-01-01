import router from '@ohos.router';
import { HealthSportsViewModel } from '../viewmodel/HealthSportsViewModel';
// 引入编辑页文件，确保命名路由 'HealthDataEditPage' 被注册
import './HealthDataEditPage';

interface UISportsData {
  stepsStr: string;
  stepsPercent: number;
  kcalStr: string;
  kcalPercent: number;
  heartRateStr: string;
  sleepStr: string;
  distanceStr: string;
  bloodPressureStr: string;
  spo2Str: string;
  tempStr: string;
  stressStr: string;
  sleepDateStr: string;
  stressDateStr: string;
  heartDateStr: string;
  bpDateStr: string;
  spo2DateStr: string;
  tempDateStr: string;
  stepsProgressStr: string;
  kcalProgressStr: string;
}

@Entry({ routeName: 'HealthSportsPage' })
@Component
export struct HealthSportsPage {
  @State ui: UISportsData = {
    stepsStr: '--',
    stepsPercent: 0,
    kcalStr: '--',
    kcalPercent: 0,
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
    // 初始化数据库服务
    HealthSportsViewModel.init(getContext(this)).then(() => {
      this.loadData();
    });
  }

  onPageShow() {
    this.loadData();
  }

  loadData() {
    const viewModel = new HealthSportsViewModel();
    (async () => {
      try {
        const sportsData = await viewModel.getTodaySports();
        const currentSteps = sportsData.steps?.current || 0;
        const goalSteps = sportsData.steps?.goal || 10000;

        this.ui.stepsStr = currentSteps.toString();
        this.ui.stepsPercent = (currentSteps / goalSteps) * 100;
        this.ui.stepsProgressStr = `${currentSteps}/${goalSteps}`;
        this.ui.distanceStr = (sportsData.steps?.distance || 0).toFixed(1) + ' km';

        const currentKcal = sportsData.calories?.current || 0;
        const goalKcal = sportsData.calories?.goal || 500;

        this.ui.kcalStr = currentKcal.toString();
        this.ui.kcalPercent = (currentKcal / goalKcal) * 100;
        this.ui.kcalProgressStr = `${currentKcal}/${goalKcal}`;

        const healthData = await viewModel.getHealthData();
        this.ui.heartRateStr = (healthData.heart.heartRate || 0) + ' bpm';
        this.ui.sleepStr = (healthData.sleep.totalSleep || healthData.sleep.deepSleep || 0).toFixed(1) + ' h';
        this.ui.bloodPressureStr = `${healthData.bloodPressure.systolic}/${healthData.bloodPressure.diastolic} mmHg`;
        this.ui.spo2Str = (healthData.bloodOxygen.spo2 || 0) + ' %';
        this.ui.tempStr = (healthData.temperature.value || 0).toFixed(1) + ' °C';
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

  build() {
    Stack() {
      // 1. 背景层
      Image($r('app.media.bg_wellness'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      // 2. 遮罩层
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0,0,0, 0.45)')

      // 3. 内容层
      Column() {
        // =========================================================
        // (1) 顶部导航栏 (包含右上角数据录入入口)
        // =========================================================
        Row() {
          Image($r('app.media.icon_back'))
            .width(24).height(24)
            .fillColor(Color.White)
            .onClick(() => router.back())

          Text('运动健康')
            .fontSize(20)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 16 })

          // 【关键点】使用 Blank() 占据中间空间，把后面的按钮推到最右边
          Blank()

          // 【保留】右上角的数据录入入口
          Row() {
            // 可选：加个小图标
            // Image($r('app.media.icon_edit')).width(16).height(16).fillColor(Color.White).margin({right:4})
            Text('数据录入')
              .fontColor(Color.White)
              .fontSize(14)
          }
          .padding({ top: 6, bottom: 6, left: 12, right: 12 })
          .backgroundColor('rgba(255,255,255,0.2)') // 半透明背景
          .borderRadius(20)
          .onClick(() => {
            try {
              router.pushNamedRoute({
                name: 'HealthDataEditPage'
              });
            } catch (e) {
              console.error('跳转失败:', JSON.stringify(e));
            }
          })
        }
        .width('100%')
        .padding({ top: 40, left: 20, right: 20 }) // 确保 right padding 足够
        .alignItems(VerticalAlign.Center)

        // =========================================================
        // (2) 核心仪表盘 (中间区域 - 纯展示)
        // =========================================================
        Row() {
          // --- 左侧圆环：步数 ---
          Stack({ alignContent: Alignment.Center }) {
            Progress({ value: 100, total: 100, type: ProgressType.Ring })
              .width(150).color('rgba(255,255,255,0.1)').style({ strokeWidth: 12 })
            Progress({ value: this.ui.stepsPercent, total: 100, type: ProgressType.Ring })
              .width(150).color('#0A84FF').style({ strokeWidth: 12 })
            Column() {
              Text('步数').fontSize(12).fontColor('rgba(255,255,255,0.6)')
              Text(this.ui.stepsPercent.toFixed(0) + '%').fontSize(28).fontWeight(FontWeight.Bold).fontColor(Color.White)
              Text(this.ui.stepsProgressStr).fontSize(10).fontColor('rgba(255,255,255,0.4)').margin({ top: 2 })
            }
          }.layoutWeight(1)

          // --- 右侧圆环：热量 ---
          Stack({ alignContent: Alignment.Center }) {
            Progress({ value: 100, total: 100, type: ProgressType.Ring })
              .width(150).color('rgba(255,255,255,0.1)').style({ strokeWidth: 12 })
            Progress({ value: this.ui.kcalPercent, total: 100, type: ProgressType.Ring })
              .width(150).color('#FF9F0A').style({ strokeWidth: 12 })
            Column() {
              Text('热量').fontSize(12).fontColor('rgba(255,255,255,0.6)')
              Text(this.ui.kcalPercent.toFixed(0) + '%').fontSize(28).fontWeight(FontWeight.Bold).fontColor(Color.White)
              Text(this.ui.kcalProgressStr).fontSize(10).fontColor('rgba(255,255,255,0.4)').margin({ top: 2 })
            }
          }.layoutWeight(1)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({ left: 10, right: 10 })
        .margin({ top: 30, bottom: 30 })

        // =========================================================
        // (3) 数据卡片网格 (底部区域 - 纯展示)
        // =========================================================
        Grid() {
          GridItem() { this.DataCard('睡眠', this.ui.sleepStr, this.ui.sleepDateStr, $r('app.media.icon_sleep_quality'), '#30D158') }
          GridItem() { this.DataCard('压力', this.ui.stressStr, this.ui.stressDateStr, $r('app.media.icon_pressure'), '#00D1FF') }
          GridItem() { this.DataCard('心率', this.ui.heartRateStr, this.ui.heartDateStr, $r('app.media.icon_heart_rate'), '#FF375F') }
          GridItem() { this.DataCard('血压', this.ui.bloodPressureStr, this.ui.bpDateStr, $r('app.media.icon_bloodpressure'), '#5E5CE6') }
          GridItem() { this.DataCard('血氧', this.ui.spo2Str, this.ui.spo2DateStr, $r('app.media.icon_blood_oxygen'), '#64D2FF') }
          GridItem() { this.DataCard('体温', this.ui.tempStr, this.ui.tempDateStr, $r('app.media.icon_body_temperature'), '#FFD60A') }
        }
        .columnsTemplate('1fr 1fr')
        .rowsGap(12)
        .columnsGap(12)
        .padding({ left: 16, right: 16, bottom: 20 })
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
    }
  }

  @Builder DataCard(title: string, value: string, date: string, icon: Resource, color: string) {
    Column() {
      Row() {
        Image(icon).width(20).height(20).fillColor(Color.White)
        Text(title).fontSize(14).fontColor('rgba(255,255,255,0.8)').margin({ left: 8 })
      }.width('100%').alignItems(VerticalAlign.Center)

      Text(value).fontSize(24).fontWeight(FontWeight.Medium).fontColor(Color.White).margin({ top: 10 })
      Text(date).fontSize(12).fontColor('rgba(255,255,255,0.5)').margin({ top: 4 })
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