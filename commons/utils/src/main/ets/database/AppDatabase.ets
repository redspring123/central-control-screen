import { relationalStore } from '@kit.ArkData';
import { Context } from '@kit.AbilityKit';

const DB_NAME = 'AppData.db';
const DDL: string[] = [
  // 1) 用户
  `CREATE TABLE IF NOT EXISTS user (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    account TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    name TEXT,
    phone TEXT,
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
  );`,
  `CREATE INDEX IF NOT EXISTS idx_user_account ON user(account);`,

  // 2) 用户画像
  `CREATE TABLE IF NOT EXISTS user_profile (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    age INTEGER,
    gender TEXT,
    height_cm REAL,
    weight_kg REAL,
    body_fat_pct REAL,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT,
    FOREIGN KEY(user_id) REFERENCES user(id) ON DELETE CASCADE
  );`,
  `CREATE INDEX IF NOT EXISTS idx_profile_user ON user_profile(user_id);`,

  // 3) 每日健康聚合 (融合原 HealthDatabase 字段命名)
  `CREATE TABLE IF NOT EXISTS health_daily (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    date TEXT NOT NULL,
    
    -- 运动数据 (Sports)
    steps_current INTEGER DEFAULT 0,
    steps_goal INTEGER DEFAULT 10000,
    steps_distance REAL DEFAULT 0,
    calories_current INTEGER DEFAULT 0,
    calories_goal INTEGER DEFAULT 1200,

    -- 健康数据 (Health)
    sleep_deep REAL DEFAULT 0,
    sleep_light REAL DEFAULT 0,
    sleep_total REAL DEFAULT 0,
    stress_value INTEGER DEFAULT 0,
    heart_rate INTEGER DEFAULT 0,
    bp_systolic INTEGER DEFAULT 0,
    bp_diastolic INTEGER DEFAULT 0,
    spo2 INTEGER DEFAULT 0,
    temperature REAL DEFAULT 0,

    updated_at TEXT NOT NULL DEFAULT (datetime('now')),
    UNIQUE(user_id, date),
    FOREIGN KEY(user_id) REFERENCES user(id) ON DELETE CASCADE
  );`,
  `CREATE INDEX IF NOT EXISTS idx_health_daily_user_date ON health_daily(user_id, date DESC);`,

  // 4) 健康测量明细
  `CREATE TABLE IF NOT EXISTS health_measurement (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    type TEXT NOT NULL,
    value1 REAL NOT NULL,
    value2 REAL,
    unit TEXT,
    measured_at TEXT NOT NULL,
    FOREIGN KEY(user_id) REFERENCES user(id) ON DELETE CASCADE
  );`,
  `CREATE INDEX IF NOT EXISTS idx_measure_user_type_time ON health_measurement(user_id, type, measured_at DESC);`,

  // 5) 房屋/环境数据
  `CREATE TABLE IF NOT EXISTS house_metrics (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    ts TEXT NOT NULL,
    energy_kwh REAL,
    net_up_mbps REAL,
    net_down_mbps REAL,
    light_lux REAL,
    co2_ppm REAL,
    updated_at TEXT,
    FOREIGN KEY(user_id) REFERENCES user(id) ON DELETE CASCADE
  );`,
  `CREATE INDEX IF NOT EXISTS idx_house_user_ts ON house_metrics(user_id, ts DESC);`,

  // 6) 健康宣讲内容
  `CREATE TABLE IF NOT EXISTS health_content (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    doc_url TEXT,
    tags TEXT,
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
  );`,

  // 7) 在线问诊医生
  `CREATE TABLE IF NOT EXISTS doctor (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    hospital TEXT,
    department TEXT,
    intro TEXT,
    priority_base REAL DEFAULT 0,
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
  );`,
  `CREATE INDEX IF NOT EXISTS idx_doctor_dept_priority ON doctor(department, priority_base DESC);`,

  // 8) 推荐日志/缓存
  `CREATE TABLE IF NOT EXISTS recommendation (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    target_type TEXT NOT NULL,
    target_id INTEGER NOT NULL,
    score REAL,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    FOREIGN KEY(user_id) REFERENCES user(id) ON DELETE CASCADE
  );`,
  `CREATE INDEX IF NOT EXISTS idx_reco_user_type_score ON recommendation(user_id, target_type, score DESC);`
];

export class AppDatabase {
  private static store: relationalStore.RdbStore | null = null;
  private static ctx: Context | null = null;

  static setContext(context: Context) {
    AppDatabase.ctx = context;
  }

  static async init(context?: Context): Promise<void> {
    if (AppDatabase.store) return;
    if (context) AppDatabase.setContext(context);
    if (!AppDatabase.ctx) {
      console.error('AppDatabase: context 未设置');
      return;
    }

    const config: relationalStore.StoreConfig = {
      name: DB_NAME,
      securityLevel: relationalStore.SecurityLevel.S1
    };

    try {
      AppDatabase.store = await relationalStore.getRdbStore(AppDatabase.ctx, config);
      // 逐条执行建表语句
      for (const sql of DDL) {
        await AppDatabase.store.executeSql(sql);
      }
      console.info('AppDatabase: 初始化成功');
    } catch (err) {
      console.error(`AppDatabase: 初始化失败 - ${JSON.stringify(err)}`);
    }
  }

  static getStore(): relationalStore.RdbStore {
    if (!AppDatabase.store) {
      throw new Error('AppDatabase 未初始化，请先调用 AppDatabase.init()');
    }
    return AppDatabase.store;
  }
}
