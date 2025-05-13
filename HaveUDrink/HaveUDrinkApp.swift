//
//  HaveUDrinkApp.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/10/9.
//

import SwiftUI
import UserNotifications
import AppIntents

extension Notification.Name {
    static let openAddView = Notification.Name("openAddView")
    static let openAddNFCView = Notification.Name("openAddNFCView")
}

@main
struct HaveUDrinkApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @State private var isAddViewActive = false
    @State private var isAddNFCViewActive = false
    
    init() {
        let openRemind = UserDefaults.standard.bool(forKey: "openRemind")
        if openRemind {
            let remindTime = UserDefaults.standard.integer(forKey: "remindTime")
            let getupTime = UserDefaults.standard.string(forKey: "getupTime")!
            let sleepTime = UserDefaults.standard.string(forKey: "sleepTime")!
            let realGetupTime = adjustDateByMinutes(HourAndMinuteToDate(getupTime)!, minutes: 30)
            let realSleepTime = adjustDateByMinutes(HourAndMinuteToDate(sleepTime)!, minutes: -30)
            let times = generateReminderTimes(start: realGetupTime, end: realSleepTime, interval: remindTime)
            NotificationManager.shared.scheduleNotifications(for: times, title: "饮水提醒", body: "该喝水啦，记得及时饮水哦！")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .background(
                        ZStack {
                            NavigationLink(destination: AddView(), isActive: $isAddViewActive) { EmptyView() }
                            NavigationLink(destination: NFCDrinkView_Single_Add(), isActive: $isAddNFCViewActive) { EmptyView() }
                        }
                        .hidden()
                    )
                    .onAppear {
                        NotificationCenter.default.addObserver(forName: .openAddView, object: nil, queue: .main) { _ in
                            isAddViewActive = true
                        }
                        NotificationCenter.default.addObserver(forName: .openAddNFCView, object: nil, queue: .main) { _ in
                            isAddNFCViewActive = true
                        }
                    }
                    .onChange(of: scenePhase) { newPhase in
                        if newPhase == .active {
                            if UserDefaults.standard.bool(forKey: "ShouldOpenAddView") {
                                isAddViewActive = true
                                UserDefaults.standard.set(false, forKey: "ShouldOpenAddView")
                            }
                            if UserDefaults.standard.bool(forKey: "ShouldOpenAddNFCView") {
                                isAddNFCViewActive = true
                                UserDefaults.standard.set(false, forKey: "ShouldOpenAddNFCView")
                            }
                        }
                    }
            }
        }
    }
}
