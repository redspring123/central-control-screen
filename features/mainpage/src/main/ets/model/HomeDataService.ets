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
}
