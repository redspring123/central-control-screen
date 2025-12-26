

import { http } from '@kit.NetworkKit';
import { TodaySportsData, HealthData, DatabaseResult } from '../model/SportsDataModel';
import { MockDataService } from '../model/MockDataService';
import { HealthDatabase } from '../database/HealthDatabase';

export class HealthSportsViewModel {
  private baseUrl: string = 'https://your-api-domain.com/api';//在这里填入后端的baseUrl
  private useMockData: boolean = true;

  constructor() {
    HealthDatabase.setContext(getContext(this));
  }

  async getTodaySports(): Promise<TodaySportsData> {
    if (this.useMockData) {
      return MockDataService.getTodaySports();
    }
    return this.requestTodaySportsFromApi();
  }

  async getHealthData(): Promise<HealthData> {
    if (this.useMockData) {
      return MockDataService.getHealthData();
    }
    return this.requestHealthDataFromApi();
  }

  async loadDataFromDatabase(): Promise<DatabaseResult> {
    try {
      const sportsData = await HealthDatabase.getLatestSportsData();
      const healthData = await HealthDatabase.getLatestHealthData();
      console.info('从数据库加载数据成功');
      const result = new DatabaseResult();
      result.sports = sportsData;
      result.health = healthData;
      return result;
    } catch (error) {
      console.error(`从数据库加载数据失败: ${JSON.stringify(error)}`);
      const result = new DatabaseResult();
      result.sports = null;
      result.health = null;
      return result;
    }
  }

  async syncDataToDatabase(sportsData: TodaySportsData, healthData: HealthData): Promise<void> {
    try {
      await HealthDatabase.saveSportsData(sportsData);
      await HealthDatabase.saveHealthData(healthData);
      console.info('数据同步到数据库成功');
    } catch (error) {
      console.error(`数据同步到数据库失败: ${JSON.stringify(error)}`);
    }
  }

  setUseMockData(useMock: boolean): void {
    this.useMockData = useMock;
  }

  private async requestTodaySportsFromApi(): Promise<TodaySportsData> {
    const httpRequest: http.HttpRequest = http.createHttp();
    const result: TodaySportsData = new TodaySportsData();

    try {
      const response: http.HttpResponse = await httpRequest.request(
        `${this.baseUrl}/health/sports/today`,
        {
          method: http.RequestMethod.GET,
          header: { 'Content-Type': 'application/json' }
        }
      );

      if (response.responseCode === 200) {
        const responseObj: Record<string, Object> = JSON.parse(response.result as string);
        const sportsData = responseObj.data as TodaySportsData;

        if (sportsData && sportsData.steps && sportsData.calories) {
          result.steps.current = sportsData.steps.current;
          result.steps.goal = sportsData.steps.goal;
          result.steps.distance = sportsData.steps.distance;
          result.calories.current = sportsData.calories.current;
          result.calories.goal = sportsData.calories.goal;
        }
      }
    } catch (error) {
      console.error(`获取今日运动数据失败: ${JSON.stringify(error)}`);
    } finally {
      httpRequest.destroy();
    }

    return result;
  }

  private async requestHealthDataFromApi(): Promise<HealthData> {
    const httpRequest: http.HttpRequest = http.createHttp();
    const result: HealthData = new HealthData();

    try {
      const response: http.HttpResponse = await httpRequest.request(
        `${this.baseUrl}/health/data`,
        {
          method: http.RequestMethod.GET,
          header: { 'Content-Type': 'application/json' }
        }
      );

      if (response.responseCode === 200) {
        const responseObj: Record<string, Object> = JSON.parse(response.result as string);
        const healthData = responseObj.data as HealthData;

        if (healthData && healthData.sleep) {
          result.sleep.deepSleep = healthData.sleep.deepSleep;
          result.sleep.date = healthData.sleep.date;
          result.stress.value = healthData.stress.value;
          result.stress.date = healthData.stress.date;
          result.heart.heartRate = healthData.heart.heartRate;
          result.heart.date = healthData.heart.date;
          result.bloodPressure.systolic = healthData.bloodPressure.systolic;
          result.bloodPressure.diastolic = healthData.bloodPressure.diastolic;
          result.bloodOxygen.spo2 = healthData.bloodOxygen.spo2;
          result.temperature.value = healthData.temperature.value;
          result.temperature.date = healthData.temperature.date;
        }
      }
    } catch (error) {
      console.error(`获取健康数据失败: ${JSON.stringify(error)}`);
    } finally {
      httpRequest.destroy();
    }

    return result;
  }
}