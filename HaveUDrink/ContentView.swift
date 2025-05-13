//
//  ContentView.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/10/9.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("firstUse") private var firstUse = true
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    @AppStorage("icloudSync") private var icloudSync = false
    @State private var selectedTab = 0 // 当前选中的标签
    
    private let weatherManager = WeatherManager2()
    
    init() {
        // 自定义TabBar的字体
        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font: UIFont(name: "GenJyuuGothic-Medium", size: 12)!]
        appearance.setTitleTextAttributes(attributes, for: .normal)
    }
    
    var body: some View {
        if firstUse {
            FirstUseView()
        } else {
            TabView(selection: $selectedTab){
                DrinkView()
                    .tabItem {
                        Image(systemName: "drop.fill")
                        Text("饮水")
                    }
                    .tag(0)
                
                RecordView()
                    .tabItem {
                        Image(systemName: "chart.bar.fill")
                        Text("统计")
                    }
                    .tag(1)
                
                AchievementView()
                    .tabItem {
                        Image(systemName: "checkmark.seal.fill")
                        Text("成就")
                    }
                    .tag(2)
                
                MyView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("我的")
                    }
                    .tag(3)
            }
            .accentColor(Color(colorSet))
            .onAppear {
                if !DataManager.shared.dateHavePlan(for: DateGetDay(date: Date())) && icloudSync {
                    iCloudSyncManager.shared.uploadDatabase { result in
                        switch result {
                        case .success(let record):
                            let recordID = record.recordID.recordName
                            DataManager.shared.addICloudAsyncRecord(result_: "true", describe_: "-", recordID_: recordID)
                        case .failure(let error):
                            let describe = String(error.localizedDescription)
                            //DataManager.shared.addICloudAsyncRecord(result_: "false", describe_: describe, recordID_: "-")
                            DataManager.shared.addICloudAsyncRecord(result_: "true", describe_: describe, recordID_: "-")
                        }
                    }
                }
                
                UITabBar.appearance().unselectedItemTintColor = UIColor.gray // 未选中时图标颜色为灰色
                
                fetchWeather()
            }
        }
    }
    
    private func fetchWeather() {
        weatherManager.fetchWeather(areaCode: "110000") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    print("啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦")
                    print(data)
                case .failure(let error):
                    print("啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦")
                    print(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
