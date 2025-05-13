//
//  Common.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/10/10.
//

import Foundation

//根据多种因素计算每天的目标饮水量
func caculateWaterIntake(pal: Double, weight: Double, gender: Double, humidity: Double, athlete: Double, hdi: Double, altitude: Double, age: Double, temprature: Double ) -> Int{
    let intake = (1076.0 * pal + 14.34 * weight + 374.9 * gender + 5.823 * humidity + 1070 * athlete + 104.6 * hdi + 0.4726 * altitude - 0.3529 * age * age + 24.78 * age + 1.865 * temprature * temprature - 19.66 * temprature - 713.1) * 0.6
    
    return doubleToPercent(value: intake)
}

private func doubleToPercent(value: Double) -> Int {
    return Int(round(value / 100) * 100)
}

//将date类型转换为“yyyy/MM/dd”的格式
func DateGetDay(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd"  // 设置日期格式
    let dateString = dateFormatter.string(from: date)  // 将 Date 转换为 String
    return dateString
}

//将date类型转换为“y年M月d日”的格式
func DateGetDay2(date: Date) -> String {
    let calendar = Calendar.current
    let formatter = DateFormatter()
    
    // 设置日期格式为 "x年x月x日"
    formatter.dateFormat = "y年M月d日"
    let formattedDate = formatter.string(from: date)
    
    // 判断日期是今天、昨天、前天
    if calendar.isDateInToday(date) {
        return "今天·\(formattedDate)"
    } else if calendar.isDateInYesterday(date) {
        return "昨天·\(formattedDate)"
    } else if let dayBeforeYesterday = calendar.date(byAdding: .day, value: -2, to: Date()),
              calendar.isDate(date, inSameDayAs: dayBeforeYesterday) {
        return "前天·\(formattedDate)"
    } else {
        return formattedDate
    }
}

//将date类型转换为“y年M月d日”的格式
func DateGetDay3(date: Date) -> String {
    let calendar = Calendar.current
    let formatter = DateFormatter()
    
    // 设置日期格式为 "x年x月x日"
    formatter.dateFormat = "y年M月d日"
    let formattedDate = formatter.string(from: date)
    
    return formattedDate
}

//将现在的date类型转换为“yyyy-MM-dd HH:mm:ss”的格式
func getCurrentDateString() -> String {
    let currentDate = Date() // 创建当前日期对象
    let dateFormatter = DateFormatter() // 创建日期格式化器
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // 设置日期格式
    dateFormatter.timeZone = TimeZone.current // 设置为当前时区
    
    let dateString = dateFormatter.string(from: currentDate) // 将日期转换为字符串
    return dateString // 返回格式化后的字符串
}

//将date类型转换为“yyyy-MM-dd HH:mm:ss”的格式
func getDateString(date: Date) -> String {
    let currentDate = date // 创建当前日期对象
    let dateFormatter = DateFormatter() // 创建日期格式化器
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // 设置日期格式
    dateFormatter.timeZone = TimeZone.current // 设置为当前时区
    
    let dateString = dateFormatter.string(from: currentDate) // 将日期转换为字符串
    return dateString // 返回格式化后的字符串
}

//将date类型转换为“HH:mm”的格式
func dateGetHourAndMinute(date: Date) -> String {
    let currentDate = date // 创建当前日期对象
    let dateFormatter = DateFormatter() // 创建日期格式化器
    dateFormatter.dateFormat = "HH:mm" // 设置日期格式
    dateFormatter.timeZone = TimeZone.current // 设置为当前时区
    
    let timeString = dateFormatter.string(from: currentDate) // 将日期转换为字符串
    return timeString // 返回格式化后的字符串
}

//将“yyyy-MM-dd HH:mm:ss”转换为date类型
func convertStringToDate(dateString: String) -> Date? {
    let dateFormatter = DateFormatter() // 创建日期格式化器
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // 设置日期格式
    dateFormatter.timeZone = TimeZone.current // 设置为当前时区
    
    return dateFormatter.date(from: dateString) // 将字符串转换为 Date 对象
}

// 获取当前年份
func getCurrentYear() -> Int {
    let currentYear = Calendar.current.component(.year, from: Date())
    return currentYear
}

// 获取当前月份
func getCurrentMonth() -> Int {
    let currentMonth = Calendar.current.component(.month, from: Date())
    return currentMonth
}

// 获取当前日份
func getCurrentDay() -> Int {
    let currentMonth = Calendar.current.component(.day, from: Date())
    return currentMonth
}

//获取某个日期的年份
func getYear(from date: Date) -> Int {
    let calendar = Calendar.current
    let year = calendar.component(.year, from: date)
    return year
}

//获取某个日期的月份
func getMonth(from date: Date) -> Int {
    let calendar = Calendar.current
    let month = calendar.component(.month, from: date)
    return month
}

//获取某个日期的日份
func getDay(from date: Date) -> Int {
    let calendar = Calendar.current
    let day = calendar.component(.day, from: date)
    return day
}

//某个日期减去特定天数
func subtractDays(from date: Date, days: Int) -> Date? {
    let calendar = Calendar.current
    return calendar.date(byAdding: .day, value: -days, to: date)
}

//检测一个日期是否是未来或过去，未来为true
func isFutureDate(_ date: Date) -> Bool {
    // 获取当前时间
    let currentDate = Date()
    
    // 使用 compare() 方法来比较日期
    if date.compare(currentDate) == .orderedDescending {
        // date 在 currentDate 之后，表示未来
        return true
    } else {
        // date 在 currentDate 之前或相等，表示过去或现在
        return false
    }
}

//获取一个年份月份下的所有date的集合
func getMonthAndYearAllDates(inYear year: Int, month: Int) -> [Date] {
    var calendar = Calendar.current
    calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current

    // Create date components for the first day of the month
    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = 1

    // Get the first date of the month
    guard let startDate = calendar.date(from: components) else { return [] }

    // Get the range of days in the given month
    guard let range = calendar.range(of: .day, in: .month, for: startDate) else { return [] }

    // Create a list of all dates in the month
    let dates = range.compactMap { day -> Date? in
        components.day = day
        return calendar.date(from: components)
    }

    return dates
}

//将date类型转换为"HH:mm"的格式
func dateToHourAndMinute(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter.string(from: date)
}

//将"HH:mm"格式转化为date类型
func HourAndMinuteToDate(_ timeString: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter.date(from: timeString)
}

// 将字符串转换为日期的辅助函数
func dateFromString(_ dateString: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    return formatter.date(from: dateString)
}

//传入整型的年月日，然后返回Date类型
func createDate(year: Int, month: Int, day: Int) -> Date? {
    var dateComponents = DateComponents()
    dateComponents.year = year
    dateComponents.month = month
    dateComponents.day = day

    // 使用当前日历生成 Date
    let calendar = Calendar.current
    return calendar.date(from: dateComponents)
}

// 根据两个时间生成提醒时间列表
func generateReminderTimes(start: Date, end: Date, interval: Int) -> [Date] {
    var reminderTimes: [Date] = []
    var currentTime = start
    
    // 将分钟转换为秒
    let intervalInSeconds = TimeInterval(interval * 60)
    
    // 获取日历
    let calendar = Calendar.current
    
    // 检查 end 是否在 start 的当天
    let startComponents = calendar.dateComponents([.year, .month, .day], from: start)
    let endComponents = calendar.dateComponents([.year, .month, .day], from: end)
    
    // 如果 end 是第二天，则将 end 的日期设置为 start 的日期
    if endComponents.day == startComponents.day {
        // end 在同一天
        var endTime = calendar.date(bySettingHour: endComponents.hour ?? 0, minute: endComponents.minute ?? 0, second: 0, of: start)!
        if endTime < start {
            // 如果 end 时间早于 start，调整到第二天
            endTime = calendar.date(byAdding: .day, value: 1, to: endTime)!
        }
        currentTime = start
        while currentTime <= endTime {
            reminderTimes.append(currentTime)
            currentTime = currentTime.addingTimeInterval(intervalInSeconds)
        }
    } else {
        // end 在第二天
        var endTime = calendar.date(bySettingHour: endComponents.hour ?? 0, minute: endComponents.minute ?? 0, second: 0, of: start)!
        endTime = calendar.date(byAdding: .day, value: 1, to: endTime)!
        
        while currentTime <= endTime {
            reminderTimes.append(currentTime)
            currentTime = currentTime.addingTimeInterval(intervalInSeconds)
        }
    }
    
    return reminderTimes
}

// 获取剩余的提醒时间列表
func remainingReminderTimes(from reminderTimes: [Date]) -> [Date] {
    let currentDate = Date()
    let calendar = Calendar.current
    
    // 获取当前时间的小时和分钟
    let currentComponents = calendar.dateComponents([.hour, .minute], from: currentDate)
    var remainingTimes: [Date] = []

    // 遍历所有提醒时间
    for time in reminderTimes {
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        
        // 检查时间是否是今天的时间或第二天的时间
        if timeComponents.hour! > currentComponents.hour! ||
           (timeComponents.hour! == currentComponents.hour! && timeComponents.minute! > currentComponents.minute!) ||
           (calendar.isDateInTomorrow(time)) {
            remainingTimes.append(time)
        }
    }
    
    return remainingTimes
}

//将一个date类型的值加减特定的分钟数
func adjustDateByMinutes(_ date: Date, minutes: Int) -> Date {
    return date.addingTimeInterval(TimeInterval(minutes * 60))
}
