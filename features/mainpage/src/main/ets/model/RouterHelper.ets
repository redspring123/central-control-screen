import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import call from '@ohos.telephony.call';

import 'health';
import 'medical';

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
        return;

      case 'btn_sport_health': // 运动健康
        // 导航到 health 模块下的运动页（已在 SportsPage 中声明 routeName）
        try {
          router.pushNamedRoute({
            name: 'HealthSportsPage',
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
        return;

      case 'btn_one_key_call': // 一键呼叫
        try {
          promptAction.showDialog({
            title: '一键呼叫',
            message: '是否立即呼叫家庭医生？',
            buttons: [
              { text: '取消', color: '#8E8E93' },
              { text: '立即呼叫', color: '#FF3B30' }
            ]
          }, (err, data) => {
            if (err) {
              console.error('showDialog err: ' + err);
              return;
            }
            if (data.index === 1) {
              promptAction.showToast({ message: '正在呼叫家庭医生...', duration: 2000 });
              // 尝试使用系统拨号
              call.makeCall('13800000000', (err) => {
                if (err) {
                  console.error('makeCall fail, err: ' + JSON.stringify(err));
                  // 如果系统拨号失败（如无sim卡），则跳转到模拟页面
                  router.pushNamedRoute({
                    name: 'CallPage',
                    params: params
                  }, router.RouterMode.Single, (err) => {
                    if (err) {
                      console.error(`跳转失败: ${err.code}, ${err.message}`);
                      promptAction.showToast({ message: `跳转失败: ${err.message}` });
                    }
                  });
                }
              });
            }
          });
        } catch (error) {
          console.error('showDialog error: ' + error);
        }
        return;

      default:
      // 其他没有配置跳转的按钮
        return;
    }
  }
}