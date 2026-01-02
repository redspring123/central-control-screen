import { AppDatabase } from './AppDatabase';
import { User } from '../model/User';
import { relationalStore, ValuesBucket } from '@kit.ArkData';

export class UserDao {
  private static TABLE_NAME = 'user';

  static async getAllUsers(): Promise<User[]> {
    const store = AppDatabase.getStore();
    if (!store) return [];

    const resultSet = await store.querySql(`SELECT * FROM ${UserDao.TABLE_NAME}`);
    const list: User[] = [];
    while (resultSet.goToNextRow()) {
      list.push(UserDao.fromResultSet(resultSet));
    }
    resultSet.close();
    return list;
  }

  static async getUserById(id: number): Promise<User | null> {
    const store = AppDatabase.getStore();
    if (!store) return null;

    let predicates = new relationalStore.RdbPredicates(UserDao.TABLE_NAME);
    predicates.equalTo('id', id);
    const resultSet = await store.query(predicates);
    if (resultSet.goToNextRow()) {
      const user = UserDao.fromResultSet(resultSet);
      resultSet.close();
      return user;
    }
    resultSet.close();
    return null;
  }

  static async getUserByAccount(account: string): Promise<User | null> {
    const store = AppDatabase.getStore();
    if (!store) return null;

    let predicates = new relationalStore.RdbPredicates(UserDao.TABLE_NAME);
    predicates.equalTo('account', account);
    const resultSet = await store.query(predicates);
    if (resultSet.goToNextRow()) {
      const user = UserDao.fromResultSet(resultSet);
      resultSet.close();
      return user;
    }
    resultSet.close();
    return null;
  }

  static async addUser(user: User): Promise<number> {
    const store = AppDatabase.getStore();
    if (!store) return -1;

    const valueBucket: ValuesBucket = {
      account: user.account,
      password: user.password,
      name: user.name,
      phone: user.phone,
      isAdmin: user.isAdmin ? 1 : 0
    };

    return await store.insert(UserDao.TABLE_NAME, valueBucket);
  }

  static async updateUser(user: User): Promise<number> {
    const store = AppDatabase.getStore();
    if (!store) return -1;

    const valueBucket: ValuesBucket = {
      account: user.account,
      password: user.password,
      name: user.name,
      phone: user.phone,
      isAdmin: user.isAdmin ? 1 : 0
    };

    let predicates = new relationalStore.RdbPredicates(UserDao.TABLE_NAME);
    predicates.equalTo('id', user.id);

    return await store.update(valueBucket, predicates);
  }

  static async deleteUser(id: number): Promise<number> {
    const store = AppDatabase.getStore();
    if (!store) return -1;

    let predicates = new relationalStore.RdbPredicates(UserDao.TABLE_NAME);
    predicates.equalTo('id', id);

    return await store.delete(predicates);
  }

  private static fromResultSet(resultSet: relationalStore.ResultSet): User {
    const user = new User();
    user.id = resultSet.getLong(resultSet.getColumnIndex('id'));
    user.account = resultSet.getString(resultSet.getColumnIndex('account'));
    user.password = resultSet.getString(resultSet.getColumnIndex('password'));
    user.name = resultSet.getString(resultSet.getColumnIndex('name'));
    user.phone = resultSet.getString(resultSet.getColumnIndex('phone'));
    user.isAdmin = resultSet.getLong(resultSet.getColumnIndex('isAdmin')) === 1;
    user.created_at = resultSet.getString(resultSet.getColumnIndex('created_at'));
    return user;
  }
}
