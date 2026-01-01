import http from '@ohos.net.http';

// 定义接口以满足 ArkTS 的类型检查要求
interface ChatMessage {
  role: string;
  content: string;
}

interface ChatRequest {
  model: string;
  messages: ChatMessage[];
}

interface ChatResponseChoice {
  message: ChatMessage;
}

interface ChatResponse {
  choices: ChatResponseChoice[];
}

export class AiService {
  // TODO: 请替换为你自己的阿里云百炼 API Key
  private static readonly API_KEY = 'sk-13e08fd722e645df8eb8c92d738455fc';
  // 阿里云百炼 OpenAI 兼容接口地址
  private static readonly API_URL = 'https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions';

  /**
   * 发送消息给 AI
   * @param userMessage 用户输入的话
   * @param systemPrompt 系统预设人设
   */
  static async chatWithAi(userMessage: string, systemPrompt: string = ''): Promise<string> {
    let httpRequest = http.createHttp();

    try {
      // 使用显式类型定义对象
      let messages: ChatMessage[] = [
        {
          role: "system",
          content: systemPrompt
        },
        {
          role: "user",
          content: userMessage
        }
      ];

      let requestBody: ChatRequest = {
        model: "qwen-turbo", // 使用通义千问-Turbo
        messages: messages
      };

      let response = await httpRequest.request(
        AiService.API_URL,
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${AiService.API_KEY}`
          },
          extraData: JSON.stringify(requestBody),
          readTimeout: 60000,
          connectTimeout: 60000
        }
      );

      if (response.responseCode === 200) {
        // 显式类型转换
        let result = JSON.parse(response.result.toString()) as ChatResponse;
        // 阿里云返回结构: { choices: [ { message: { content: "..." } } ] }
        if (result.choices && result.choices.length > 0 && result.choices[0].message) {
          return result.choices[0].message.content;
        }
      }
      console.error('AI API Error:', response.responseCode, response.result);
      return "抱歉，AI 服务暂时不可用。";

    } catch (error) {
      console.error('AI Request Failed:', JSON.stringify(error));
      return "网络连接失败，请检查网络。";
    } finally {
      httpRequest.destroy();
    }
  }
}
