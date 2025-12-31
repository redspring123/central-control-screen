import { relationalStore } from '@kit.ArkData';
import { AppDatabase } from 'utils';

export interface EnergyData {
  power: number;      // 实时功率 (kW)
  todayUsage: number; // 今日用电 (kWh)
  carbon: number;     // 碳排 (kg)
}

export interface NetworkData {
  uploadSpeed: string;   // 上行速度
  downloadSpeed: string; // 下行速度
  quality: string;       // 网络质量
}

export interface WeatherData {
  tempC: number;
  condition: string;
  tip: string;
  icon: string;
  city: string;
}

export class HomeDataService {
  /**
   * 获取家庭能耗数据
   */
  static async getEnergyData(): Promise<EnergyData> {
    try {
      const store: relationalStore.RdbStore = AppDatabase.getStore();
      const predicates = new relationalStore.RdbPredicates('house_metrics');
      predicates.orderByDesc('ts');
      predicates.limitAs(1); // SQL: SELECT * FROM house_metrics ORDER BY ts DESC LIMIT 1
      
      const resultSet: relationalStore.ResultSet = await store.query(predicates);
      if (resultSet.goToFirstRow()) {
        const energy = resultSet.getDouble(resultSet.getColumnIndex('energy_kwh'));
        const co2 = resultSet.getDouble(resultSet.getColumnIndex('co2_ppm'));
        resultSet.close();
        
        return {
          power: parseFloat((Math.random() * 2 + 0.5).toFixed(2)), // 实时功率暂模拟
          todayUsage: parseFloat(energy.toFixed(1)),
          carbon: parseFloat((co2 / 1000).toFixed(2))
        };
      }
      resultSet.close();
    } catch (e) {
      console.warn('HomeDataService: 读取数据库失败，使用随机数据', e);
    }

    return {
      power: parseFloat((Math.random() * 2 + 0.5).toFixed(2)), // 0.5 - 2.5 kW
      todayUsage: parseFloat((Math.random() * 5 + 2).toFixed(1)), // 2.0 - 7.0 kWh
      carbon: parseFloat((Math.random() * 1 + 0.2).toFixed(2))   // 0.2 - 1.2 kg
    };
  }

  /**
   * 获取家庭网络数据
   */
  static async getNetworkData(): Promise<NetworkData> {
    try {
      const store = AppDatabase.getStore();
      const predicates = new relationalStore.RdbPredicates('house_metrics');
      predicates.orderByDesc('ts');
      predicates.limitAs(1);
      
      const resultSet = await store.query(predicates);
      if (resultSet.goToFirstRow()) {
        const down = resultSet.getDouble(resultSet.getColumnIndex('net_down_mbps'));
        const up = resultSet.getDouble(resultSet.getColumnIndex('net_up_mbps'));
        resultSet.close();
        
        return {
          downloadSpeed: `${down.toFixed(0)} Mbps`,
          uploadSpeed: `${up.toFixed(0)} Mbps`,
          quality: down > 300 ? '优' : '良'
        };
      }
      resultSet.close();
    } catch (e) {
      console.warn('HomeDataService: 读取网络数据失败', e);
    }

    const down = Math.floor(Math.random() * 500 + 100); // 100 - 600 Mbps
    const up = Math.floor(down / 10);
    
    return {
      downloadSpeed: `${down} Mbps`,
      uploadSpeed: `${up} Mbps`,
      quality: down > 300 ? '优' : '良'
    };
  }

  /**
   * 模拟插入一条新数据 (写库操作)
   */
  static async simulateData(): Promise<void> {
    try {
      const store: relationalStore.RdbStore = AppDatabase.getStore();
      
      // 读取上一条数据作为基准
      const lastEnergy = await HomeDataService.getEnergyData();
      const lastNet = await HomeDataService.getNetworkData(); // Note: this calls getStore again, fine.
      
      // 随机波动
      const newEnergy = lastEnergy.todayUsage + (Math.random() * 0.5);
      const newCo2 = (lastEnergy.carbon * 1000) + (Math.random() * 50);
      
      let newDown = parseFloat(lastNet.downloadSpeed) + (Math.random() * 50 - 25);
      if (newDown < 100) newDown = 100;
      const newUp = newDown / 10;

      const valueBucket: relationalStore.ValuesBucket = {
        user_id: 1,
        ts: new Date().getTime().toString(), // Use timestamp string
        energy_kwh: newEnergy,
        net_up_mbps: newUp,
        net_down_mbps: newDown,
        light_lux: 500, // default
        co2_ppm: newCo2,
        updated_at: new Date().toISOString()
      };

      // 插入一条新的历史记录，保留了历史轨迹
      await store.insert('house_metrics', valueBucket);
      console.info('HomeDataService: 模拟数据插入成功');

    } catch (error) {
      console.error('HomeDataService: 模拟数据插入失败', JSON.stringify(error));
    }
  }

  static getWeatherData(): WeatherData {
    const samples: WeatherData[] = [
      { tempC: 26, condition: '多云转晴', tip: '今日紫外线较强，出门请注意防晒。', icon: 'sun', city: '深圳' },
      { tempC: 18, condition: '小雨', tip: '出门记得带伞，注意防滑。', icon: 'rain', city: '深圳' },
      { tempC: 32, condition: '晴', tip: '天气炎热，补水降温。', icon: 'sun', city: '深圳' },
      { tempC: 5, condition: '阴', tip: '气温较低，注意保暖。', icon: 'cloud', city: '深圳' }
    ];
    const idx = Math.floor(Math.random() * samples.length);
    return samples[idx];
  }
}
