// src/main/ets/model/NavigationModel.ts (确认这部分代码)
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

export class NavigationModel {
  static goBack() {
    router.back();
  }

  static handleJump(key: string) {
    let targetUrl = '';
    let params: Record<string, Object> = {};

    switch (key) {
      case 'btn_one_key_call':
        promptAction.showToast({ message: '正在呼叫管理中心...', duration: 2000 });
        break;
      case 'card_consult':
        promptAction.showToast({ message: '正在前往在线问诊...' });
        // targetUrl = 'pages/ConsultPage';
        break;
      case 'btn_sport_health':
        promptAction.showToast({ message: '正在前往运动健康...' });
        // targetUrl = 'pages/SportPage';
        break;
      // ... 其他 case 可以只写 break，默认不做反应或弹 "开发中"
      default:
        promptAction.showToast({ message: '功能开发中' });
        break;
    }

    // 如果有 url 则跳转
    if (targetUrl) {
      router.pushUrl({ url: targetUrl, params: params });
    }
  }
}