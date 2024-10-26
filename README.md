# 开始之前
1.“今天喝了么”是我们为了参加一个大学生比赛开发的一款app，你可能觉得“喝水”这类应用现在已经很多了，但是我看对于参加竞赛的话这类应用还是比较小众的。

2.本项目完全开源并且免费下载和使用（App Store上搜“今天喝了么”就可以了，需要ios17），使用该源码需要遵守Apache 2.0 许可协议，供学习和交流，且禁止将本项目简单改个名或者换个ui就上架运营。

3.由于本项目是参赛作品，再加上开发时间紧迫（大约就15天左右），本着“能跑就行”的理念，所以本项目中有些代码存在一些“雷人”的地方，各路大佬轻喷。

# 要玩这个项目需要哪些东西
1.一台装有macOS的电脑

2.Xcode15.4

# 如何配置项目
- 添加SQLite包
  - 在项目文件夹中已给出SQLite包，放在.Packages文件夹中。你也可以访问SQLite的仓库，来 [查看](https://github.com/stephencelis/SQLite.swift) 如何添加SQLite包。
  - 在Xcode的菜单栏中，选择File->Add Package Dependencies，即可添加SQLite包。

- 修改Bundle Identifier
  - 在Xcode主界面左侧导航栏中点击项目名称，选择TARGETS中的HaveUDrink，选择Signing&Capabilities，在Signing中选择你的Team，并修改一个合适的Bundle Identifier。
- 添加iCloud Container
  - 下拉找到iCloud，添加一个Container
  - 打开项目文件夹下的HaveUDrink.entitlements文件，点开iCloud Container Identifiers，把item0的值改为你自己的Container。
  - 打开项目文件夹下的./Modules/iCloudSyncManager.swift文件，找到`let container = CKContainer(identifier: "Your.iCloud.Container.Identifiers.Here")`这一行，并把Your.iCloud.Container.Identifiers.Here改为你自己的Container。
