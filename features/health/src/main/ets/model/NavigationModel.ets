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
        // 跳转到在线问诊页面
        try {
          router.pushNamedRoute({
            name: 'MedicalOnlineConsultPage',
            params: params
          }, router.RouterMode.Single, (err) => {
            if (err) {
              console.error(`跳转失败: ${err.code}, ${err.message}`);
              try { promptAction.showToast({ message: `跳转失败: ${err.message}` }); } catch (e) { console.error('showToast failed', e); }
            }
          });
        } catch (e) {
          console.error('router.pushNamedRoute threw', e);
          try { promptAction.showToast({ message: '跳转失败' }); } catch (err) { console.error('showToast failed', err); }
        }
        break;
      case 'btn_sport_health':
        // 从健康模块内部跳转到运动健康页（使用命名路由）
        try {
          router.pushNamedRoute({
            name: 'HealthSportsPage',
            params: params
          }, router.RouterMode.Single, (err) => {
            if (err) {
              console.error(`跳转失败: ${err.code}, ${err.message}`);
              try { promptAction.showToast({ message: `跳转失败(${err.code}): ${err.message}` }); } catch (e) { console.error('showToast failed', e); }
            }
          });
        } catch (e) {
          console.error('router.pushNamedRoute threw', e);
          try { promptAction.showToast({ message: '跳转失败' }); } catch (err) { console.error('showToast failed', err); }
        }
        break;
      // ... 其他 case 可以只写 break，默认不做反应或弹 "开发中"
      default:
        promptAction.showToast({ message: '功能开发中' });
        break;
    }

    // 如果有 url 则跳转
    if (targetUrl) {
      try {
        router.pushUrl({ url: targetUrl, params: params });
      } catch (e) {
        console.error('router.pushUrl threw', e);
        try { promptAction.showToast({ message: '跳转失败' }); } catch (err) { console.error('showToast failed', err); }
      }
    }
  }
}