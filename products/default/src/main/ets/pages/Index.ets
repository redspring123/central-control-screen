import {MainPage} from 'mainpage'

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Column(){
      MainPage()
    }
    .backgroundColor($r('app.color.bg_page'))

  }
}