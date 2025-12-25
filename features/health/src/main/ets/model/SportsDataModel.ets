// features/health/src/main/ets/model/SportsDataModel.ets

export class TodaySportsData {
  steps: StepsData = new StepsData();
  calories: CaloriesData = new CaloriesData();
}

export class StepsData {
  current: number = 0;
  goal: number = 10000;
  distance: number = 0;
}

export class CaloriesData {
  current: number = 0;
  goal: number = 1200;
  unit: string = '卡路里';
}

export class HealthData {
  sleep: SleepData = new SleepData();
  stress: StressData = new StressData();
  heart: HeartData = new HeartData();
  bloodPressure: BloodPressureData = new BloodPressureData();
  bloodOxygen: BloodOxygenData = new BloodOxygenData();
  temperature: TemperatureData = new TemperatureData();
}

export class SleepData {
  deepSleep: number = 0;
  lightSleep: number = 0;
  totalSleep: number = 0;
  date: string = '';
}

export class StressData {
  value: number = 0;
  date: string = '';
}

export class HeartData {
  heartRate: number = 0;
  date: string = '';
}

export class BloodPressureData {
  systolic: number = 0;
  diastolic: number = 0;
  unit: string = 'mmHg';
  date: string = '';
}

export class BloodOxygenData {
  spo2: number = 0;
  unit: string = '%';
  date: string = '';
}

export class TemperatureData {
  value: number = 0;
  unit: string = '℃';
  date: string = '';
}