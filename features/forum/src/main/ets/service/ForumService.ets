// 文件路径: features/forum/src/main/ets/service/ForumService.ets
import { http } from '@kit.NetworkKit';
import { request } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { ApiResponse } from '../model/ForumModel';

// 🔴 请再次确认这个 IP 是对的！
const BASE_URL = 'http://172.26.117.216:8000';

interface UploadData {
  url?: string;
}

interface UploadResponse {
  url?: string;
  img_url?: string;
  data?: UploadData;
}

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

  // 图片上传 (修复版：使用 http 替代 request.uploadFile 以获取响应体)
  static async uploadImage(context: common.UIAbilityContext, fileUri: string): Promise<string> {
    try {
      // 1. 处理路径: 将 internal://cache/ 转为绝对路径
      let realPath = fileUri;
      if (realPath.startsWith('internal://cache/')) {
        realPath = context.cacheDir + '/' + realPath.substring('internal://cache/'.length);
      }

      // 2. 读取文件
      const file = fs.openSync(realPath, fs.OpenMode.READ_ONLY);
      const stat = fs.statSync(realPath);
      const fileBuffer = new ArrayBuffer(stat.size);
      fs.readSync(file.fd, fileBuffer);
      fs.closeSync(file);

      // 3. 构建 Multipart 请求体
      const boundary = '----WebKitFormBoundary' + new Date().getTime();
      const req = http.createHttp();

      const headerStr = `--${boundary}\r\nContent-Disposition: form-data; name="file"; filename="upload.jpg"\r\nContent-Type: image/jpeg\r\n\r\n`;
      const footerStr = `\r\n--${boundary}--`;

      // 字符串转 Uint8Array 辅助函数
      const strToBuf = (s: string) => {
        const buf = new Uint8Array(s.length);
        for (let i = 0; i < s.length; i++) {
          buf[i] = s.charCodeAt(i);
        }
        return buf;
      };

      const headerArr = strToBuf(headerStr);
      const footerArr = strToBuf(footerStr);
      const fileArr = new Uint8Array(fileBuffer);

      const totalLen = headerArr.length + fileArr.length + footerArr.length;
      const fullBuf = new Uint8Array(totalLen);
      fullBuf.set(headerArr, 0);
      fullBuf.set(fileArr, headerArr.length);
      fullBuf.set(footerArr, headerArr.length + fileArr.length);

      // 4. 发送请求
      const result = await req.request(`${BASE_URL}/api/upload`, {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': `multipart/form-data; boundary=${boundary}`
        },
        extraData: fullBuf.buffer
      });

      // 5. 解析响应
      if (result.responseCode === 200) {
        const resStr = result.result ? result.result.toString() : '';
        console.info(`[ForumService] Upload Response Raw: ${resStr}`);

        // 1. 尝试 JSON 解析
        try {
          const resJson = JSON.parse(resStr) as UploadResponse;
          if (resJson.url) return resJson.url;
          if (resJson.data && resJson.data.url) return resJson.data.url;
          if (resJson.img_url) return resJson.img_url;
        } catch (e) {
          // 忽略 JSON 错误
        }

        // 2. 尝试直接使用字符串 (宽容模式)
        // 只要不是空的，且不包含错误信息，就认为是路径
        if (resStr && resStr.length > 0 && !resStr.includes('error') && !resStr.includes('Error')) {
          // 清理引号（有些后端直接返回带引号的字符串 "path"）
          let cleanStr = resStr.replace(/^"|"$/g, '').trim();
          // 如果返回的是纯文件名，尝试补全路径（假设后端存放在 uploads/ 下）
          if (!cleanStr.includes('/') && !cleanStr.startsWith('http')) {
             cleanStr = `/uploads/${cleanStr}`;
          }
          return cleanStr;
        }

        // 3. Header 兜底 (兼容旧逻辑)
        if (result.header) {
          // 查找 img-url (忽略大小写)
          const key = Object.keys(result.header).find(k => k.toLowerCase() === 'img-url');
          if (key) return result.header[key].toString();
        }
      } else {
        console.error(`[ForumService] Upload Failed Code: ${result.responseCode}`);
      }
    } catch (e) {
      console.error(`[ForumService] Upload Failed: ${JSON.stringify(e)}`);
    }
    return '';
  }
}