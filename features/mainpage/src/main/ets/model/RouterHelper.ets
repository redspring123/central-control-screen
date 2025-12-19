import router from '@ohos.router';
import promptAction from '@ohos.promptAction';


import 'health';

export class RouterHelper {

  /**
   * 处理通用跳转逻辑
   * @param key 按钮或卡片的唯一标识符
   */
  static jump(key: string) {
    let params: Record<string, Object> = {};

    switch (key) {
      case 'card_health': // 居家康养

        router.pushNamedRoute({
          name: 'HealthWellnessPage',
          params: params
        }, router.RouterMode.Single, (err) => {
          if (err) {
            console.error(`跳转失败: ${err.code}, ${err.message}`);
            // 常见错误 100004: 说明 'HealthWellnessPage' 没找到，通常是因为顶部没写 import 'health'
            promptAction.showToast({ message: `跳转失败: ${err.message}` });
          }
        });
        return; // 必须 return，防止继续执行下面的逻辑

      case 'card_consult': // 在线咨询
        promptAction.showToast({ message: '正在前往在线问诊...' });
        return;

      case 'btn_sport_health': // 运动健康
        promptAction.showToast({ message: '正在前往运动健康...' });
        return;

      case 'btn_one_key_call': // 一键呼叫
        promptAction.showToast({ message: '正在呼叫管理中心...' });
        return;

      default:
      // 其他没有配置跳转的按钮
        return;
    }
  }
}