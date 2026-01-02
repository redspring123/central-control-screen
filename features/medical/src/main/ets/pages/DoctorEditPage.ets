import router from '@ohos.router';
import { Doctor } from '../model/DoctorModel';
import { DoctorDao } from '../database/DoctorDao';
import promptAction from '@ohos.promptAction';

@Entry({ routeName: 'DoctorEditPage' })
@Component
export struct DoctorEditPage {
  @State doctor: Doctor = new Doctor();
  @State isEdit: boolean = false;

  async aboutToAppear() {
    try {
      const params = router.getParams() as Record<string, Object>;
      console.info('DoctorEditPage params:', JSON.stringify(params));
      
      if (params && params['id']) {
        const id = params['id'] as number;
        const doc = await DoctorDao.getDoctorById(id);
        console.info('DoctorEditPage fetched doc:', JSON.stringify(doc));
        
        if (doc) {
          this.doctor = doc;
          this.isEdit = true;
        } else {
          promptAction.showToast({ message: '未找到该医生信息' });
        }
      }
    } catch (e) {
      console.error('DoctorEditPage error:', JSON.stringify(e));
    }
  }

  async handleSave() {
    if (!this.doctor.name || !this.doctor.hospital) {
      promptAction.showToast({ message: '姓名和医院不能为空' });
      return;
    }

    try {
      if (this.isEdit) {
        await DoctorDao.updateDoctor(this.doctor);
        promptAction.showToast({ message: '更新成功' });
      } else {
        await DoctorDao.addDoctor(this.doctor);
        promptAction.showToast({ message: '添加成功' });
      }
      router.back();
    } catch (e) {
      console.error('Save failed:', JSON.stringify(e));
      promptAction.showToast({ message: '保存失败' });
    }
  }

  async handleDelete() {
    try {
      await DoctorDao.deleteDoctor(this.doctor.id);
      promptAction.showToast({ message: '删除成功' });
      router.back();
    } catch (e) {
      console.error('Delete failed:', JSON.stringify(e));
      promptAction.showToast({ message: '删除失败' });
    }
  }

  build() {
    Column() {
      // 标题栏
      Row() {
        Image($r('app.media.icon_back'))
          .width(24).height(24)
          .onClick(() => router.back())
        Text(this.isEdit ? '编辑医生' : '添加医生')
          .fontSize(18).fontWeight(FontWeight.Bold)
          .margin({ left: 16 })
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#F1F3F5')

      Scroll() {
        Column({ space: 16 }) {
          // 姓名
          Row() {
            Text('姓名').width(80)
            TextInput({ text: this.doctor.name })
              .onChange((val) => this.doctor.name = val)
              .layoutWeight(1)
              .height(40)
              .backgroundColor(Color.White)
              .borderRadius(8)
          }.width('100%')

          // 职称
          Row() {
            Text('职称').width(80)
            TextInput({ text: this.doctor.title })
              .onChange((val) => this.doctor.title = val)
              .layoutWeight(1)
              .height(40)
              .backgroundColor(Color.White)
              .borderRadius(8)
          }.width('100%')

          // 医院
          Row() {
            Text('医院').width(80)
            TextInput({ text: this.doctor.hospital })
              .onChange((val) => this.doctor.hospital = val)
              .layoutWeight(1)
              .height(40)
              .backgroundColor(Color.White)
              .borderRadius(8)
          }.width('100%')

          // 科室
          Row() {
            Text('科室').width(80)
            TextInput({ text: this.doctor.department })
              .onChange((val) => this.doctor.department = val)
              .layoutWeight(1)
              .height(40)
              .backgroundColor(Color.White)
              .borderRadius(8)
          }.width('100%')

          // 擅长
          Row() {
            Text('擅长').width(80)
            TextInput({ text: this.doctor.specialty })
              .onChange((val) => this.doctor.specialty = val)
              .layoutWeight(1)
              .height(40)
              .backgroundColor(Color.White)
              .borderRadius(8)
          }.width('100%')

          // 简介
          Row() {
            Text('简介').width(80)
            TextInput({ text: this.doctor.intro })
              .onChange((val) => this.doctor.intro = val)
              .layoutWeight(1)
              .height(40)
              .backgroundColor(Color.White)
              .borderRadius(8)
          }.width('100%')
          
          // 费用
          Row() {
            Text('挂号费').width(80)
            TextInput({ text: this.doctor.fee.toString() })
              .type(InputType.Number)
              .onChange((val) => {
                this.doctor.fee = parseFloat(val) || 0;
              })
              .layoutWeight(1)
              .height(40)
              .backgroundColor(Color.White)
              .borderRadius(8)
          }.width('100%')

          Button('保存')
            .width('100%')
            .height(45)
            .type(ButtonType.Capsule)
            .onClick(() => this.handleSave())
            .margin({ top: 32 })

          if (this.isEdit) {
            Button('删除')
              .width('100%')
              .height(45)
              .type(ButtonType.Capsule)
              .backgroundColor(Color.Red)
              .onClick(() => this.handleDelete())
              .margin({ top: 16 })
          }
        }
        .padding(16)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
  }
}
