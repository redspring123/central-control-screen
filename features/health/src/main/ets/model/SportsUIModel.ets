// features/health/src/main/ets/model/SportsUIModel.ets

export class HealthSportsUIModel {
  steps: StepsUIModel = new StepsUIModel();
  calories: CaloriesUIModel = new CaloriesUIModel();
  healthCards: HealthCardModel[] = [];
}

export class StepsUIModel {
  current: number = 0;
  goal: number = 10000;
  distance: number = 0;

  get progress(): number {
    return this.goal > 0 ? this.current / this.goal : 0;
  }
}

export class CaloriesUIModel {
  current: number = 0;
  goal: number = 1200;
  unit: string = '卡路里';

  get progress(): number {
    return this.goal > 0 ? this.current / this.goal : 0;
  }
}

export interface HealthCardConfig {
  id: string;
  icon: Resource;
  title: string;
  value: string;
  unit: string;
  date: string;
}

export class HealthCardModel {
  id: string = '';
  icon: Resource | undefined = undefined;
  title: string = '';
  value: string = '';
  unit: string = '';
  date: string = '';

  constructor(config: HealthCardConfig) {
    this.id = config.id;
    this.icon = config.icon;
    this.title = config.title;
    this.value = config.value;
    this.unit = config.unit;
    this.date = config.date;
  }
}