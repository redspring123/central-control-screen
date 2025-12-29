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
   * 获取家庭能耗数据 (模拟)
   */
  static getEnergyData(): EnergyData {
    return {
      power: parseFloat((Math.random() * 2 + 0.5).toFixed(2)), // 0.5 - 2.5 kW
      todayUsage: parseFloat((Math.random() * 5 + 2).toFixed(1)), // 2.0 - 7.0 kWh
      carbon: parseFloat((Math.random() * 1 + 0.2).toFixed(2))   // 0.2 - 1.2 kg
    };
  }

  /**
   * 获取家庭网络数据 (模拟)
   */
  static getNetworkData(): NetworkData {
    const down = Math.floor(Math.random() * 500 + 100); // 100 - 600 Mbps
    const up = Math.floor(down / 10);
    
    return {
      downloadSpeed: `${down} Mbps`,
      uploadSpeed: `${up} Mbps`,
      quality: down > 300 ? '优' : '良'
    };
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
