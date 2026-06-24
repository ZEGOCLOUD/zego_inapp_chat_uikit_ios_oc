# ZIMKit (In-App Chat UIKit · Objective-C)

> 本文件供 AI 助手快速理解本仓库，便于定位问题与扩展功能。

## 这是什么

这是 ZEGO **应用内聊天 UIKit 的 Objective-C 版本**（pod 名 `ZIMKit_OC`）。它在 `ZIM`
（即时通讯 SDK）之上封装出开箱即用的聊天 UI：会话列表、单聊、群聊、富媒体消息（图片/语音/
视频/文件）、多选删除等。业务逻辑层与 UI 层解耦，UI 层只关注视图与事件。

> 注意：这是**独立于 Swift 版（`zego_inapp_chat_uikit_ios_swift`）的另一套实现**。OC 版直接依赖
> `ZIM`，Swift 版则通过 `ZegoUIKitSignalingPlugin` 间接使用 ZIM，两者不要混淆。

依赖（CocoaPods）：`ZIM` (2.4.2)、`Masonry`（布局）、`YYText`（富文本）、`MJRefresh`（下拉刷新）、
`TZImagePickerController`（相册选择）、`SDWebImage`（图片加载）。平台 iOS 9.0+。

## 目录结构

```
ZIMKit/
├── ZIMKitCommon/                  # 公共层
│   ├── ZIMKit.h                   # 总头文件（对外汇总导入）
│   ├── ZIMKitCommBase/
│   │   ├── ZIMKitManager.{h,m}    # 核心门面：持有 ZIM 实例、连接/登录、未读数、建群/入群（重点）
│   │   ├── ZIMKitEventHandler.{h,m}  # ZIM 回调分发
│   │   ├── ZIMKitBaseViewController / ZIMKitNavigationController  # 基类
│   │   ├── ZIMKitUserInfo / ZIMKitGroupInfo / ZIMKitDefine        # 模型与常量
│   │   └── ZIMKitLocalAPNS        # 本地推送
│   ├── ZIMKitRouter/              # 页面路由（ZIMKitRouter + ZIMKitBaseModule）
│   └── ZIMKitToolUtil/            # 分类工具（NSString/UIColor/UIImage/UIView+布局/Toast 等）
├── ZIMKitConversation/            # 会话列表模块（Model / UI / VM，MVVM）
├── ZIMKitGroup/                   # 群聊管理模块（Model / UI / VM）
└── ZIMKitMessages/                # 消息（单聊/群聊）模块（Model / UI / VM / Vendor / 工具）
```

## 架构要点

- **MVVM 分模块**：三个业务模块 `Conversation` / `Group` / `Messages` 各自划分
  `Model`（数据）、`VM`（ViewModel，业务逻辑、调 ZIM）、`UI`（视图/控制器）。改业务逻辑找 `VM`，
  改界面找 `UI`。
- **`ZIMKitManager`（门面/核心）**：单例式封装，直接持有 `ZIM` 实例，负责连接登录、连接状态回调、
  总未读数、建群/加群等。聊天「登录失败 / 未读数不更新 / 建群失败」类问题优先看这里。
- **`ZIMKitEventHandler`**：集中接收 ZIM 的回调并分发给各模块/页面。
- **路由 `ZIMKitRouter`**：模块间页面跳转解耦，通过 `ZIMKitBaseModule` 注册。
- **直接依赖 ZIM**：与 Swift 版最大区别——OC 版 podspec 直接 `dependency 'ZIM'`，不经插件适配器。

## 分发

- **仅 CocoaPods**：`ZIMKit_OC.podspec`，源码分发（`source_files = ZIMKit/**/*.{h,m}`），无 SPM。
- **多资源 bundle**：`ChatResources` / `CommonResources` / `ConversationResources` /
  `GroupResources` / `GKPhotoBrowser`，按模块拆分。新增图标需放对应 bundle 目录。
- `Samples/ZIMKitDemo` 为示例工程（非库代码）。

## 修改 / 扩展指引

- 改某模块逻辑：进对应模块的 `VM/`；改界面：进对应模块的 `UI/`；改数据结构：进 `Model/`。
- 新增公共能力（连接/未读/群管理）：改 `ZIMKitManager`。
- 新增页面跳转：通过 `ZIMKitRouter` + `ZIMKitBaseModule` 注册，避免模块间直接耦合。
- 处理 ZIM 回调：改 `ZIMKitEventHandler`，注意回调透传到 VM 的线程。
- 改样式走分类工具（`ZIMKitToolUtil`）与对应资源 bundle；富文本用 `YYText`，布局用 `Masonry`。

## 测试

仓库内无单元测试；通过 `Samples/ZIMKitDemo` 真机/多端验证登录、会话列表、单聊/群聊收发、
富媒体消息、多选删除等。
