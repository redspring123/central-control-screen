import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

/**
 * 导航逻辑管理器
 * 负责处理应用内的页面跳转和功能路由
 */
export class NavigationModel {

  /**
   * 返回上一页
   */
  static goBack() {
    router.back();
  }

  /**
   * 根据功能 Key 处理跳转逻辑
   * @param key 功能模块的唯一标识符
   */
  static handleJump(key: string) {
    let targetUrl = '';
    // 显式定义 params 类型，解决 Strict Mode 报错
    let params: Record<string, Object> = {};

    switch (key) {
      case 'btn_one_key_call': // 一键呼叫
        promptAction.showToast({ message: '正在呼叫管理中心...', duration: 2000 });
        // 在此处添加实际拨号逻辑
        return;

      case 'btn_sport_health': // 运动健康
        // targetUrl = 'pages/SportsPage';
        promptAction.showToast({ message: '正在前往运动健康...' });
        return;

      case 'card_consult': // 在线问诊
        // targetUrl = 'features/medical/pages/ConsultationPage';
        promptAction.showToast({ message: '正在前往在线问诊...' });
        return;

      default:
      // 未实现的功能
        promptAction.showToast({ message: '该功能模块正在开发中' });
        return;
    }
    if (targetUrl) {
      router.pushUrl({
        url: targetUrl,
        params: params
      }, router.RouterMode.Single, (err) => {
        if (err) {
          console.error(`Navigation failed: ${err.code} - ${err.message}`);
        }
      });
    }
  }
}