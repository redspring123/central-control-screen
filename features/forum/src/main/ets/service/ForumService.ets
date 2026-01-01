// 文件路径: features/forum/src/main/ets/service/ForumService.ets
import { http } from '@kit.NetworkKit';
import { request } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { ApiResponse } from '../model/ForumModel';

// 🔴 请再次确认这个 IP 是对的！
const BASE_URL = 'http://172.26.117.216:8000';

export class ForumService {

  // 通用请求核心
  private static async request<T>(url: string, method: http.RequestMethod, extraData?: Object): Promise<ApiResponse<T>> {
    const req = http.createHttp();
    let fullUrl = `${BASE_URL}${url}`;

    // 自动追加 user_id
    if (method === http.RequestMethod.GET && AppStorage.get('currentUserId')) {
      fullUrl += (url.includes('?') ? '&' : '?') + `user_id=${AppStorage.get('currentUserId')}`;
    }

    try {
      console.info(`[ForumService] Requesting: ${fullUrl}, Method: ${method}`); // 🔍 调试日志

      const result = await req.request(fullUrl, {
        method: method,
        header: { 'Content-Type': 'application/x-www-form-urlencoded' },
        extraData: extraData,
        expectDataType: http.HttpDataType.OBJECT
      });

      console.info(`[ForumService] Response Code: ${result.responseCode}`); // 🔍 调试日志

      if (result.responseCode !== 200) {
        return { success: false, message: `服务器错误: ${result.responseCode}` };
      }

      return result.result as ApiResponse<T>;
    } catch (e) {
      console.error(`[ForumService] Error: ${JSON.stringify(e)}`); // 🔍 关键报错信息
      return { success: false, message: '网络连接失败，请检查 IP' };
    } finally {
      req.destroy();
    }
  }

  // === 业务接口 ===
  static async getFeed(keyword: string = ""): Promise<ApiResponse<import('../model/ForumModel').ForumPost[]>> {
    return ForumService.request(`/api/feed?keyword=${keyword}`, http.RequestMethod.GET);
  }
  static async login(params: string): Promise<ApiResponse<import('../model/ForumModel').UserInfo>> {
    return ForumService.request('/api/login', http.RequestMethod.POST, params);
  }
  static async getPostDetail(postId: number): Promise<ApiResponse<import('../model/ForumModel').PostDetailData>> {
    return ForumService.request(`/api/post/${postId}`, http.RequestMethod.GET);
  }
  static async publish(params: string): Promise<ApiResponse<null>> {
    return ForumService.request('/api/publish', http.RequestMethod.POST, params);
  }
  static async getProfile(targetId: number): Promise<ApiResponse<import('../model/ForumModel').ProfileData>> {
    return ForumService.request(`/api/user/profile?target_id=${targetId}`, http.RequestMethod.GET);
  }
  static async likePost(postId: number, userId: number): Promise<ApiResponse<null>> {
    return ForumService.request('/api/like', http.RequestMethod.POST, `user_id=${userId}&post_id=${postId}`);
  }
  static async favPost(postId: number, userId: number): Promise<ApiResponse<null>> {
    return ForumService.request('/api/fav', http.RequestMethod.POST, `user_id=${userId}&post_id=${postId}`);
  }
  static async sendComment(userId: number, postId: number, content: string): Promise<ApiResponse<null>> {
    return ForumService.request('/api/comment', http.RequestMethod.POST, `user_id=${userId}&post_id=${postId}&content=${content}`);
  }
  static async updateProfile(params: string): Promise<ApiResponse<import('../model/ForumModel').UserInfo>> {
    return ForumService.request('/api/user/update', http.RequestMethod.POST, params);
  }

  // 图片上传
  static async uploadImage(context: common.UIAbilityContext, fileUri: string): Promise<string> {
    return new Promise((resolve, reject) => {
      let uploadConfig: request.UploadConfig = {
        url: `${BASE_URL}/api/upload`,
        header: { 'Content-Type': 'multipart/form-data' },
        method: 'POST',
        files: [{ filename: 'upload.jpg', name: 'file', uri: fileUri, type: 'jpg' }],
        data: []
      };
      request.uploadFile(context, uploadConfig).then((task) => {
        task.on('headerReceive', (headers) => {
          if (headers['img-url']) resolve(headers['img-url']);
        });
        task.on('fail', () => reject('上传任务失败'));
      }).catch((e: object) => reject(JSON.stringify(e)));
    });
  }
}