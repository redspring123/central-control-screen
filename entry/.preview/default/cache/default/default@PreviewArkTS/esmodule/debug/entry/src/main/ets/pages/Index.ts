if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface MainPage_Params {
    showHome?: boolean;
    showScene?: boolean;
    sceneList?: btn[];
}
import type { btn } from '../model/btn';
class MainPage extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__showHome = new ObservedPropertySimplePU(true, this, "showHome");
        this.__showScene = new ObservedPropertySimplePU(false, this, "showScene");
        this.sceneList = [
            { key: 'btn_warm_home', icon: 'temp_home' },
            { key: 'btn_safe_leave', icon: 'temp_home' },
            { key: 'btn_full_temp', icon: 'full_temp' },
            { key: 'btn_dehumidify', icon: 'dehumidify' },
            { key: 'btn_ventilation', icon: 'ventilation' },
            { key: 'btn_more_scenes', icon: 'foreground' },
            { key: 'btn_one_key_call', icon: 'ventilation' },
            { key: 'btn_sport_health', icon: 'foreground' }
        ];
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: MainPage_Params) {
        if (params.showHome !== undefined) {
            this.showHome = params.showHome;
        }
        if (params.showScene !== undefined) {
            this.showScene = params.showScene;
        }
        if (params.sceneList !== undefined) {
            this.sceneList = params.sceneList;
        }
    }
    updateStateVars(params: MainPage_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__showHome.purgeDependencyOnElmtId(rmElmtId);
        this.__showScene.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__showHome.aboutToBeDeleted();
        this.__showScene.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __showHome: ObservedPropertySimplePU<boolean>;
    get showHome() {
        return this.__showHome.get();
    }
    set showHome(newValue: boolean) {
        this.__showHome.set(newValue);
    }
    private __showScene: ObservedPropertySimplePU<boolean>;
    get showScene() {
        return this.__showScene.get();
    }
    set showScene(newValue: boolean) {
        this.__showScene.set(newValue);
    }
    private sceneList: btn[];
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Index.ets(23:5)", "entry");
            Column.width('100%');
            Column.height('100%');
            Column.backgroundColor({ "id": 16777268, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Column.backgroundImage({ "id": 16777302, "type": 20000, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Column.backgroundImageSize(ImageSize.Cover);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 1. 顶部导航栏 (保持原样)
            Row.create({ space: { "id": 16777296, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" } });
            Row.debugLine("entry/src/main/ets/pages/Index.ets(25:7)", "entry");
            // 1. 顶部导航栏 (保持原样)
            Row.backgroundColor({ "id": 16777268, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            // 1. 顶部导航栏 (保持原样)
            Row.padding({ "id": 16777291, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            // 1. 顶部导航栏 (保持原样)
            Row.width('100%');
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create({ "id": 16777263, "type": 10003, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.debugLine("entry/src/main/ets/pages/Index.ets(26:9)", "entry");
            Text.fontSize({ "id": 16777281, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.fontWeight(FontWeight.Bold);
            Text.fontColor({ "id": 16777276, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777266, "type": 20000, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/pages/Index.ets(31:9)", "entry");
            Image.width({ "id": 16777286, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Image.height({ "id": 16777286, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Image.margin({ "id": 16777291, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Image.opacity(this.showHome ? 1 : 0.5);
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777229, "type": 20000, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/pages/Index.ets(37:9)", "entry");
            Image.width({ "id": 16777286, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Image.height({ "id": 16777286, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Image.margin({ "id": 16777291, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Image.opacity(this.showScene ? 1 : 0.5);
        }, Image);
        // 1. 顶部导航栏 (保持原样)
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 2. 内容区域：使用 Row 实现三列布局
            // 采用 Grid 实现左侧场景的 2x4 排列
            Row.create({ space: { "id": 16777297, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" } });
            Row.debugLine("entry/src/main/ets/pages/Index.ets(50:7)", "entry");
            // 2. 内容区域：使用 Row 实现三列布局
            // 采用 Grid 实现左侧场景的 2x4 排列
            Row.width('100%');
            // 2. 内容区域：使用 Row 实现三列布局
            // 采用 Grid 实现左侧场景的 2x4 排列
            Row.layoutWeight(1);
            // 2. 内容区域：使用 Row 实现三列布局
            // 采用 Grid 实现左侧场景的 2x4 排列
            Row.padding({ "id": 16777291, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // --- A. 左侧：8个场景按钮 (2列 x 4行)
            Grid.create();
            Grid.debugLine("entry/src/main/ets/pages/Index.ets(53:9)", "entry");
            // --- A. 左侧：8个场景按钮 (2列 x 4行)
            Grid.columnsTemplate('1fr 1fr');
            // --- A. 左侧：8个场景按钮 (2列 x 4行)
            Grid.columnsGap({ "id": 16777291, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            // --- A. 左侧：8个场景按钮 (2列 x 4行)
            Grid.rowsGap({ "id": 16777291, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            // --- A. 左侧：8个场景按钮 (2列 x 4行)
            Grid.layoutWeight(1.2);
        }, Grid);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            ForEach.create();
            const forEachItemGenFunction = _item => {
                const item = _item;
                {
                    const itemCreation2 = (elmtId, isInitialRender) => {
                        GridItem.create(() => { }, false);
                        GridItem.margin({ "id": 16777291, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
                        GridItem.debugLine("entry/src/main/ets/pages/Index.ets(55:13)", "entry");
                    };
                    const observedDeepRender = () => {
                        this.observeComponentCreation2(itemCreation2, GridItem);
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            Button.createWithChild();
                            Button.debugLine("entry/src/main/ets/pages/Index.ets(56:15)", "entry");
                            Button.backgroundColor({ "id": 16777267, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
                            Button.borderRadius({ "id": 16777294, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
                            Button.width(120);
                            Button.height({ "id": 16777280, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
                        }, Button);
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            Row.create({ space: { "id": 16777295, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" } });
                            Row.debugLine("entry/src/main/ets/pages/Index.ets(57:17)", "entry");
                            Row.width('100%');
                            Row.alignItems(VerticalAlign.Center);
                            Row.justifyContent(FlexAlign.SpaceAround);
                        }, Row);
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            Column.create();
                            Column.debugLine("entry/src/main/ets/pages/Index.ets(58:19)", "entry");
                            Column.width('30%');
                        }, Column);
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            Image.create({ "id": -1, "type": -1, params: [`app.media.${item.icon}`], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
                            Image.debugLine("entry/src/main/ets/pages/Index.ets(60:21)", "entry");
                            Image.width({ "id": 16777286, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
                            Image.height({ "id": 16777286, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
                        }, Image);
                        Column.pop();
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            Column.create();
                            Column.debugLine("entry/src/main/ets/pages/Index.ets(65:19)", "entry");
                            Column.width('50%');
                        }, Column);
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            Text.create({ "id": -1, "type": -1, params: [`app.string.${item.key}`], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
                            Text.debugLine("entry/src/main/ets/pages/Index.ets(67:21)", "entry");
                            Text.fontSize({ "id": 16777282, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
                            Text.fontColor({ "id": 16777276, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
                        }, Text);
                        Text.pop();
                        Column.pop();
                        Row.pop();
                        Button.pop();
                        GridItem.pop();
                    };
                    observedDeepRender();
                }
            };
            this.forEachUpdateFunction(elmtId, this.sceneList, forEachItemGenFunction, (item: btn) => item.key, false, false);
        }, ForEach);
        ForEach.pop();
        // --- A. 左侧：8个场景按钮 (2列 x 4行)
        Grid.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // --- B. 中间 + 右侧：卡片区域 (使用 Row 包裹两个 Column，实现剩下的两列)
            Row.create({ space: { "id": 16777297, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" } });
            Row.debugLine("entry/src/main/ets/pages/Index.ets(94:9)", "entry");
            // --- B. 中间 + 右侧：卡片区域 (使用 Row 包裹两个 Column，实现剩下的两列)
            Row.layoutWeight(3);
            // --- B. 中间 + 右侧：卡片区域 (使用 Row 包裹两个 Column，实现剩下的两列)
            Row.height('100%');
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // --- B1. 中间列：家庭能耗 + 家庭安防 + 在线问诊 (内容已完整补充)
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Index.ets(97:11)", "entry");
            // --- B1. 中间列：家庭能耗 + 家庭安防 + 在线问诊 (内容已完整补充)
            Column.layoutWeight(1.5);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 家庭能耗
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Index.ets(99:13)", "entry");
            // 家庭能耗
            Column.backgroundColor({ "id": 16777267, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            // 家庭能耗
            Column.borderRadius({ "id": 16777294, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            // 家庭能耗
            Column.margin({ "id": 16777291, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            // 家庭能耗
            Column.padding({ "id": 16777290, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            // 家庭能耗
            Column.width('100%');
            // 家庭能耗
            Column.layoutWeight(1);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create({ "id": 16777249, "type": 10003, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.debugLine("entry/src/main/ets/pages/Index.ets(100:15)", "entry");
            Text.fontSize({ "id": 16777282, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.fontWeight(FontWeight.Bold);
            Text.fontColor({ "id": 16777276, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create({ "id": 16777248, "type": 10003, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.debugLine("entry/src/main/ets/pages/Index.ets(104:15)", "entry");
            Text.fontSize({ "id": 16777284, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.fontWeight(FontWeight.Bold);
            Text.fontColor({ "id": 16777276, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create({ "id": 16777250, "type": 10003, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.debugLine("entry/src/main/ets/pages/Index.ets(108:15)", "entry");
            Text.fontSize({ "id": 16777283, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.fontColor({ "id": 16777273, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create({ "id": 16777247, "type": 10003, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.debugLine("entry/src/main/ets/pages/Index.ets(111:15)", "entry");
            Text.fontSize({ "id": 16777283, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.fontColor({ "id": 16777273, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.margin({ top: { "id": 16777292, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" } });
        }, Text);
        Text.pop();
        // 家庭能耗
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 家庭安防
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Index.ets(124:13)", "entry");
            // 家庭安防
            Column.backgroundColor({ "id": 16777267, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            // 家庭安防
            Column.borderRadius({ "id": 16777294, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            // 家庭安防
            Column.margin({ "id": 16777291, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            // 家庭安防
            Column.padding({ "id": 16777290, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            // 家庭安防
            Column.width('100%');
            // 家庭安防
            Column.layoutWeight(1);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create({ "id": 16777260, "type": 10003, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.debugLine("entry/src/main/ets/pages/Index.ets(125:15)", "entry");
            Text.fontSize({ "id": 16777282, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.fontWeight(FontWeight.Bold);
            Text.fontColor({ "id": 16777276, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create({ "id": 16777259, "type": 10003, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.debugLine("entry/src/main/ets/pages/Index.ets(129:15)", "entry");
            Text.fontSize({ "id": 16777284, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.fontWeight(FontWeight.Bold);
            Text.fontColor({ "id": 16777275, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create({ "id": 16777258, "type": 10003, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.debugLine("entry/src/main/ets/pages/Index.ets(133:15)", "entry");
            Text.fontSize({ "id": 16777283, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.fontColor({ "id": 16777273, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.margin({ top: { "id": 16777292, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" } });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create({ space: { "id": 16777295, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" } });
            Row.debugLine("entry/src/main/ets/pages/Index.ets(138:15)", "entry");
            Row.justifyContent(FlexAlign.Center);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithChild();
            Button.debugLine("entry/src/main/ets/pages/Index.ets(139:17)", "entry");
            Button.backgroundColor({ "id": 16777270, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Button.borderRadius({ "id": 16777294, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Button.margin({ "id": 16777292, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
        }, Button);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777227, "type": 20000, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/pages/Index.ets(140:19)", "entry");
            Image.width({ "id": 16777287, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Image.height({ "id": 16777287, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
        }, Image);
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithChild();
            Button.debugLine("entry/src/main/ets/pages/Index.ets(148:17)", "entry");
            Button.backgroundColor({ "id": 16777271, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Button.borderRadius({ "id": 16777294, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Button.margin({ "id": 16777292, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
        }, Button);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777278, "type": 20000, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/pages/Index.ets(149:19)", "entry");
            Image.width({ "id": 16777287, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Image.height({ "id": 16777287, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
        }, Image);
        Button.pop();
        Row.pop();
        // 家庭安防
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 在线问诊
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Index.ets(167:13)", "entry");
            // 在线问诊
            Column.backgroundColor({ "id": 16777267, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            // 在线问诊
            Column.borderRadius({ "id": 16777294, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            // 在线问诊
            Column.margin({ "id": 16777291, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            // 在线问诊
            Column.padding({ "id": 16777290, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            // 在线问诊
            Column.width('100%');
            // 在线问诊
            Column.layoutWeight(1);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithChild();
            Button.debugLine("entry/src/main/ets/pages/Index.ets(168:15)", "entry");
            Button.backgroundColor({ "id": 16777267, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Button.width('100%');
            Button.height('100%');
        }, Button);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/pages/Index.ets(169:17)", "entry");
            Row.justifyContent(FlexAlign.SpaceBetween);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Index.ets(171:19)", "entry");
            Column.width('60%');
            Column.justifyContent(FlexAlign.SpaceBetween);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create({ "id": 16777246, "type": 10003, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.debugLine("entry/src/main/ets/pages/Index.ets(172:21)", "entry");
            Text.fontSize({ "id": 16777282, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.fontWeight(FontWeight.Bold);
            Text.fontColor({ "id": 16777276, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create({ "id": 16777245, "type": 10003, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.debugLine("entry/src/main/ets/pages/Index.ets(176:21)", "entry");
            Text.fontSize({ "id": 16777283, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.fontColor({ "id": 16777273, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.margin({ top: { "id": 16777292, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" } });
        }, Text);
        Text.pop();
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777222, "type": 20000, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/pages/Index.ets(184:19)", "entry");
            Image.width({ "id": 16777285, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Image.height({ "id": 16777285, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
        }, Image);
        Row.pop();
        Button.pop();
        // 在线问诊
        Column.pop();
        // --- B1. 中间列：家庭能耗 + 家庭安防 + 在线问诊 (内容已完整补充)
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // --- B2. 右侧列：居家康养 + 家庭网络 + 可视对讲 (内容已完整补充)
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Index.ets(205:11)", "entry");
            // --- B2. 右侧列：居家康养 + 家庭网络 + 可视对讲 (内容已完整补充)
            Column.layoutWeight(1.5);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 居家康养
            Row.create();
            Row.debugLine("entry/src/main/ets/pages/Index.ets(207:13)", "entry");
            // 居家康养
            Row.backgroundColor({ "id": 16777267, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            // 居家康养
            Row.borderRadius({ "id": 16777294, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            // 居家康养
            Row.margin({ "id": 16777291, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            // 居家康养
            Row.padding({ "id": 16777290, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            // 居家康养
            Row.width('100%');
            // 居家康养
            Row.layoutWeight(1);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithChild();
            Button.debugLine("entry/src/main/ets/pages/Index.ets(208:15)", "entry");
            Button.backgroundColor({ "id": 16777267, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
        }, Button);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/pages/Index.ets(210:17)", "entry");
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Index.ets(212:19)", "entry");
            Column.backgroundColor({ "id": 16777267, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Column.borderRadius({ "id": 16777294, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Column.margin({ "id": 16777291, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Column.padding({ "id": 16777290, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Column.width('100%');
            Column.layoutWeight(1);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create({ "id": 16777252, "type": 10003, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.debugLine("entry/src/main/ets/pages/Index.ets(214:21)", "entry");
            Text.fontSize({ "id": 16777282, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.fontWeight(FontWeight.Bold);
            Text.fontColor({ "id": 16777276, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create({ "id": 16777251, "type": 10003, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.debugLine("entry/src/main/ets/pages/Index.ets(218:21)", "entry");
            Text.fontSize({ "id": 16777281, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.fontWeight(FontWeight.Bold);
            Text.fontColor({ "id": 16777276, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create({ "id": 16777253, "type": 10003, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.debugLine("entry/src/main/ets/pages/Index.ets(222:21)", "entry");
            Text.fontSize({ "id": 16777283, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.fontColor({ "id": 16777273, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.margin({ top: { "id": 16777292, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" } });
        }, Text);
        Text.pop();
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777264, "type": 20000, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/pages/Index.ets(234:19)", "entry");
            Image.width({ "id": 16777288, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Image.height({ "id": 16777288, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Image.borderRadius({ "id": 16777294, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Image.margin({ top: { "id": 16777291, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" } });
            Image.layoutWeight(1);
        }, Image);
        Row.pop();
        Button.pop();
        // 居家康养
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 家庭网络
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Index.ets(253:13)", "entry");
            // 家庭网络
            Column.backgroundColor({ "id": 16777267, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            // 家庭网络
            Column.borderRadius({ "id": 16777294, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            // 家庭网络
            Column.margin({ "id": 16777291, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            // 家庭网络
            Column.padding({ "id": 16777290, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            // 家庭网络
            Column.width('100%');
            // 家庭网络
            Column.layoutWeight(1);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithChild();
            Button.debugLine("entry/src/main/ets/pages/Index.ets(254:15)", "entry");
            Button.width('100%');
            Button.height('100%');
            Button.backgroundColor({ "id": 16777267, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
        }, Button);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/pages/Index.ets(256:17)", "entry");
            Row.width('90%');
            Row.justifyContent(FlexAlign.SpaceBetween);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Index.ets(258:19)", "entry");
            Column.width('50%');
            Column.justifyContent(FlexAlign.SpaceBetween);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create({ "id": 16777257, "type": 10003, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.debugLine("entry/src/main/ets/pages/Index.ets(260:21)", "entry");
            Text.fontSize({ "id": 16777282, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.fontWeight(FontWeight.Bold);
            Text.fontColor({ "id": 16777276, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create({ "id": 16777255, "type": 10003, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.debugLine("entry/src/main/ets/pages/Index.ets(264:21)", "entry");
            Text.fontSize({ "id": 16777281, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.fontWeight(FontWeight.Bold);
            Text.fontColor({ "id": 16777276, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create({ "id": 16777256, "type": 10003, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.debugLine("entry/src/main/ets/pages/Index.ets(268:21)", "entry");
            Text.fontSize({ "id": 16777283, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.fontColor({ "id": 16777273, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create({ "id": 16777301, "type": 10003, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.debugLine("entry/src/main/ets/pages/Index.ets(271:21)", "entry");
            Text.fontSize({ "id": 16777283, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.fontColor({ "id": 16777273, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.margin({ top: { "id": 16777292, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" } });
        }, Text);
        Text.pop();
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777220, "type": 20000, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/pages/Index.ets(280:19)", "entry");
            Image.width({ "id": 16777285, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Image.height({ "id": 16777285, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
        }, Image);
        Row.pop();
        Button.pop();
        // 家庭网络
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 可视对讲
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/Index.ets(302:13)", "entry");
            // 可视对讲
            Column.backgroundColor({ "id": 16777267, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            // 可视对讲
            Column.borderRadius({ "id": 16777294, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            // 可视对讲
            Column.margin({ "id": 16777291, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            // 可视对讲
            Column.padding({ "id": 16777290, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            // 可视对讲
            Column.width('100%');
            // 可视对讲
            Column.layoutWeight(1);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create({ "id": 16777254, "type": 10003, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.debugLine("entry/src/main/ets/pages/Index.ets(303:15)", "entry");
            Text.fontSize({ "id": 16777282, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Text.fontWeight(FontWeight.Bold);
            Text.fontColor({ "id": 16777276, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create({ space: { "id": 16777295, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" } });
            Row.debugLine("entry/src/main/ets/pages/Index.ets(308:15)", "entry");
            Row.justifyContent(FlexAlign.Center);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithChild();
            Button.debugLine("entry/src/main/ets/pages/Index.ets(309:17)", "entry");
            Button.backgroundColor({ "id": 16777267, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Button.borderRadius({ "id": 16777294, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Button.margin({ "id": 16777292, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
        }, Button);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777225, "type": 20000, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/pages/Index.ets(310:19)", "entry");
            Image.width({ "id": 16777286, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Image.height({ "id": 16777286, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
        }, Image);
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithChild();
            Button.debugLine("entry/src/main/ets/pages/Index.ets(318:17)", "entry");
            Button.backgroundColor({ "id": 16777267, "type": 10001, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Button.borderRadius({ "id": 16777294, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Button.margin({ "id": 16777292, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
        }, Button);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777279, "type": 20000, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Image.debugLine("entry/src/main/ets/pages/Index.ets(319:19)", "entry");
            Image.width({ "id": 16777286, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
            Image.height({ "id": 16777286, "type": 10002, params: [], "bundleName": "com.example.centralcontralscreen", "moduleName": "entry" });
        }, Image);
        Button.pop();
        Row.pop();
        // 可视对讲
        Column.pop();
        // --- B2. 右侧列：居家康养 + 家庭网络 + 可视对讲 (内容已完整补充)
        Column.pop();
        // --- B. 中间 + 右侧：卡片区域 (使用 Row 包裹两个 Column，实现剩下的两列)
        Row.pop();
        // 2. 内容区域：使用 Row 实现三列布局
        // 采用 Grid 实现左侧场景的 2x4 排列
        Row.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "MainPage";
    }
}
registerNamedRoute(() => new MainPage(undefined, {}), "", { bundleName: "com.example.centralcontralscreen", moduleName: "entry", pagePath: "pages/Index", pageFullPath: "entry/src/main/ets/pages/Index", integratedHsp: "false", moduleType: "followWithHap" });
