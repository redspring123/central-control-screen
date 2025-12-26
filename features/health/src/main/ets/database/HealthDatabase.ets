// features/health/src/main/ets/database/HealthDatabase.ets
import { relationalStore } from '@kit.ArkData';
import { Context } from '@kit.AbilityKit';
// 【修改1】删除未使用的导入类型，解决“变量声明后未使用”警告
import { TodaySportsData, HealthData } from '../model/SportsDataModel';

const RDB_TABLE_NAME: string = 'HEALTH_DATA';
const SQL_CREATE_TABLE: string = `
  CREATE TABLE IF NOT EXISTS ${RDB_TABLE_NAME} (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    DATA_TYPE TEXT NOT NULL,
    STEPS_CURRENT INTEGER DEFAULT 0,
    STEPS_GOAL INTEGER DEFAULT 10000,
    STEPS_DISTANCE REAL DEFAULT 0,
    CALORIES_CURRENT INTEGER DEFAULT 0,
    CALORIES_GOAL INTEGER DEFAULT 1200,
    SLEEP_DEEP REAL DEFAULT 0,
    SLEEP_LIGHT REAL DEFAULT 0,
    SLEEP_DATE TEXT,
    STRESS_VALUE INTEGER DEFAULT 0,
    STRESS_DATE TEXT,
    HEART_RATE INTEGER DEFAULT 0,
    HEART_DATE TEXT,
    BP_SYSTOLIC INTEGER DEFAULT 0,
    BP_DIASTOLIC INTEGER DEFAULT 0,
    BP_DATE TEXT,
    SPO2 INTEGER DEFAULT 0,
    SPO2_DATE TEXT,
    TEMPERATURE REAL DEFAULT 0,
    TEMP_DATE TEXT,
    UPDATE_TIME TEXT
  )
`;

export class HealthDatabase {
  private static rdbStore: relationalStore.RdbStore | null = null;
  private static context: Context | null = null;

  // 【修改2】替换static方法中的this为类名HealthDatabase，解决“独立函数不支持this”
  static setContext(context: Context): void {
    HealthDatabase.context = context;
  }

  static async init(): Promise<void> {
    // 【修改2】替换this为HealthDatabase
    if (HealthDatabase.rdbStore) {
      return;
    }
    if (!HealthDatabase.context) {
      console.error('HealthDatabase: context未设置，请先调用setContext()');
      return;
    }

    const config: relationalStore.StoreConfig = {
      name: 'HealthDatabase.db',
      securityLevel: relationalStore.SecurityLevel.S1
    };

    try {
      // 【修改3】修正getRdbStore参数（需传入context+config），解决“参数数量错误/类型不匹配”
      HealthDatabase.rdbStore = await relationalStore.getRdbStore(HealthDatabase.context, config);
      // 【修改4】增加非空断言+空值检查，解决“对象可能为null”
      if (HealthDatabase.rdbStore) {
        await HealthDatabase.rdbStore.executeSql(SQL_CREATE_TABLE);
        console.info('HealthDatabase: 初始化成功');
      }
    } catch (error) {
      console.error(`HealthDatabase: 初始化失败 - ${JSON.stringify(error)}`);
      // 【修改5】throw仅抛Error对象，解决“throw语句类型不合法”
      throw new Error(`数据库初始化失败: ${JSON.stringify(error)}`);
    }
  }

  static async saveSportsData(data: TodaySportsData): Promise<void> {
    if (!HealthDatabase.rdbStore) {
      await HealthDatabase.init();
    }

    const valueBucket: relationalStore.ValuesBucket = {
      DATA_TYPE: 'SPORTS',
      STEPS_CURRENT: data.steps.current,
      STEPS_GOAL: data.steps.goal,
      STEPS_DISTANCE: data.steps.distance,
      CALORIES_CURRENT: data.calories.current,
      CALORIES_GOAL: data.calories.goal,
      UPDATE_TIME: new Date().toISOString()
    };

    try {
      await HealthDatabase.rdbStore!.insert(RDB_TABLE_NAME, valueBucket);
      console.info('HealthDatabase: 运动数据保存成功');
    } catch (error) {
      console.error(`HealthDatabase: 运动数据保存失败 - ${JSON.stringify(error)}`);
      throw new Error(`保存运动数据失败: ${JSON.stringify(error)}`);
    }
  }

  static async saveHealthData(data: HealthData): Promise<void> {
    if (!HealthDatabase.rdbStore) {
      await HealthDatabase.init();
    }

    const valueBucket: relationalStore.ValuesBucket = {
      DATA_TYPE: 'HEALTH',
      SLEEP_DEEP: data.sleep.deepSleep,
      SLEEP_LIGHT: data.sleep.lightSleep,
      SLEEP_DATE: data.sleep.date,
      STRESS_VALUE: data.stress.value,
      STRESS_DATE: data.stress.date,
      HEART_RATE: data.heart.heartRate,
      HEART_DATE: data.heart.date,
      BP_SYSTOLIC: data.bloodPressure.systolic,
      BP_DIASTOLIC: data.bloodPressure.diastolic,
      BP_DATE: data.bloodPressure.date,
      SPO2: data.bloodOxygen.spo2,
      SPO2_DATE: data.bloodOxygen.date,
      TEMPERATURE: data.temperature.value,
      TEMP_DATE: data.temperature.date,
      UPDATE_TIME: new Date().toISOString()
    };

    try {
      await HealthDatabase.rdbStore!.insert(RDB_TABLE_NAME, valueBucket);
      console.info('HealthDatabase: 健康数据保存成功');
    } catch (error) {
      console.error(`HealthDatabase: 健康数据保存失败 - ${JSON.stringify(error)}`);
      throw new Error(`保存健康数据失败: ${JSON.stringify(error)}`);
    }
  }

  static async getLatestSportsData(): Promise<TodaySportsData | null> {
    if (!HealthDatabase.rdbStore) {
      await HealthDatabase.init();
    }

    const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(RDB_TABLE_NAME);
    predicates.equalTo('DATA_TYPE', 'SPORTS');
    predicates.orderByDesc('UPDATE_TIME');
    // 【修改6】替换limit为limitAs(0,1)，解决“limit属性不存在”（鸿蒙API规范：limitAs(offset, count)）
    predicates.limitAs(1);

    try {
      const resultSet = await HealthDatabase.rdbStore!.query(predicates);
      if (resultSet.goToFirstRow()) {
        const data = new TodaySportsData();
        data.steps.current = resultSet.getLong(resultSet.getColumnIndex('STEPS_CURRENT'));
        data.steps.goal = resultSet.getLong(resultSet.getColumnIndex('STEPS_GOAL'));
        data.steps.distance = resultSet.getDouble(resultSet.getColumnIndex('STEPS_DISTANCE'));
        data.calories.current = resultSet.getLong(resultSet.getColumnIndex('CALORIES_CURRENT'));
        data.calories.goal = resultSet.getLong(resultSet.getColumnIndex('CALORIES_GOAL'));
        resultSet.close();
        return data;
      }
      resultSet.close();
      return null;
    } catch (error) {
      console.error(`HealthDatabase: 查询运动数据失败 - ${JSON.stringify(error)}`);
      throw new Error(`查询运动数据失败: ${JSON.stringify(error)}`);
    }
  }

  static async getLatestHealthData(): Promise<HealthData | null> {
    if (!HealthDatabase.rdbStore) {
      await HealthDatabase.init();
    }

    const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(RDB_TABLE_NAME);
    predicates.equalTo('DATA_TYPE', 'HEALTH');
    predicates.orderByDesc('UPDATE_TIME');
    // 【修改6】替换limit为limitAs(0,1)
    predicates.limitAs(1);

    try {
      const resultSet = await HealthDatabase.rdbStore!.query(predicates);
      if (resultSet.goToFirstRow()) {
        const data = new HealthData();
        data.sleep.deepSleep = resultSet.getDouble(resultSet.getColumnIndex('SLEEP_DEEP'));
        data.sleep.date = resultSet.getString(resultSet.getColumnIndex('SLEEP_DATE'));
        data.stress.value = resultSet.getLong(resultSet.getColumnIndex('STRESS_VALUE'));
        data.stress.date = resultSet.getString(resultSet.getColumnIndex('STRESS_DATE'));
        data.heart.heartRate = resultSet.getLong(resultSet.getColumnIndex('HEART_RATE'));
        data.heart.date = resultSet.getString(resultSet.getColumnIndex('HEART_DATE'));
        data.bloodPressure.systolic = resultSet.getLong(resultSet.getColumnIndex('BP_SYSTOLIC'));
        data.bloodPressure.diastolic = resultSet.getLong(resultSet.getColumnIndex('BP_DIASTOLIC'));
        data.bloodOxygen.spo2 = resultSet.getLong(resultSet.getColumnIndex('SPO2'));
        data.temperature.value = resultSet.getDouble(resultSet.getColumnIndex('TEMPERATURE'));
        resultSet.close();
        return data;
      }
      resultSet.close();
      return null;
    } catch (error) {
      console.error(`HealthDatabase: 查询健康数据失败 - ${JSON.stringify(error)}`);
      throw new Error(`查询健康数据失败: ${JSON.stringify(error)}`);
    }
  }

  static async clearAllData(): Promise<void> {
    if (!HealthDatabase.rdbStore) {
      await HealthDatabase.init();
    }

    const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(RDB_TABLE_NAME);
    try {
      await HealthDatabase.rdbStore!.delete(predicates);
      console.info('HealthDatabase: 清空数据成功');
    } catch (error) {
      console.error(`HealthDatabase: 清空数据失败 - ${JSON.stringify(error)}`);
      throw new Error(`清空数据库数据失败: ${JSON.stringify(error)}`);
    }
  }
}