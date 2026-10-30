# 设计来源记录

文件：Spot UI Kit；Pixso 文件编号：`UZg8yNfqqZTxWDWkgDnSNQ`。

已读取 UI Kit、Styles、Symbols 三个页面。UI Kit 的 30 个 Frame 对应 30 个 Flutter 界面；Styles 的两个规范板已导出；Symbols 共 104 个组件，提供视觉和控件结构参考。

- `source-map.json`：原始节点编号、原稿路径、Flutter 截图路径。
- `nodes.json`：读取的画布图层结构、文本、尺寸与配色资料。
- `reference/`：30 张业务页原稿和两张基础规范板截图。
- `contact-sheet.jpg`：业务页原稿总览。

已先尝试 Pixso 原生 Flutter 导出。全量导出超时，单页可生成布局，但部分矢量和图形为空。最终实现根据读取的原始布局、文本、样式和导出素材，整理为可维护的 Flutter 控件，并补足本地交互。未保留无法直接运行的生成代码。

实现与原稿的主要差异是：统一分类入口与页面切换条、Material 图标，以及可操作的筛选、表单和按钮反馈。原稿插画和商品图片继续使用本地素材。移动布局可滚动，桌面以等比手机预览呈现。
