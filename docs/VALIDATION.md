# 验证记录

验证日期：2026-10-31（Asia/Tokyo）。

## 结果

| 检查 | 结果 |
| --- | --- |
| Flutter 静态检查 | 通过，No issues found |
| 自动检查 | 8 项全部通过 |
| 标准手机首屏渲染 | 30 页，375 × 812 逻辑像素，未检测到布局 / 渲染异常 |
| 小屏幕布局 | 30 页，320 × 693 逻辑像素，通过 |
| 较小桌面窗口 | 30 页，800 × 600 逻辑像素，通过 |
| 桌面入口与预览截图 | 1180 × 880 逻辑像素，已生成 |
| macOS Debug 构建 | 通过，`build/macos/Build/Products/Debug/Spot.app` |
| Android Debug 构建 | 通过，`build/app/outputs/flutter-apk/app-debug.apk` |

自动检查覆盖：分类搜索与打开、30 页图片加载和截图、本地状态恢复、非法金额拒绝、饮水记录、购物袋与优惠码计算、演示下单、钱包金额校验，以及手机和桌面布局。最后一轮自动检查耗时约 92 秒。

原始结果文件：[静态检查](validation/flutter-analyze.txt)、[自动检查](validation/flutter-test.txt)、[macOS 构建](validation/macos-build.txt)、[Android 构建](validation/android-build.txt)。

## 运行环境与边界

- Flutter 3.41.6 / Dart 3.11.4，macOS 26.5.2，Apple Silicon。
- 已实际启动 macOS 原生应用，并点击分类卡片进入饮水界面；发现的小窗口预览问题已修正，最终版本通过桌面渲染检查。
- 后续追加人工点击检查时电脑已锁屏，未继续进行人工操作。
- 本机 iOS 没有可用模拟器 Runtime，两个 Android 虚拟设备的系统镜像也不完整，因此未执行 iOS / Android 模拟器内的安装与点击检查。Android 已完成 APK 编译；iOS 宿主工程已准备，尚未执行 iOS 构建。
- 图像来自 Flutter 控件的实际渲染。状态栏和底部指示条用于固定截图与桌面预览，移动设备使用系统安全区域。长页面支持滚动；截图呈现默认首屏。
- 自动检查用于发现布局异常与验证关键流程，不代表与设计稿逐像素完全相同。Material 图标和可操作控件与静态稿存在少量差异。

当前应用采用本地演示数据。金融操作和结算不会产生真实资金交易，求职意向不会提交到外部服务，音乐播放控制不会播放音频。
