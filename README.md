# 开始之前
1.“今天喝了么”是我们为了参加一个大学生比赛开发的一款app，你可能觉得“喝水”这类应用现在已经很多了，但是我看对于参加竞赛的话这类应用还是比较小众的（25年3月补充：我们还是想的太简单了，评委也不傻，我们获得了三等奖...）。

2.本项目完全开源并且免费下载和使用（App Store上搜“今天喝了么”就可以了，需要ios17），使用该源码需要遵守[Apache 2.0 许可协议](http://www.apache.org/licenses/LICENSE-2.0)，供学习和交流，且禁止将本项目简单改个名或者换个ui就上架运营。

3.由于本项目是参赛作品，再加上开发时间紧迫（大约就15天左右），本着“能跑就行”的理念，所以本项目中有些代码存在一些“雷人”的地方，各路大佬轻喷。

# 要玩这个项目需要哪些东西
1.一台装有macOS的电脑

2.Xcode15.4

# 如何配置项目
- 添加SQLite包
  - 在项目文件夹中已给出SQLite包，放在`.Packages`文件夹中。你也可以访问SQLite的仓库，来 [查看](https://github.com/stephencelis/SQLite.swift) 如何添加SQLite包。
  - 在Xcode的菜单栏中，选择`File->Add Package Dependencies`，即可添加SQLite包。

- 修改Bundle Identifier
  - 在Xcode主界面左侧导航栏中点击项目名称，选择`TARGETS`中的`HaveUDrink`，选择`Signing&Capabilities`，在`Signing`中选择你的Team，并修改一个合适的`Bundle Identifier`。
    
- 添加iCloud Container
  - 下拉找到`iCloud`，添加一个Container
  - 打开项目文件夹下的`HaveUDrink.entitlements`文件，点开`iCloud Container Identifiers`，把`item0`的值改为你自己的Container。
  - 打开项目文件夹下的`./Modules/iCloudSyncManager.swift`文件，找到`let container = CKContainer(identifier: "Your.iCloud.Container.Identifiers.Here")`这一行，并把`Your.iCloud.Container.Identifiers.Here`改为你自己的Container。
    
- 修改SecretID和SecretKey
  -  本项目使用了腾讯云市场的一个API来获取天气信息，这些天气信息可作为参数以计算每天的目标饮水量。
  -  首先你需要一个腾讯云账号，然后 [点击这里](https://market.cloud.tencent.com/products/38348) 白嫖200次的API调用次数。
  -  在控制台中，找到你的`SecretID`和`SecretKey`。
  -  打开项目文件夹下的`./Modules/WeatherManager.swift`文件，在`makeRequest`方法中修改你的`SecretID`和`SecretKey`。
    
  # 最后
  如果你耐心地跟着说明做到了这里，那么你应该可以顺利跑起来项目了。如果没有的话可以去提交一个`issue`，来说明出现了哪些错误，我会继续修改。你可以将报错复制下来问问gpt，一般情况下是能解决掉的。

  如果你不明白什么是源码什么是github但是看到了这个页面，什么都不要问，直接去App Store上搜“今天喝了么”下载使用就可以了。

  哦对了差点忘了，各位大学生们慎将该项目作为结课作业、毕业设计等使用，抄袭有风险！且出了事与我们无关。
  
