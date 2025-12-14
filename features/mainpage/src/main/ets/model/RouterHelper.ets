// src/main/ets/utils/RouterHelper.ts
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

export class RouterHelper {

  /**
   * 处理通用跳转逻辑
   * @param key 按钮或卡片的唯一标识符
   */
  static jump(key: string) {
    let targetUrl = '';
    let params: Record<string, Object> = {};

    switch (key) {
      case 'card_health': // 居家康养
        // 注意：这里需要填写你 features/health 模块中实际注册在 main_pages.json 的路径
        // 如果是跨模块引用，路径通常是 "pages/WellnessPage" 或 "@bundle:包名/模块名/ets/pages/WellnessPage"
        targetUrl = 'pages/WellnessPage';
        break;

      case 'card_consult': // 在线咨询
        // targetUrl = 'features/medical/pages/ConsultationPage'; // 示例
        promptAction.showToast({ message: '正在前往在线问诊...' });
        return;

      case 'btn_sport_health': // 运动健康 (左侧按钮)
        // targetUrl = 'pages/SportsPage'; // 示例
        promptAction.showToast({ message: '正在前往运动健康...' });
        return;

      case 'btn_one_key_call': // 一键呼叫 (左侧按钮)
        promptAction.showToast({ message: '正在呼叫管理中心...' });
        // 这里可以写拨号逻辑
        return;

      default:
      // 其他没有配置跳转的按钮
        return;
    }

    if (targetUrl) {
      router.pushUrl({
        url: targetUrl,
        params: params
      }, router.RouterMode.Single, (err) => {
        if (err) {
          console.error(`跳转失败: ${err.code}, ${err.message}`);
          promptAction.showToast({ message: `页面未找到或路径错误` });
        }
      });
    }
  }
}