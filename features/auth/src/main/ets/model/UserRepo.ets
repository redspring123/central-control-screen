import { AppDatabase } from 'utils';
import { relationalStore, ValuesBucket } from '@kit.ArkData';

export interface UserInfo {
  id: number;
  account: string;
  name: string;
}

export class UserRepo {
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