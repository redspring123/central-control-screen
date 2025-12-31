import { LoginPage as AuthLoginView } from 'auth';

@Entry
@Component
struct LoginPage {
  build() {
    Column() {
      // 直接显示 auth 模块里的登录界面
      AuthLoginView()
    }
    .width('100%')
    .height('100%')
  }
}