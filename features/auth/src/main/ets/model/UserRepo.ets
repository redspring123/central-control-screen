import { AppDatabase } from 'utils';
import { relationalStore, ValuesBucket } from '@kit.ArkData';

export interface UserInfo {
  id: number;
  account: string;
  name: string;
}

export interface UserProfile {
  userId: number;
  name: string;
  phone: string;
  height: number;
  weight: number;
  age: number;
  gender: string;
}

export class UserRepo {
  // 获取用户详细信息 (User + Profile)
  static async getUserProfile(userId: number): Promise<UserProfile> {
    const store = AppDatabase.getStore();
    
    // 1. 查询 User 表
    let userPredicates = new relationalStore.RdbPredicates('user');
    userPredicates.equalTo('id', userId);
    let userRs = await store.query(userPredicates);
    
    let name = '';
    let phone = '';
    
    if (userRs.rowCount > 0) {
      userRs.goToFirstRow();
      name = userRs.getString(userRs.getColumnIndex('name')) || '';
      phone = userRs.getString(userRs.getColumnIndex('phone')) || '';
    }
    userRs.close();

    // 2. 查询 Profile 表
    let profilePredicates = new relationalStore.RdbPredicates('user_profile');
    profilePredicates.equalTo('user_id', userId);
    let profileRs = await store.query(profilePredicates);
    
    let height = 0;
    let weight = 0;
    let age = 0;
    let gender = '未知';
    
    if (profileRs.rowCount > 0) {
      profileRs.goToFirstRow();
      height = profileRs.getDouble(profileRs.getColumnIndex('height_cm')) || 0;
      weight = profileRs.getDouble(profileRs.getColumnIndex('weight_kg')) || 0;
      age = profileRs.getLong(profileRs.getColumnIndex('age')) || 0;
      gender = profileRs.getString(profileRs.getColumnIndex('gender')) || '未知';
    }
    profileRs.close();

    return {
      userId,
      name,
      phone,
      height,
      weight,
      age,
      gender
    };
  }

  // 更新用户信息
  static async updateUserProfile(profile: UserProfile): Promise<boolean> {
    const store = AppDatabase.getStore();
    
    try {
      // 1. 更新 User 表
      const userValues: ValuesBucket = {
        'name': profile.name,
        'phone': profile.phone
      };
      let userPredicates = new relationalStore.RdbPredicates('user');
      userPredicates.equalTo('id', profile.userId);
      await store.update(userValues, userPredicates);

      // 2. 更新或插入 Profile 表
      // 先检查是否存在
      let profilePredicates = new relationalStore.RdbPredicates('user_profile');
      profilePredicates.equalTo('user_id', profile.userId);
      let rs = await store.query(profilePredicates);
      
      const profileValues: ValuesBucket = {
        'height_cm': profile.height,
        'weight_kg': profile.weight,
        'age': profile.age,
        'gender': profile.gender,
        'updated_at': new Date().toISOString()
      };

      if (rs.rowCount > 0) {
        // 更新
        await store.update(profileValues, profilePredicates);
      } else {
        // 插入
        profileValues['user_id'] = profile.userId;
        await store.insert('user_profile', profileValues);
      }
      rs.close();
      
      return true;
    } catch (e) {
      console.error('Update profile failed:', e);
      return false;
    }
  }

  // 注册
  static async register(account: string, password: string): Promise<boolean> {
    const store = AppDatabase.getStore();
    // 1. 查重
    let predicates = new relationalStore.RdbPredicates('user');
    predicates.equalTo('account', account);
    let resultSet = await store.query(predicates);
    if (resultSet.rowCount > 0) {
      resultSet.close();
      return false;
    }
    resultSet.close();

    // 2. 插入
    const valueBucket: ValuesBucket = {
      'account': account,
      'password': password,
      'name': '用户' + Math.floor(Math.random() * 1000)
    };
    await store.insert('user', valueBucket);
    return true;
  }

  // 登录
  static async login(account: string, password: string): Promise<UserInfo | null> {
    const store = AppDatabase.getStore();
    let predicates = new relationalStore.RdbPredicates('user');
    predicates.equalTo('account', account);
    predicates.equalTo('password', password);

    let resultSet = await store.query(predicates);
    let result: UserInfo | null = null;

    if (resultSet.rowCount > 0) {
      resultSet.goToFirstRow();
      result = {
        id: resultSet.getLong(resultSet.getColumnIndex('id')),
        account: resultSet.getString(resultSet.getColumnIndex('account')),
        name: resultSet.getString(resultSet.getColumnIndex('name'))
      };
    }
    resultSet.close();
    return result;
  }
}