// 文件路径: features/health/src/main/ets/page/HealthDataEditPage.ets
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { HealthDataService, HealthRecord } from '../database/HealthDataService';
import { HealthSportsViewModel } from '../viewmodel/HealthSportsViewModel';

@Entry({ routeName: 'HealthDataEditPage' })
@Component
export struct HealthDataEditPage {
  // 状态变量，用于绑定输入框
  @State selectedDate: Date = new Date(); // 默认当前日期
  @State dateStr: string = '';

  // 各项健康数据状态 (使用字符串方便输入，提交时转数字)
  @State steps: string = '';
  @State calories: string = '';
  @State distance: string = ''; // 距离(km)
  @State deepSleep: string = '';
  @State lightSleep: string = '';
  @State heartRate: string = '';
  @State stress: string = '';
  @State bpSystolic: string = ''; // 收缩压
  @State bpDiastolic: string = ''; // 舒张压
  @State spo2: string = '';
  @State temperature: string = '';

  async aboutToAppear() {
    this.dateStr = HealthDataService.formatDate(this.selectedDate);

    // 【修改点1】进入页面时，务必先初始化数据库，并加载当天已有数据
    await HealthDataService.init(getContext(this));
    this.loadExistingData(this.dateStr);
  }

  // 显示日期选择器
  showDatePicker() {
    DatePickerDialog.show({
      start: new Date("2020-01-01"),
      end: new Date("2100-12-31"),
      selected: this.selectedDate,
      onAccept: (value: DatePickerResult) => {
        // 更新选中的日期
        const newDate = new Date(value.year!, value.month!, value.day!);
        this.selectedDate = newDate;
        this.dateStr = HealthDataService.formatDate(newDate);

        // 可以在这里加载该日期已有的数据进行回显（可选优化）
        this.loadExistingData(this.dateStr);
      }
    })
  }

  // 加载所选日期的现有数据 (可选)
  async loadExistingData(date: string) {
    try {
      const record = await HealthDataService.getHealthDataByDate(date);
      if (record) {
        this.steps = record.stepsCurrent > 0 ? record.stepsCurrent.toString() : '';
        this.calories = record.caloriesCurrent > 0 ? record.caloriesCurrent.toString() : '';
        this.distance = record.stepsDistance > 0 ? record.stepsDistance.toString() : '';
        this.deepSleep = record.sleepDeep > 0 ? record.sleepDeep.toString() : '';
        this.lightSleep = record.sleepLight > 0 ? record.sleepLight.toString() : '';
        this.heartRate = record.heartRate > 0 ? record.heartRate.toString() : '';
        this.stress = record.stressValue > 0 ? record.stressValue.toString() : '';
        this.bpSystolic = record.bpSystolic > 0 ? record.bpSystolic.toString() : '';
        this.bpDiastolic = record.bpDiastolic > 0 ? record.bpDiastolic.toString() : '';
        this.spo2 = record.spo2 > 0 ? record.spo2.toString() : '';
        this.temperature = record.temperature > 0 ? record.temperature.toString() : '';
        promptAction.showToast({ message: `已加载 ${date} 的数据` });
      } else {
        // 清空表单
        this.steps = ''; this.calories = ''; this.distance = '';
        this.deepSleep = ''; this.lightSleep = ''; this.heartRate = '';
        this.stress = ''; this.bpSystolic = ''; this.bpDiastolic = '';
        this.spo2 = ''; this.temperature = '';
      }
    } catch (e) {
      console.error('加载数据失败', e);
    }
  }

  // 提交数据
  async submitData() {
    try {
      const userId = HealthDataService.getCurrentUserId();

      // 1. 先尝试获取当天的已有记录
      let record = await HealthDataService.getHealthDataByDate(this.dateStr);

      // 2. 如果当天还没有记录，就创建一个新的
      if (!record) {
        record = new HealthRecord();
        record.initialize(this.dateStr, userId);
      }

      // 3. 只更新用户填写的字段 (如果输入框不为空)
      // 使用 || 0 并不是最好的做法，因为可能想输入0。
      // 更好的做法是判断字符串是否为空。

      if (this.steps !== '') record.stepsCurrent = parseInt(this.steps);
      if (this.calories !== '') record.caloriesCurrent = parseInt(this.calories);
      if (this.distance !== '') record.stepsDistance = parseFloat(this.distance);

      // 自动计算一下距离和卡路里（如果用户没填，但填了步数，可以给个估算，可选）
      // if (this.steps !== '' && this.distance === '') record.stepsDistance = record.stepsCurrent * 0.0007;

      if (this.deepSleep !== '') record.sleepDeep = parseFloat(this.deepSleep);
      if (this.lightSleep !== '') record.sleepLight = parseFloat(this.lightSleep);
      // 重新计算总睡眠
      record.sleepTotal = record.sleepDeep + record.sleepLight;

      if (this.heartRate !== '') record.heartRate = parseInt(this.heartRate);
      if (this.stress !== '') record.stressValue = parseInt(this.stress);

      if (this.bpSystolic !== '') record.bpSystolic = parseInt(this.bpSystolic);
      if (this.bpDiastolic !== '') record.bpDiastolic = parseInt(this.bpDiastolic);

      if (this.spo2 !== '') record.spo2 = parseInt(this.spo2);
      if (this.temperature !== '') record.temperature = parseFloat(this.temperature);

      // 4. 保存到数据库
      await HealthDataService.saveHealthData(record);

      promptAction.showToast({ message: '数据保存成功！' });
      setTimeout(() => {
        router.back();
      }, 500);

    } catch (error) {
      console.error('保存失败', error);
      promptAction.showToast({ message: '保存失败: ' + JSON.stringify(error) });
    }
  }

  build() {
    Column() {
      // 1. 顶部标题栏
      Row() {
        Image($r('app.media.icon_back'))
          .width(24).height(24)
          .fillColor(Color.Black)
          .onClick(() => router.back())
        Text('录入健康数据')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 16 })
      }
      .width('100%')
      .padding({ top: 40, left: 20, bottom: 20 })
      .backgroundColor(Color.White)

      // 2. 表单内容区
      Scroll() {
        Column({ space: 16 }) {

          // --- 日期选择 ---
          this.FormItemTitle('日期 (点击选择)')
          Row() {
            Text(this.dateStr)
              .fontSize(18)
              .fontColor(Color.Blue)
            Image($r('app.media.more')) // 假设有箭头图标，没有也没关系
              .width(16).height(16)
              .margin({ left: 8 })
              .fillColor(Color.Gray)
          }
          .width('100%')
          .padding(12)
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .onClick(() => this.showDatePicker())

          // --- 运动数据 ---
          this.FormItemTitle('运动信息')
          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
            this.InputBox('步数', '例如: 8000', this.steps, (val) => this.steps = val)
            this.InputBox('热量(kcal)', '例如: 500', this.calories, (val) => this.calories = val)
            this.InputBox('距离(km)', '例如: 5.2', this.distance, (val) => this.distance = val)
          }

          // --- 睡眠数据 ---
          this.FormItemTitle('睡眠 (小时)')
          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
            this.InputBox('深睡', '例如: 2.5', this.deepSleep, (val) => this.deepSleep = val)
            this.InputBox('浅睡', '例如: 5.0', this.lightSleep, (val) => this.lightSleep = val)
          }

          // --- 身体指标 ---
          this.FormItemTitle('身体指标')
          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
            this.InputBox('心率(bpm)', '例如: 75', this.heartRate, (val) => this.heartRate = val)
            this.InputBox('血氧(%)', '例如: 98', this.spo2, (val) => this.spo2 = val)
            this.InputBox('体温(°C)', '例如: 36.5', this.temperature, (val) => this.temperature = val)
            this.InputBox('压力值(0-99)', '例如: 40', this.stress, (val) => this.stress = val)
          }

          // --- 血压 ---
          this.FormItemTitle('血压 (mmHg)')
          Row({ space: 10 }) {
            TextInput({ placeholder: '收缩压(高压)', text: this.bpSystolic })
              .type(InputType.Number)
              .layoutWeight(1)
              .height(45)
              .backgroundColor('#F5F5F5')
              .borderRadius(8)
              .onChange((val) => this.bpSystolic = val)

            Text('/').fontSize(20).fontColor(Color.Gray)

            TextInput({ placeholder: '舒张压(低压)', text: this.bpDiastolic })
              .type(InputType.Number)
              .layoutWeight(1)
              .height(45)
              .backgroundColor('#F5F5F5')
              .borderRadius(8)
              .onChange((val) => this.bpDiastolic = val)
          }.width('100%')

          // --- 提交按钮 ---
          Button('确认提交', { type: ButtonType.Capsule, stateEffect: true })
            .width('100%')
            .height(50)
            .fontSize(18)
            .margin({ top: 30, bottom: 50 })
            .backgroundColor('#0A84FF')
            .onClick(() => this.submitData())

        }
        .padding(20)
      }
      .layoutWeight(1)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }

  // 辅助构建器：标题
  @Builder FormItemTitle(title: string) {
    Text(title)
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .width('100%')
      .margin({ top: 8, bottom: 8 })
      .fontColor('#333')
  }

  // 辅助构建器：输入框
  @Builder InputBox(label: string, placeholder: string, value: string, onChange: (val: string) => void) {
    Column() {
      Text(label).fontSize(12).fontColor(Color.Gray).margin({ bottom: 4 }).width('100%')
      TextInput({ placeholder: placeholder, text: value })
        .type(InputType.NUMBER_DECIMAL) // 支持小数
        .width('100%')
        .height(40)
        .backgroundColor('#F5F5F5')
        .borderRadius(8)
        .onChange(onChange)
    }
    .width('48%') // 稍微留点空隙
    .margin({ bottom: 12 })
  }
}