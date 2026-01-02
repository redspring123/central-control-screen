import { AppDatabase } from 'utils';
import { Doctor } from '../model/DoctorModel';
import { relationalStore, ValuesBucket } from '@kit.ArkData';

export class DoctorDao {
  private static TABLE_NAME = 'doctor';

  static async getDoctors(name: string = '', hospital: string = '', department: string = ''): Promise<Doctor[]> {
    const store = AppDatabase.getStore();
    if (!store) return [];

    let predicates = new relationalStore.RdbPredicates(DoctorDao.TABLE_NAME);
    
    if (name) {
      predicates.contains('name', name);
    }
    if (hospital) {
      predicates.contains('hospital', hospital);
    }
    if (department) {
      predicates.contains('department', department);
    }
    
    predicates.orderByDesc('priority_base');

    const resultSet = await store.query(predicates);
    const list: Doctor[] = [];
    while (resultSet.goToNextRow()) {
      const doc = new Doctor();
      doc.id = resultSet.getLong(resultSet.getColumnIndex('id'));
      doc.name = resultSet.getString(resultSet.getColumnIndex('name'));
      doc.title = resultSet.getString(resultSet.getColumnIndex('title')) || '';
      doc.hospital = resultSet.getString(resultSet.getColumnIndex('hospital')) || '';
      doc.department = resultSet.getString(resultSet.getColumnIndex('department')) || '';
      doc.specialty = resultSet.getString(resultSet.getColumnIndex('specialty')) || '';
      doc.fee = resultSet.getDouble(resultSet.getColumnIndex('fee')) || 0;
      doc.intro = resultSet.getString(resultSet.getColumnIndex('intro')) || '';
      doc.priority_base = resultSet.getDouble(resultSet.getColumnIndex('priority_base')) || 0;
      list.push(doc);
    }
    resultSet.close();
    return list;
  }

  static async getDoctorById(id: number): Promise<Doctor | null> {
    const store = AppDatabase.getStore();
    if (!store) return null;

    let predicates = new relationalStore.RdbPredicates(DoctorDao.TABLE_NAME);
    predicates.equalTo('id', id);

    const resultSet = await store.query(predicates);
    if (resultSet.goToFirstRow()) {
      const doc = new Doctor();
      doc.id = resultSet.getLong(resultSet.getColumnIndex('id'));
      doc.name = resultSet.getString(resultSet.getColumnIndex('name'));
      doc.title = resultSet.getString(resultSet.getColumnIndex('title')) || '';
      doc.hospital = resultSet.getString(resultSet.getColumnIndex('hospital')) || '';
      doc.department = resultSet.getString(resultSet.getColumnIndex('department')) || '';
      doc.specialty = resultSet.getString(resultSet.getColumnIndex('specialty')) || '';
      doc.fee = resultSet.getDouble(resultSet.getColumnIndex('fee')) || 0;
      doc.intro = resultSet.getString(resultSet.getColumnIndex('intro')) || '';
      doc.priority_base = resultSet.getDouble(resultSet.getColumnIndex('priority_base')) || 0;
      resultSet.close();
      return doc;
    }
    resultSet.close();
    return null;
  }

  static async addDoctor(doctor: Doctor): Promise<number> {
    const store = AppDatabase.getStore();
    if (!store) return -1;

    const valueBucket: ValuesBucket = {
      name: doctor.name,
      title: doctor.title,
      hospital: doctor.hospital,
      department: doctor.department,
      specialty: doctor.specialty,
      fee: doctor.fee,
      intro: doctor.intro,
      priority_base: doctor.priority_base
    };

    return await store.insert(DoctorDao.TABLE_NAME, valueBucket);
  }

  static async updateDoctor(doctor: Doctor): Promise<number> {
    const store = AppDatabase.getStore();
    if (!store) return -1;

    const valueBucket: ValuesBucket = {
      name: doctor.name,
      title: doctor.title,
      hospital: doctor.hospital,
      department: doctor.department,
      specialty: doctor.specialty,
      fee: doctor.fee,
      intro: doctor.intro,
      priority_base: doctor.priority_base
    };

    let predicates = new relationalStore.RdbPredicates(DoctorDao.TABLE_NAME);
    predicates.equalTo('id', doctor.id);

    return await store.update(valueBucket, predicates);
  }

  static async deleteDoctor(id: number): Promise<number> {
    const store = AppDatabase.getStore();
    if (!store) return -1;

    let predicates = new relationalStore.RdbPredicates(DoctorDao.TABLE_NAME);
    predicates.equalTo('id', id);

    return await store.delete(predicates);
  }

  static async initMockData() {
    const list = await DoctorDao.getDoctors();
    if (list.length > 0) return;

    const mockData: Doctor[] = [
      { id: 0, name: '张扬', title: '主任医生', hospital: '广东省第二人民医院', department: '神经内科', specialty: '心血管疾病、脑血管意外后遗症康复', fee: 50, intro: '', priority_base: 0 },
      { id: 0, name: '李子傲', title: '主任医生', hospital: '广东省第二人民医院', department: '神经内科', specialty: '高血压、失眠、焦虑症、头痛', fee: 50, intro: '', priority_base: 0 },
      { id: 0, name: '王康', title: '副主任医师', hospital: '中山一院', department: '骨科', specialty: '颈椎病、腰椎间盘突出、脊柱侧弯', fee: 60, intro: '', priority_base: 0 },
      { id: 0, name: '陈美', title: '主治医师', hospital: '市一医院', department: '皮肤科', specialty: '皮炎、湿疹、痤疮、过敏', fee: 30, intro: '', priority_base: 0 },
      { id: 0, name: '赵敏', title: '副主任医师', hospital: '广州市妇女儿童医疗中心', department: '妇科', specialty: '月经不调、妇科炎症、宫颈疾病、备孕指导', fee: 45, intro: '', priority_base: 0 },
      { id: 0, name: '钱伟', title: '主治医师', hospital: '广州市妇女儿童医疗中心', department: '儿科', specialty: '小儿感冒、发烧、咳嗽、消化不良、生长发育', fee: 35, intro: '', priority_base: 0 },
      { id: 0, name: '孙强', title: '主任医师', hospital: '中山大学中山眼科中心', department: '眼科', specialty: '近视矫正、白内障、青光眼、眼底病变', fee: 80, intro: '', priority_base: 0 },
      { id: 0, name: '周杰', title: '主治医师', hospital: '广东省口腔医院', department: '口腔科', specialty: '牙齿矫正、种植牙、智齿拔除、牙周治疗', fee: 40, intro: '', priority_base: 0 }
    ];

    for (const doc of mockData) {
      await DoctorDao.addDoctor(doc);
    }
  }
}
