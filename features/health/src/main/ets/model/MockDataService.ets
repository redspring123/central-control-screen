// features/health/src/main/ets/model/MockDataService.ets

import { TodaySportsData, HealthData, StepsData, CaloriesData, SleepData, StressData, HeartData, BloodPressureData, BloodOxygenData, TemperatureData } from './SportsDataModel';

function getTodayDateString(): string {
  const now: Date = new Date();
  const month: string = (now.getMonth() + 1).toString().padStart(2, '0');
  const day: string = now.getDate().toString().padStart(2, '0');
  return `${month}-${day}`;
}

function getRandomFloat(min: number, max: number, decimals: number = 1): number {
  const random: number = Math.random() * (max - min) + min;
  const multiplier: number = Math.pow(10, decimals);
  return Math.round(random * multiplier) / multiplier;
}

function getRandomInt(min: number, max: number): number {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

function isRestingTime(): boolean {
  const currentHour: number = new Date().getHours();
  return currentHour < 6 || currentHour > 22;
}

export class MockDataService {
  static getTodaySports(): TodaySportsData {
    const sportsData = new TodaySportsData();

    sportsData.steps = new StepsData();
    sportsData.steps.goal = 10000;
    sportsData.steps.distance = getRandomFloat(3.5, 6.5, 1);
    sportsData.steps.current = Math.floor(sportsData.steps.distance * 1500);

    sportsData.calories = new CaloriesData();
    sportsData.calories.goal = 1200;
    sportsData.calories.current = Math.floor(sportsData.steps.current * 0.1);

    return sportsData;
  }

  static getHealthData(): HealthData {
    const healthData = new HealthData();
    const todayDate: string = getTodayDateString();

    healthData.sleep = new SleepData();
    healthData.sleep.date = todayDate;
    healthData.sleep.deepSleep = getRandomFloat(5.5, 9.5, 1);
    healthData.sleep.lightSleep = getRandomFloat(2.0, 4.5, 1);
    healthData.sleep.totalSleep = parseFloat((healthData.sleep.deepSleep + healthData.sleep.lightSleep).toFixed(1));

    healthData.stress = new StressData();
    healthData.stress.date = todayDate;
    healthData.stress.value = getRandomInt(20, 80);

    healthData.heart = new HeartData();
    healthData.heart.date = todayDate;
    healthData.heart.heartRate = isRestingTime()
      ? getRandomInt(55, 75)
      : getRandomInt(70, 110);

    healthData.bloodPressure = new BloodPressureData();
    healthData.bloodPressure.date = todayDate;
    healthData.bloodPressure.systolic = getRandomInt(110, 140);
    healthData.bloodPressure.diastolic = getRandomInt(70, 90);

    healthData.bloodOxygen = new BloodOxygenData();
    healthData.bloodOxygen.date = todayDate;
    healthData.bloodOxygen.spo2 = getRandomInt(94, 100);

    healthData.temperature = new TemperatureData();
    healthData.temperature.date = todayDate;
    healthData.temperature.value = getRandomFloat(36.1, 37.0, 1);

    return healthData;
  }

  static getRealtimeSensorData(): RealtimeSensorData {
    const heartRate: number = isRestingTime()
      ? getRandomInt(55, 75)
      : getRandomInt(70, 110);

    const bloodOxygen: number = getRandomInt(94, 100);

    const baseSteps: number = Math.floor(Date.now() / 10000) % 10000;
    const steps: number = baseSteps + getRandomInt(0, 50);

    const calories: number = Math.floor(steps * 0.1) + getRandomInt(0, 20);

    const temperature: number = getRandomFloat(36.1, 37.0, 1);

    return {
      heartRate,
      bloodOxygen,
      steps,
      calories,
      temperature
    };
  }

  static getTodaySteps(): StepsData {
    const steps = new StepsData();
    steps.goal = 10000;
    steps.distance = getRandomFloat(3.5, 6.5, 1);
    steps.current = Math.floor(steps.distance * 1500);
    return steps;
  }

  static getTodayCalories(): CaloriesData {
    const calories = new CaloriesData();
    calories.goal = 1200;
    calories.current = getRandomInt(400, 800);
    return calories;
  }

  static getCurrentStress(): StressData {
    const stress = new StressData();
    stress.value = getRandomInt(20, 80);
    stress.date = getTodayDateString();
    return stress;
  }

  static getCurrentHeartRate(): HeartData {
    const heart = new HeartData();
    heart.heartRate = isRestingTime()
      ? getRandomInt(55, 75)
      : getRandomInt(70, 110);
    heart.date = getTodayDateString();
    return heart;
  }

  static getCurrentBloodPressure(): BloodPressureData {
    const bp = new BloodPressureData();
    bp.systolic = getRandomInt(110, 140);
    bp.diastolic = getRandomInt(70, 90);
    bp.date = getTodayDateString();
    return bp;
  }

  static getCurrentBloodOxygen(): BloodOxygenData {
    const o2 = new BloodOxygenData();
    o2.spo2 = getRandomInt(94, 100);
    o2.date = getTodayDateString();
    return o2;
  }

  static getCurrentTemperature(): TemperatureData {
    const temp = new TemperatureData();
    temp.value = getRandomFloat(36.1, 37.0, 1);
    temp.date = getTodayDateString();
    return temp;
  }

  static getCurrentSleep(): SleepData {
    const sleep = new SleepData();
    sleep.deepSleep = getRandomFloat(5.5, 9.5, 1);
    sleep.lightSleep = getRandomFloat(2.0, 4.5, 1);
    sleep.totalSleep = parseFloat((sleep.deepSleep + sleep.lightSleep).toFixed(1));
    sleep.date = getTodayDateString();
    return sleep;
  }
}

interface RealtimeSensorData {
  heartRate: number;
  bloodOxygen: number;
  steps: number;
  calories: number;
  temperature: number;
}