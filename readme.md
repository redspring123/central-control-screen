# 华为中控屏项目实践

## 目前为空白项目

## 分工

- 策划一名
- 前端两名
- 后端两名
- 对接一名

## 文件目录框架

```text
central-control-screen/
├── commons/                     // [公共能力层] 存放基础公共代码，无业务属性
│   ├── uicomponents/            // 通用UI组件库，比如自定义的滚动条
│   └── utils/                   // 基础工具类 (如: LogUtil, DateUtil, HttpUtil)
│
├── features/                    // [特性业务层] 独立的业务模块，高内聚低耦合
│   ├── health/                  // [健康监测模块] 负责体征数据与运动管理
│   │   ├── src/main/ets/
│   │   │   ├── model/           // 数据模型 (如: HealthDataModel.ts - 定义心率/血压结构)
│   │   │   ├── viewmodel/       // 业务逻辑 (如: HealthViewModel.ts - 获取/处理健康数据)
│   │   │   └── pages/           // 页面组件 (如: WellnessPage.ets - 居家康养, SportsPage.ets - 运动健康)
│   │   └── index.ets            // 模块导出文件 (对外暴露 Page 和 Card 组件)
│   │
│   ├── medical/                 // [智慧医疗模块] 负责在线问诊与呼叫服务
│   │   ├── src/main/ets/
│   │   │   ├── model/           // 数据模型 (如: DoctorModel.ts - 医生信息结构)
│   │   │   ├── viewmodel/       // 业务逻辑 (如: DoctorViewModel.ts - 医生列表/呼叫状态管理)
│   │   │   └── pages/           // 页面组件 (如: CallPage.ets - 一键呼叫, ConsultationPage.ets - 在线问诊)
│   │   └── index.ets            // 模块导出文件
│   │
│   └── mainpage/                // [主页模块] 负责应用首页的布局与交互
│       ├── src/main/ets/
│       │   ├── viewmodel/       // HomeViewModel (负责聚合各模块入口数据)
│       │   └── pages/           // Index.ets (主页布局，引入其他 Feature 的 Card)
│       └── index.ets            // 模块导出文件
│
└── products/                    // [产品集成层] 应用入口，组装各个 Feature
    └── entry/                   // [Entry HAP] 默认产品入口
        ├── src/main/ets/
        │   ├── entryability/    // 应用生命周期入口 (EntryAbility.ts)
        │   ├── entrybackupability/ // 应用备份恢复逻辑
        │   └── pages/           // (入口页面，通常直接引用 mainpage 模块的 Index)
        └── oh-package.json5     // 依赖配置 (引入 commons, features/health, features/medical, features/mainpage)
```

## 开发注意事项

### 1. 模块导出 (index.ets)

在每个 Feature 模块的 `index.ets` 中，必须显式导出外部需要使用的组件或页面。

- **示例**：
  ```typescript
  // features/health/index.ets
  export { WellnessCard } from './src/main/ets/components/WellnessCard';
  export { WellnessPage } from './src/main/ets/pages/WellnessPage';
  ```

### 2. 资源引用 (Resources)

- **模块私有资源**：`features` 模块里的图片/字符串最好放在自己的 `src/main/resources` 下，保持模块独立性。
- **公共资源**：`commons` 里的通用图片（如返回图标、Logo）可以被所有模块引用。

### 3. 依赖配置 (oh-package.json5)

- **Entry 依赖**：记得在 `products/entry/oh-package.json5` 中添加对所有 `features` 模块的依赖。
- **Feature 依赖**：记得在各个 `features` 模块中添加对 `commons` 模块的依赖。

### 4. 团队协作与目录管理规范

为了避免多人开发时的冲突，请遵守以下约定：

- **严禁随意修改顶层目录**：`commons`, `features`, `products` 这三层结构是项目基石，未经全组讨论，**禁止**增加、删除或重命名这三层目录。
- **模块内部自治**：
  - 在各自负责的 `features` 模块内部（如 `features/health`），负责人可以自由新增文件夹（如 `components/charts`），但请保持 `model/view/viewmodel` 的分层习惯。
- **公共区修改慎重**：
  - **删除前检查**：在删除 `commons` 中的任何文件前，必须进行**全局搜索**，确保没有其他模块正在引用它。
  - **新增通用组件**：如果你写了一个组件觉得大家都能用，请先放在自己的模块里，确认通用性后再迁移到 `commons`，并通知所有人。
- **命名规范**：
  - **文件夹**：使用小驼峰命名 (camelCase)，如 `viewmodel`, `utils`。
  - **ETS组件/页面**：使用大驼峰命名 (PascalCase)，如 `WellnessCard.ets`, `Index.ets`。
  - **资源文件**：使用下划线命名 (snake_case)，如 `ic_back.png`, `bg_home.jpg`。
