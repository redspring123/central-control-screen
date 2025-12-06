# 华为中控屏项目实践

## 目前为空白项目

## 分工

- 策划一名
- 前端两名
- 后端两名
- 对接一名

## 文件目录框架

```text
entry/src/main/ets/
├── common/                  // 公共资源
│   ├── constants/           // 常量定义 (如颜色、页面路径、枚举)
│   ├── images/              // 图片资源引用 (虽然主要在resources目录，这里可放路径变量)
│   └── utils/               // 工具类 (如时间格式化、日志打印)
├── model/                   // 数据模型 (TypeScript 接口/类)
│   ├── HealthDataModel.ets   // 定义心率、血压、睡眠等数据结构
│   ├── DoctorModel.ets       // 定义医生信息结构
│   └── CardInfoModel.ets     // 定义首页卡片的数据结构
├── viewmodel/               // 视图模型 (负责获取数据，模拟API)
│   ├── HomeViewModel.ets     // 首页数据逻辑
│   └── HealthViewModel.ets   // 健康页面数据逻辑 (这里写 Mock 数据)
├── pages/                   // 页面级组件 (Page) - 对应 Router 路径
│   ├── Index.ets             // 1. 中控屏主界面 (S2 主界面)
│   ├── WellnessPage.ets     // 2. 居家康养主页 (点击卡片1跳转)
│   ├── CallPage.ets         // 3. 一键呼叫界面 (点击卡片2跳转)
│   ├── ConsultationPage.ets // 4. 在线问诊列表页 (点击卡片3跳转)
│   └── SportsPage.ets       // 5. 运动健康详情页 (点击卡片4跳转)
├── view/                    // 可复用的 UI 组件 (Component)
│   ├── dashboard/           // 首页相关的组件
│   │   ├── WellnessCard.ets // 居家康养卡片组件
│   │   ├── CallCard.ets     // 一键呼叫卡片组件
│   │   ├── ConsultCard.ets  // 在线问诊卡片组件
│   │   └── SportsCard.ets   // 运动健康卡片组件
│   └── common/              // 通用组件
│       ├── TitleBar.ets     // 统一的标题栏
│       └── DataChart.ets    // 简单的数据图表组件
└── entryability/            // 程序的入口 Ability
```
