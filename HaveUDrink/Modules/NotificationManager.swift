//
//  NotificationManager.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/10/17.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    static let shared = NotificationManager()
    
    private init() {}
    
    // 请求通知权限
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("请求通知权限失败: \(error.localizedDescription)")
            } else {
                print("通知权限 \(granted ? "已授予" : "被拒绝")")
            }
        }
    }
    
    // 发送本地通知
    // 根据提醒时间列表定时发送通知
    func scheduleNotifications(for reminderTimes: [Date], title: String, body: String) {
        let calendar = Calendar.current
        let currentDate = Date()

        for reminderTime in reminderTimes {
            // 获取提醒时间的日期组件
            var components = calendar.dateComponents([.hour, .minute], from: reminderTime)
            
            // 调整日期部分，确保跨午夜的时间设为第二天
            if reminderTime < currentDate {
                // 如果提醒时间已经过了今天，调整为第二天
                if let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                    components.year = calendar.component(.year, from: nextDay)
                    components.month = calendar.component(.month, from: nextDay)
                    components.day = calendar.component(.day, from: nextDay)
                }
            } else {
                // 保证时间是今天的时间
                components.year = calendar.component(.year, from: currentDate)
                components.month = calendar.component(.month, from: currentDate)
                components.day = calendar.component(.day, from: currentDate)
            }
            
            // 设置通知内容
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default
            
            // 创建触发器，使用日期组件触发
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            // 创建通知请求
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            // 将通知添加到通知中心
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("添加通知失败: \(error.localizedDescription)")
                } else {
                    print("通知已调度: \(components.hour!):\(components.minute!)")
                }
            }
        }
    }
}
