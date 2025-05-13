//
//  DataManager.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/10/12.
//

import Foundation
import SQLite

class DataManager{
    static let shared = DataManager()
    
    private var db: Connection?
    
    private init() {
        createDatabase()
    }
    
    private func createDatabase() {
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("HaveUDrinkUserDatabase.sqlite")
            
            // 打开数据库（如果不存在则创建）
            db = try Connection(fileURL.path)
            print("数据库已创建或已存在")
        } catch {
            print("创建数据库失败: \(error)")
        }
    }
    
    // 插入或更新数据到 userEverydayPlans 表
    func addPlan(date_: String, intake_: Int) {
        // 定义一个 userEverydayPlans 表
        let userEverydayPlans = Table("userEverydayPlans")
        let date = Expression<String>(value: "date")
        let intake = Expression<Int>(value: "intake")
        
        do {
            // 如果表不存在则创建表
            try db?.run(userEverydayPlans.create(ifNotExists: true) { table in
                table.column(date, primaryKey: true)  // 日期作为主键
                table.column(intake)
            })
            
            // 查询是否存在相应的日期
            let query = userEverydayPlans.filter(date == date_)
            if let existingPlan = try db?.pluck(query) {
                // 如果该日期已存在，更新 intake
                try db?.run(query.update(intake <- intake_))
                print("更新计划：日期 = \(date_)，新的饮水量 = \(intake_)")
            } else {
                // 如果该日期不存在，插入新数据
                let insert = userEverydayPlans.insert(date <- date_, intake <- intake_)
                try db?.run(insert)
                print("已插入一条计划：日期 = \(date_)，饮水量 = \(intake_)")
                
            }
        } catch {
            print("插入或更新数据失败: \(error)")
        }
    }
    
    func userHavePlan(date_: String) -> Bool {
        let userEverydayPlans = Table("userEverydayPlans")
        let date = Expression<String>("date")
        let intake = Expression<Int>("intake")
        
        do {
            //如果表不存在，则创建表
            try db?.run(userEverydayPlans.create(ifNotExists: true) { table in
                table.column(date, primaryKey: true)  // 日期作为主键
                table.column(intake)
            })
            
            let query = userEverydayPlans.filter(date == date_)
            if let _ = try db?.pluck(query) {
                return true  // 找到记录，返回 true
            } else {
                return false  // 没找到记录，返回 false
            }
        } catch {
            print("查询记录失败: \(error)")
            return false  // 出现错误时，返回 false
        }
    }
    
    func dateHavePlan(for date: String) -> Bool {
        let userEverydayPlans = Table("userEverydayPlans")
        let dateColumn = Expression<String>("date")
        
        do {
            // 查询是否存在指定日期的记录
            let query = userEverydayPlans.filter(dateColumn == date).exists
            if let exists = try db?.scalar(query) {
                return exists  // 如果存在记录则返回 true
            } else {
                return false
            }
        } catch {
            print("查询失败: \(error)")
            return false
        }
    }
    
    // 获取特定日期的 intake
    func getTodayIntake(for date_: String) -> Int? {
        let userEverydayPlans = Table("userEverydayPlans")
        let date = Expression<String>("date")
        let intake = Expression<Int>("intake")
        
        do {
            let query = userEverydayPlans.filter(date == date_)
            if let record = try db?.pluck(query) {
                return record[intake]  // 返回对应日期的 intake 值
            } else {
                print("没有找到日期为 \(date) 的记录")
                return nil  // 如果没有记录，返回 nil
            }
        } catch {
            print("查询 intake 失败: \(error)")
            return nil  // 出现错误时，返回 nil
        }
    }
    
    //添加特定日期的水摄入
    func addWaterIntake(date_: String, intake_: Int, time_: Date){
        let waterIntakes = Table("waterIntakes")
        let date = Expression<String>("date")
        let intake = Expression<Int>("intake")
        let time = Expression<String>("time")
        
        do {
            // 如果表不存在则创建表
            try db?.run(waterIntakes.create(ifNotExists: true) { table in
                table.column(date)
                table.column(intake)
                table.column(time)
            })
            
            let insert = waterIntakes.insert(date <- date_, intake <- intake_, time <- getDateString(date: time_))
            try db?.run(insert)
            print("已插入一条饮水摄入：日期 = \(date_)，饮水量 = \(intake_)")
        } catch {
            print("插入数据失败: \(error)")
        }
    }
    
    //添加特定日期的酒摄入
    func addWineIntake(date_: String, intake_: Int, type_: String, concentration_: Int, alcoholContent_: Int, time_: Date){
        let wineIntakes = Table("wineIntakes")
        let date = Expression<String>("date")
        let intake = Expression<Int>("intake")
        let type = Expression<String>("type")
        let concentration = Expression<Int>("concentration")
        let alcoholContent = Expression<Int>("alcoholContent")
        let time = Expression<String>("time")
        
        do {
            // 如果表不存在则创建表
            try db?.run(wineIntakes.create(ifNotExists: true) { table in
                table.column(date)
                table.column(intake)
                table.column(type)
                table.column(concentration)
                table.column(alcoholContent)
                table.column(time)
            })
            
            let insert = wineIntakes.insert(date <- date_, intake <- intake_, type <- type_, concentration <- concentration_, alcoholContent <- alcoholContent_, time <- getDateString(date: time_))
            try db?.run(insert)
            print("已插入一条酒摄入：日期 = \(date_)，摄入量 = \(intake_)")
        } catch {
            print("插入数据失败: \(error)")
        }
    }
    
    //添加特定日期的咖啡摄入
    func addCoffeeIntake(date_: String, intake_: Int, type_: String, brand_: String, espressoCount_: Int, caffeeine_: Int, time_: Date){
        let coffeeIntakes = Table("coffeeIntakes")
        let date = Expression<String>("date")
        let intake = Expression<Int>("intake")
        let type = Expression<String>("type")
        let brand = Expression<String>("brand")
        let espressoCount = Expression<Int>("espressoCount")
        let caffeeine = Expression<Int>("caffeeine")
        let time = Expression<String>("time")
        
        do {
            // 如果表不存在则创建表
            try db?.run(coffeeIntakes.create(ifNotExists: true) { table in
                table.column(date)
                table.column(intake)
                table.column(type)
                table.column(brand)
                table.column(espressoCount)
                table.column(caffeeine)
                table.column(time)
            })
            
            let insert = coffeeIntakes.insert(date <- date_, intake <- intake_, type <- type_, brand <- brand_, espressoCount <- espressoCount_, caffeeine <- caffeeine_, time <- getDateString(date: time_))
            try db?.run(insert)
            print("已插入一条咖啡摄入：日期 = \(date_)，摄入量 = \(intake_)")
        } catch {
            print("插入数据失败: \(error)")
        }
    }
    
    //添加特定日期的奶茶摄入
    func addMilkteaIntake(date_: String, intake_: Int, brand_: String, time_: Date){
        let milkTeaIntakes = Table("milkTeaIntakes")
        let date = Expression<String>("date")
        let intake = Expression<Int>("intake")
        let brand = Expression<String>("brand")
        let time = Expression<String>("time")
        
        do {
            // 如果表不存在则创建表
            try db?.run(milkTeaIntakes.create(ifNotExists: true) { table in
                table.column(date)
                table.column(intake)
                table.column(brand)
                table.column(time)
            })
            
            let insert = milkTeaIntakes.insert(date <- date_, intake <- intake_, brand <- brand_, time <- getDateString(date: time_))
            try db?.run(insert)
            print("已插入一条奶茶摄入：日期 = \(date_)，摄入量 = \(intake_)")
        } catch {
            print("插入数据失败: \(error)")
        }
    }
    
    //添加特定日期的奶摄入
    func addMilkIntake(date_: String, intake_: Int, type_: String, time_: Date){
        let milkIntakes = Table("milkIntakes")
        let date = Expression<String>("date")
        let intake = Expression<Int>("intake")
        let type = Expression<String>("type")
        let time = Expression<String>("time")
        
        do {
            // 如果表不存在则创建表
            try db?.run(milkIntakes.create(ifNotExists: true) { table in
                table.column(date)
                table.column(intake)
                table.column(type)
                table.column(time)
            })
            
            let insert = milkIntakes.insert(date <- date_, intake <- intake_, type <- type_, time <- getDateString(date: time_))
            try db?.run(insert)
            print("已插入一条奶摄入：日期 = \(date_)，摄入量 = \(intake_)")
        } catch {
            print("插入数据失败: \(error)")
        }
    }
    
    //添加特定日期的其他摄入
    func addOtherIntake(date_: String, intake_: Int, type_: String, time_: Date){
        let otherIntakes = Table("otherIntakes")
        let date = Expression<String>("date")
        let intake = Expression<Int>("intake")
        let type = Expression<String>("type")
        let time = Expression<String>("time")
        
        do {
            // 如果表不存在则创建表
            try db?.run(otherIntakes.create(ifNotExists: true) { table in
                table.column(date)
                table.column(intake)
                table.column(type)
                table.column(time)
            })
            
            let insert = otherIntakes.insert(date <- date_, intake <- intake_, type <- type_, time <- getDateString(date: time_))
            try db?.run(insert)
            print("已插入一条其他摄入：日期 = \(date_)，摄入量 = \(intake_)")
        } catch {
            print("插入数据失败: \(error)")
        }
    }
    
    // 获取某个表中指定日期的 intake 总和
    private func getDateIntake(for date: String, from table: Table) -> Int {
        let dateColumn = Expression<String>("date")
        let intakeColumn = Expression<Int>("intake")
        
        do {
            // 使用 sum 函数来获取 intake 的总和
            let query = table.filter(dateColumn == date).select(intakeColumn.sum)
            if let record = try db?.pluck(query) {
                return record[intakeColumn.sum] ?? 0
            }
        } catch {
            print("查询表 \(table) 中的 intake 失败: \(error)")
        }
        return 0  // 如果未找到记录或查询失败，返回 0
    }
    
    // 计算所有表中指定日期的 intake 总和
    func getDateTotalIntake(for date: String) -> Int {
        var totalIntake = 0
        
        // 定义多个表
        let waterIntakes = Table("waterIntakes")
        let wineIntakes = Table("wineIntakes")
        let coffeeIntakes = Table("coffeeIntakes")
        let milkTeaIntakes = Table("milkTeaIntakes")
        let milkIntakes = Table("milkIntakes")
        let otherIntakes = Table("otherIntakes")
        
        // 遍历每个表并获取 intake
        let tables = [waterIntakes, wineIntakes, coffeeIntakes, milkTeaIntakes, milkIntakes, otherIntakes]
        for table in tables {
            totalIntake += getDateIntake(for: date, from: table)
        }
        
        return totalIntake
    }
    
    // 获取 waterIntakes 表中指定日期的 intake 总和
    func getDateWaterIntakeSum(from date: String) -> Int {
        let waterIntakesTable = Table("waterIntakes")
        let dateColumn = Expression<String>("date")
        let intakeColumn = Expression<Int>("intake")

        do {
            // 使用 sum 函数来获取 intake 的总和
            let query = waterIntakesTable.filter(dateColumn == date).select(intakeColumn.sum)
            if let record = try db?.pluck(query) {
                // 直接返回 sum 的值，默认为 0
                return record[intakeColumn.sum] ?? 0
            }
        } catch {
            print("查询 waterIntakes 表中指定日期的 intake 失败: \(error)")
        }
        return 0  // 如果未找到记录或查询失败，返回 0
    }
    
    // 获取 wineIntakes 表中指定日期的 intake 总和
    func getDateWineIntake(from date: String) -> Int {
        let wineIntakesTable = Table("wineIntakes")
        let dateColumn = Expression<String>("date")
        let intakeColumn = Expression<Int>("intake")

        do {
            // 使用 sum 函数来获取 intake 的总和
            let query = wineIntakesTable.filter(dateColumn == date).select(intakeColumn.sum)
            if let record = try db?.pluck(query) {
                // 直接返回 sum 的值，默认为 0
                return record[intakeColumn.sum] ?? 0
            }
        } catch {
            print("查询 wineIntakes 表中指定日期的 intake 失败: \(error)")
        }
        return 0  // 如果未找到记录或查询失败，返回 0
    }
    
    // 获取 coffeeIntakes 表中指定日期的 intake 总和
    func getDateCoffeeIntake(from date: String) -> Int {
        let coffeeIntakesTable = Table("coffeeIntakes")
        let dateColumn = Expression<String>("date")
        let intakeColumn = Expression<Int>("intake")

        do {
            // 使用 sum 函数来获取 intake 的总和
            let query = coffeeIntakesTable.filter(dateColumn == date).select(intakeColumn.sum)
            if let record = try db?.pluck(query) {
                // 直接返回 sum 的值，默认为 0
                return record[intakeColumn.sum] ?? 0
            }
        } catch {
            print("查询 coffeeIntakes 表中指定日期的 intake 失败: \(error)")
        }
        return 0  // 如果未找到记录或查询失败，返回 0
    }
    
    // 获取 milkTeaIntakes 表中指定日期的 intake 总和
    func getDateMilkTeaIntake(from date: String) -> Int {
        let milkTeaIntakesTable = Table("milkTeaIntakes")
        let dateColumn = Expression<String>("date")
        let intakeColumn = Expression<Int>("intake")

        do {
            // 使用 sum 函数来获取 intake 的总和
            let query = milkTeaIntakesTable.filter(dateColumn == date).select(intakeColumn.sum)
            if let record = try db?.pluck(query) {
                // 直接返回 sum 的值，默认为 0
                return record[intakeColumn.sum] ?? 0
            }
        } catch {
            print("查询 milkTeaIntakes 表中指定日期的 intake 失败: \(error)")
        }
        return 0  // 如果未找到记录或查询失败，返回 0
    }
    
    // 获取 milkIntakes 表中指定日期的 intake 总和
    func getDateMilkIntake(from date: String) -> Int {
        let milkIntakesTable = Table("milkIntakes")
        let dateColumn = Expression<String>("date")
        let intakeColumn = Expression<Int>("intake")

        do {
            // 使用 sum 函数来获取 intake 的总和
            let query = milkIntakesTable.filter(dateColumn == date).select(intakeColumn.sum)
            if let record = try db?.pluck(query) {
                // 直接返回 sum 的值，默认为 0
                return record[intakeColumn.sum] ?? 0
            }
        } catch {
            print("查询 milkIntakes 表中指定日期的 intake 失败: \(error)")
        }
        return 0  // 如果未找到记录或查询失败，返回 0
    }
    
    // 获取 otherIntakes 表中指定日期的 intake 总和
    func getDateOtherIntake(from date: String) -> Int {
        let otherIntakesTable = Table("otherIntakes")
        let dateColumn = Expression<String>("date")
        let intakeColumn = Expression<Int>("intake")

        do {
            // 使用 sum 函数来获取 intake 的总和
            let query = otherIntakesTable.filter(dateColumn == date).select(intakeColumn.sum)
            if let record = try db?.pluck(query) {
                // 直接返回 sum 的值，默认为 0
                return record[intakeColumn.sum] ?? 0
            }
        } catch {
            print("查询 otherIntakes 表中指定日期的 intake 失败: \(error)")
        }
        return 0  // 如果未找到记录或查询失败，返回 0
    }
    
    // 获取 wineIntakes 表中指定日期的酒精摄入量总和
    func getDateAlcoholIntake(from date: String) -> Int {
        let wineIntakesTable = Table("wineIntakes")
        let dateColumn = Expression<String>("date")
        let alcoholContentColumn = Expression<Int>("alcoholContent")

        do {
            // 使用 sum 函数来获取 intake 的总和
            let query = wineIntakesTable.filter(dateColumn == date).select(alcoholContentColumn.sum)
            if let record = try db?.pluck(query) {
                // 直接返回 sum 的值，默认为 0
                return record[alcoholContentColumn.sum] ?? 0
            }
        } catch {
            print("查询 wineIntakes 表中指定日期的 intake 失败: \(error)")
        }
        return 0  // 如果未找到记录或查询失败，返回 0
    }
    
    // 获取 coffeeIntakes 表中指定日期的咖啡因摄入量总和
    func getDateCoffeeineIntake(from date: String) -> Int {
        let coffeeIntakesTable = Table("coffeeIntakes")
        let dateColumn = Expression<String>("date")
        let caffeeineColumn = Expression<Int>("caffeeine")

        do {
            // 使用 sum 函数来获取 intake 的总和
            let query = coffeeIntakesTable.filter(dateColumn == date).select(caffeeineColumn.sum)
            if let record = try db?.pluck(query) {
                // 直接返回 sum 的值，默认为 0
                return record[caffeeineColumn.sum] ?? 0
            }
        } catch {
            print("查询 coffeeIntakes 表中指定日期的 intake 失败: \(error)")
        }
        return 0  // 如果未找到记录或查询失败，返回 0
    }
    
    //获取某一天的所有饮水记录集合，并按时间排序
    func getDateIntakes(for date: String) -> [(intake: Int, time: String, type: String)] {
        var results: [(intake: Int, time: String, type: String)] = []
        
        // 定义表名和对应的类型
        let tableInfo = [
            ("waterIntakes", "水"),
            ("wineIntakes", "酒"),
            ("coffeeIntakes", "咖啡"),
            ("milkTeaIntakes", "奶茶"),
            ("milkIntakes", "奶"),
            ("otherIntakes", "其他")
        ]
        
        // 遍历每个表及其对应的类型
        for (tableName, type) in tableInfo {
            let table = Table(tableName)
            let dateColumn = Expression<String>("date")
            let intakeColumn = Expression<Int>("intake")
            let timeColumn = Expression<String>("time")
            
            do {
                // 查询特定日期的数据，并按时间倒序排列
                let query = table.filter(dateColumn == date).order(timeColumn.desc)
                if let rows = try db?.prepare(query) {
                    for row in rows {
                        // 将查询结果加入results，并添加对应的type
                        results.append((intake: row[intakeColumn], time: row[timeColumn], type: type))
                    }
                }
            } catch {
                print("查询 \(tableName) 表失败: \(error.localizedDescription)")
            }
        }
        
        return results
    }
    
    //获取某一天的饮水计划
    func getDatePlan(date: String) -> Int {
        let userEverydayPlans = Table("userEverydayPlans")
        let dateColumn = Expression<String>("date")
        let intakeColumn = Expression<Int>("intake")
        
        do {
            // 查询特定日期的摄入量
            let query = userEverydayPlans.select(intakeColumn).filter(dateColumn == date)
            if let row = try db?.pluck(query) {
                return row[intakeColumn]  // 返回摄入量
            } else {
                print("未找到该日期的摄入记录")
                return 0
            }
        } catch {
            print("查询失败: \(error)")
            return 0
        }
    }
    
    //获取某一天的饮水完成情况
    func getDateProgress(date_: String) -> Double {
        let plan = getDatePlan(date: date_)
        
        if plan == 0 {
            return 0.0
        } else {
            return Double(getDateTotalIntake(for: date_)) / Double(getDatePlan(date: date_))
        }
    }
    
    //获取某一天所有的饮水记录(按整小时分组)
    func getDateAllIntakes_GroupByHour(for date_: String) -> [(hour: String, name: String, intake: String, type: String, brand: String, concentration: String, espressoCount: String)] {
        var result: [(hour: String, name: String, intake: String, type: String, brand: String, concentration: String, espressoCount: String)] = []
        
        //定义所有字段名
        let date = Expression<String>("date")
        let intake = Expression<Int>("intake")
        let type = Expression<String>("type")
        let time = Expression<String>("time")
        let brand = Expression<String>("brand")
        let espressoCount = Expression<Int>("espressoCount")
        let concentration = Expression<Int>("concentration")
        
        //定义所有表名
        let waterIntakes = Table("waterIntakes")
        let wineIntakes = Table("wineIntakes")
        let coffeeIntakes = Table("coffeeIntakes")
        let milkTeaIntakes = Table("milkTeaIntakes")
        let milkIntakes = Table("milkIntakes")
        let otherIntakes = Table("otherIntakes")
        
        //分步处理所有表
        //处理waterIntakes表：
        do{
            let query = waterIntakes.filter(date == date_)
            if let rows = try db?.prepare(query) {
                for row in rows {
                    // 获取时间并提取小时部分
                    let timeString = row[time]
                    // 提取小时部分 (格式为 "YYYY/MM/DD HH:mm:ss"，我们取 "HH" 部分)
                    let hourString = String(timeString.split(separator: " ")[1].prefix(2)) // 取 "HH"
                    // 将字符串转为整数小时
                    if let hour = Int(hourString) {
                        // 构建 "HH:mm" 格式，确保小时为两位数
                        let formattedHour = String(format: "%02d:00", hour) // HH:00 格式
                        
                        result.append((hour: formattedHour, name: "水", intake: String(row[intake]), type: "-", brand: "-", concentration: "-", espressoCount: "-"))
                    }
                }
            }
        } catch {
            print("查询 waterIntakes 表失败: \(error.localizedDescription)")
        }
        //处理wineIntakes表：
        do{
            let query = wineIntakes.filter(date == date_)
            if let rows = try db?.prepare(query) {
                for row in rows {
                    // 获取时间并提取小时部分
                    let timeString = row[time]
                    // 提取小时部分 (格式为 "YYYY/MM/DD HH:mm:ss"，我们取 "HH" 部分)
                    let hourString = String(timeString.split(separator: " ")[1].prefix(2)) // 取 "HH"
                    // 将字符串转为整数小时
                    if let hour = Int(hourString) {
                        // 构建 "HH:mm" 格式，确保小时为两位数
                        let formattedHour = String(format: "%02d:00", hour) // HH:00 格式
                        
                        var type_ = String(row[type])
                        if type_ == "不选择" {
                            type_ = "-"
                        }
                        
                        result.append((hour: formattedHour, name: "酒", intake: String(row[intake]), type: type_, brand: "-", concentration: String(row[concentration]), espressoCount: "-"))
                    }
                }
            }
        } catch {
            print("查询 wineIntakes 表失败: \(error.localizedDescription)")
        }
        //处理coffeeIntakes表：
        do{
            let query = coffeeIntakes.filter(date == date_)
            if let rows = try db?.prepare(query) {
                for row in rows {
                    // 获取时间并提取小时部分
                    let timeString = row[time]
                    // 提取小时部分 (格式为 "YYYY/MM/DD HH:mm:ss"，我们取 "HH" 部分)
                    let hourString = String(timeString.split(separator: " ")[1].prefix(2)) // 取 "HH"
                    // 将字符串转为整数小时
                    if let hour = Int(hourString) {
                        // 构建 "HH:mm" 格式，确保小时为两位数
                        let formattedHour = String(format: "%02d:00", hour) // HH:00 格式
                        
                        var type_ = String(row[type])
                        var brand_ = String(row[brand])
                        if type_ == "不选择" {
                            type_ = "-"
                        }
                        if brand_ == "不选择" {
                            brand_ = "-"
                        }
                        
                        result.append((hour: formattedHour, name: "咖啡", intake: String(row[intake]), type: type_, brand: brand_, concentration: "-", espressoCount: String(row[espressoCount])))
                    }
                }
            }
        } catch {
            print("查询 coffeeIntakes 表失败: \(error.localizedDescription)")
        }
        //处理milkTeaIntakes表：
        do{
            let query = milkTeaIntakes.filter(date == date_)
            if let rows = try db?.prepare(query) {
                for row in rows {
                    // 获取时间并提取小时部分
                    let timeString = row[time]
                    // 提取小时部分 (格式为 "YYYY/MM/DD HH:mm:ss"，我们取 "HH" 部分)
                    let hourString = String(timeString.split(separator: " ")[1].prefix(2)) // 取 "HH"
                    // 将字符串转为整数小时
                    if let hour = Int(hourString) {
                        // 构建 "HH:mm" 格式，确保小时为两位数
                        let formattedHour = String(format: "%02d:00", hour) // HH:00 格式
                        
                        var brand_ = String(row[brand])
                        if brand_ == "不选择" {
                            brand_ = "-"
                        }
                        
                        result.append((hour: formattedHour, name: "奶茶", intake: String(row[intake]), type: "-", brand: brand_, concentration: "-", espressoCount: "-"))
                    }
                }
            }
        } catch {
            print("查询 milkTeaIntakes 表失败: \(error.localizedDescription)")
        }
        //处理milkIntakes表：
        do{
            let query = milkIntakes.filter(date == date_)
            if let rows = try db?.prepare(query) {
                for row in rows {
                    // 获取时间并提取小时部分
                    let timeString = row[time]
                    // 提取小时部分 (格式为 "YYYY/MM/DD HH:mm:ss"，我们取 "HH" 部分)
                    let hourString = String(timeString.split(separator: " ")[1].prefix(2)) // 取 "HH"
                    // 将字符串转为整数小时
                    if let hour = Int(hourString) {
                        // 构建 "HH:mm" 格式，确保小时为两位数
                        let formattedHour = String(format: "%02d:00", hour) // HH:00 格式
                        
                        var type_ = String(row[type])
                        if type_ == "不选择" {
                            type_ = "-"
                        }
                        
                        result.append((hour: formattedHour, name: "奶", intake: String(row[intake]), type: type_, brand: "-", concentration: "-", espressoCount: "-"))
                    }
                }
            }
        } catch {
            print("查询 milkIntakes 表失败: \(error.localizedDescription)")
        }
        //处理otherIntakes表：
        do{
            let query = otherIntakes.filter(date == date_)
            if let rows = try db?.prepare(query) {
                for row in rows {
                    // 获取时间并提取小时部分
                    let timeString = row[time]
                    // 提取小时部分 (格式为 "YYYY/MM/DD HH:mm:ss"，我们取 "HH" 部分)
                    let hourString = String(timeString.split(separator: " ")[1].prefix(2)) // 取 "HH"
                    // 将字符串转为整数小时
                    if let hour = Int(hourString) {
                        // 构建 "HH:mm" 格式，确保小时为两位数
                        let formattedHour = String(format: "%02d:00", hour) // HH:00 格式
                        
                        var type_ = String(row[type])
                        if type_ == "不选择" {
                            type_ = "-"
                        }
                        
                        result.append((hour: formattedHour, name: "其他", intake: String(row[intake]), type: type_, brand: "-", concentration: "-", espressoCount: "-"))
                    }
                }
            }
        } catch {
            print("查询 otherIntakes 表失败: \(error.localizedDescription)")
        }
        
        return result
    }
    
    //获取某一天的饮水次数
    func getTotalDrinkCount(for date: String) -> Int {
        // 定义表名
        let tables = [
            Table("waterIntakes"),
            Table("wineIntakes"),
            Table("coffeeIntakes"),
            Table("milkTeaIntakes"),
            Table("milkIntakes"),
            Table("otherIntakes")
        ]
        
        // 定义记录总数
        var totalCount = 0

        // 遍历每个表
        for table in tables {
            let dateColumn = Expression<String>("date")
            
            do {
                // 查询特定日期的记录数
                let query = table.filter(dateColumn == date).count
                let count = try db?.scalar(query) ?? 0
                totalCount += count
            } catch {
                print("查询 \(table) 表失败: \(error.localizedDescription)")
            }
        }

        return totalCount
    }
    
    //获取从某个日期开始的合环天数
    func getFinishDayFromDate(for startDate: Date) -> Int {
        let calendar = Calendar.current
        var currentDate = startDate
        let today = Date()
        var result = 0
        
        while currentDate <= today {
            if dateHavePlan(for: DateGetDay(date: currentDate)) && (getDateTotalIntake(for: DateGetDay(date: currentDate)) >= getDatePlan(date: DateGetDay(date: currentDate))) {
                result += 1
            }
            
            // 将日期加一天
            if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                currentDate = nextDate
            }
        }
        
        return result
    }
    
    //获取从某个日期开始的平均饮水总量
    func getAvrIntakeFromDate(for startDate: Date) -> Int {
        let calendar = Calendar.current
        var currentDate = startDate
        let today = Date()
        var sum = 0
        var count = 0
        
        while currentDate <= today {
            sum += getDateTotalIntake(for: DateGetDay(date: currentDate))
            count += 1
            
            // 将日期加一天
            if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                currentDate = nextDate
            }
        }
        
        return Int(sum / count)
    }
    
    //获取从某个日期开始的平均饮水量
    func getAvrWaterIntakeFromDate(for startDate: Date) -> Int {
        let calendar = Calendar.current
        var currentDate = startDate
        let today = Date()
        var sum = 0
        var count = 0
        
        while currentDate <= today {
            sum += getDateWaterIntakeSum(from: DateGetDay(date: currentDate))
            count += 1
            
            // 将日期加一天
            if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                currentDate = nextDate
            }
        }
        
        return Int(sum / count)
    }
    
    //获取从某个日期开始的平均饮酒量
    func getAvrWineIntakeFromDate(for startDate: Date) -> Int {
        let calendar = Calendar.current
        var currentDate = startDate
        let today = Date()
        var sum = 0
        var count = 0
        
        while currentDate <= today {
            sum += getDateWineIntake(from: DateGetDay(date: currentDate))
            count += 1
            
            // 将日期加一天
            if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                currentDate = nextDate
            }
        }
        
        return Int(sum / count)
    }
    
    //获取从某个日期开始的平均饮咖啡量
    func getAvrCoffeeIntakeFromDate(for startDate: Date) -> Int {
        let calendar = Calendar.current
        var currentDate = startDate
        let today = Date()
        var sum = 0
        var count = 0
        
        while currentDate <= today {
            sum += getDateCoffeeIntake(from: DateGetDay(date: currentDate))
            count += 1
            
            // 将日期加一天
            if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                currentDate = nextDate
            }
        }
        
        return Int(sum / count)
    }
    
    //获取从某个日期开始的平均饮奶茶量
    func getAvrMilkTeaIntakeFromDate(for startDate: Date) -> Int {
        let calendar = Calendar.current
        var currentDate = startDate
        let today = Date()
        var sum = 0
        var count = 0
        
        while currentDate <= today {
            sum += getDateMilkTeaIntake(from: DateGetDay(date: currentDate))
            count += 1
            
            // 将日期加一天
            if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                currentDate = nextDate
            }
        }
        
        return Int(sum / count)
    }
    
    //获取从某个日期开始的平均饮奶量
    func getAvrMilkIntakeFromDate(for startDate: Date) -> Int {
        let calendar = Calendar.current
        var currentDate = startDate
        let today = Date()
        var sum = 0
        var count = 0
        
        while currentDate <= today {
            sum += getDateMilkIntake(from: DateGetDay(date: currentDate))
            count += 1
            
            // 将日期加一天
            if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                currentDate = nextDate
            }
        }
        
        return Int(sum / count)
    }
    
    //获取从某个日期开始的平均饮其他量
    func getAvrOtherIntakeFromDate(for startDate: Date) -> Int {
        let calendar = Calendar.current
        var currentDate = startDate
        let today = Date()
        var sum = 0
        var count = 0
        
        while currentDate <= today {
            sum += getDateOtherIntake(from: DateGetDay(date: currentDate))
            count += 1
            
            // 将日期加一天
            if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                currentDate = nextDate
            }
        }
        
        return Int(sum / count)
    }
    
    //获取从某个日期开始的平均酒精摄入量
    func getAvrAlcoholIntakeFromDate(for startDate: Date) -> Int {
        let calendar = Calendar.current
        var currentDate = startDate
        let today = Date()
        var sum = 0
        var count = 0
        
        while currentDate <= today {
            sum += getDateAlcoholIntake(from: DateGetDay(date: currentDate))
            count += 1
            
            // 将日期加一天
            if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                currentDate = nextDate
            }
        }
        
        return Int(sum / count)
    }
    
    //获取从某个日期开始的平均咖啡因摄入量
    func getAvrCoffeeineIntakeFromDate(for startDate: Date) -> Int {
        let calendar = Calendar.current
        var currentDate = startDate
        let today = Date()
        var sum = 0
        var count = 0
        
        while currentDate <= today {
            sum += getDateCoffeeineIntake(from: DateGetDay(date: currentDate))
            count += 1
            
            // 将日期加一天
            if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                currentDate = nextDate
            }
        }
        
        return Int(sum / count)
    }
    
    //获取某一天所有的饮水记录(按时间排序)
    func getDateAllIntakes_OrderByTime(for date_: String) -> [(time: String, name: String, intake: String, type: String, brand: String, concentration: String, espressoCount: String, uuid: UUID)] {
        var result: [(time: String, name: String, intake: String, type: String, brand: String, concentration: String, espressoCount: String, uuid: UUID)] = []
        
        //定义所有字段名
        let date = Expression<String>("date")
        let intake = Expression<Int>("intake")
        let type = Expression<String>("type")
        let time = Expression<String>("time")
        let brand = Expression<String>("brand")
        let espressoCount = Expression<Int>("espressoCount")
        let concentration = Expression<Int>("concentration")
        
        //定义所有表名
        let waterIntakes = Table("waterIntakes")
        let wineIntakes = Table("wineIntakes")
        let coffeeIntakes = Table("coffeeIntakes")
        let milkTeaIntakes = Table("milkTeaIntakes")
        let milkIntakes = Table("milkIntakes")
        let otherIntakes = Table("otherIntakes")
        
        //分步处理所有表
        //处理waterIntakes表：
        do{
            let query = waterIntakes.filter(date == date_)
            if let rows = try db?.prepare(query) {
                for row in rows {
                    // 获取时间并提取小时和分钟部分
                    let timeString = row[time]
                    // 提取时间部分 (格式为 "YYYY/MM/DD HH:mm:ss"，我们取 "HH:mm" 部分)
                    let timeComponents = timeString.split(separator: " ")[1].prefix(5) // 取 "HH:mm"
                    // 将 "HH:mm" 作为结果
                    let formattedTime = String(timeComponents)

                    // 构建结果数组
                    result.append((time: formattedTime, name: "水", intake: String(row[intake]), type: "-", brand: "-", concentration: "-", espressoCount: "-", uuid: UUID()))
                }
            }
        } catch {
            print("查询 waterIntakes 表失败: \(error.localizedDescription)")
        }
        //处理wineIntakes表：
        do{
            let query = wineIntakes.filter(date == date_)
            if let rows = try db?.prepare(query) {
                for row in rows {
                    // 获取时间并提取小时和分钟部分
                    let timeString = row[time]
                    // 提取时间部分 (格式为 "YYYY/MM/DD HH:mm:ss"，我们取 "HH:mm" 部分)
                    let timeComponents = timeString.split(separator: " ")[1].prefix(5) // 取 "HH:mm"
                    // 将 "HH:mm" 作为结果
                    let formattedTime = String(timeComponents)
                    
                    var type_ = String(row[type])
                    if type_ == "不选择" {
                        type_ = "-"
                    }
                    
                    result.append((time: formattedTime, name: "酒", intake: String(row[intake]), type: type_, brand: "-", concentration: String(row[concentration]), espressoCount: "-", uuid: UUID()))
                }
            }
        } catch {
            print("查询 wineIntakes 表失败: \(error.localizedDescription)")
        }
        //处理coffeeIntakes表：
        do{
            let query = coffeeIntakes.filter(date == date_)
            if let rows = try db?.prepare(query) {
                for row in rows {
                    // 获取时间并提取小时和分钟部分
                    let timeString = row[time]
                    // 提取时间部分 (格式为 "YYYY/MM/DD HH:mm:ss"，我们取 "HH:mm" 部分)
                    let timeComponents = timeString.split(separator: " ")[1].prefix(5) // 取 "HH:mm"
                    // 将 "HH:mm" 作为结果
                    let formattedTime = String(timeComponents)
                    
                    var type_ = String(row[type])
                    var brand_ = String(row[brand])
                    if type_ == "不选择" {
                        type_ = "-"
                    }
                    if brand_ == "不选择" {
                        brand_ = "-"
                    }
                    
                    result.append((time: formattedTime, name: "咖啡", intake: String(row[intake]), type: type_, brand: brand_, concentration: "-", espressoCount: String(row[espressoCount]), uuid: UUID()))
                }
            }
        } catch {
            print("查询 coffeeIntakes 表失败: \(error.localizedDescription)")
        }
        //处理milkTeaIntakes表：
        do{
            let query = milkTeaIntakes.filter(date == date_)
            if let rows = try db?.prepare(query) {
                for row in rows {
                    // 获取时间并提取小时和分钟部分
                    let timeString = row[time]
                    // 提取时间部分 (格式为 "YYYY/MM/DD HH:mm:ss"，我们取 "HH:mm" 部分)
                    let timeComponents = timeString.split(separator: " ")[1].prefix(5) // 取 "HH:mm"
                    // 将 "HH:mm" 作为结果
                    let formattedTime = String(timeComponents)
                    
                    var brand_ = String(row[brand])
                    if brand_ == "不选择" {
                        brand_ = "-"
                    }
                    
                    result.append((time: formattedTime, name: "奶茶", intake: String(row[intake]), type: "-", brand: brand_, concentration: "-", espressoCount: "-", uuid: UUID()))
                }
            }
        } catch {
            print("查询 milkTeaIntakes 表失败: \(error.localizedDescription)")
        }
        //处理milkIntakes表：
        do{
            let query = milkIntakes.filter(date == date_)
            if let rows = try db?.prepare(query) {
                for row in rows {
                    // 获取时间并提取小时和分钟部分
                    let timeString = row[time]
                    // 提取时间部分 (格式为 "YYYY/MM/DD HH:mm:ss"，我们取 "HH:mm" 部分)
                    let timeComponents = timeString.split(separator: " ")[1].prefix(5) // 取 "HH:mm"
                    // 将 "HH:mm" 作为结果
                    let formattedTime = String(timeComponents)
                    
                    var type_ = String(row[type])
                    if type_ == "不选择" {
                        type_ = "-"
                    }
                    
                    result.append((time: formattedTime, name: "奶", intake: String(row[intake]), type: type_, brand: "-", concentration: "-", espressoCount: "-", uuid: UUID()))
                }
            }
        } catch {
            print("查询 milkIntakes 表失败: \(error.localizedDescription)")
        }
        //处理otherIntakes表：
        do{
            let query = otherIntakes.filter(date == date_)
            if let rows = try db?.prepare(query) {
                for row in rows {
                    // 获取时间并提取小时和分钟部分
                    let timeString = row[time]
                    // 提取时间部分 (格式为 "YYYY/MM/DD HH:mm:ss"，我们取 "HH:mm" 部分)
                    let timeComponents = timeString.split(separator: " ")[1].prefix(5) // 取 "HH:mm"
                    // 将 "HH:mm" 作为结果
                    let formattedTime = String(timeComponents)
                    
                    var type_ = String(row[type])
                    if type_ == "不选择" {
                        type_ = "-"
                    }
                    
                    result.append((time: formattedTime, name: "其他", intake: String(row[intake]), type: type_, brand: "-", concentration: "-", espressoCount: "-", uuid: UUID()))
                }
            }
        } catch {
            print("查询 otherIntakes 表失败: \(error.localizedDescription)")
        }
        
        result = result.sorted(by: { $0.time < $1.time })
        
        return result
    }
    
    //查询某个年份和月份是否含有喝水记录
    func monthHaveRecords(year: Int, month: Int) -> Bool {
        let dates = getMonthAndYearAllDates(inYear: year, month: month)
        var sum = 0
        for date_ in dates {
            let intakes = getDateAllIntakes_GroupByHour(for: DateGetDay(date: date_))
            sum += intakes.count
        }
        
        if sum > 0 {
            return true
        } else {
            return false
        }
    }
    
    //从所有intakes表中获取所有有记录的日期
    func getRecordsAllDatesStringFromIntakes() -> [String] {
        // 定义表
        let waterIntakes = Table("waterIntakes")
        let wineIntakes = Table("wineIntakes")
        let coffeeIntakes = Table("coffeeIntakes")
        let milkTeaIntakes = Table("milkTeaIntakes")
        let milkIntakes = Table("milkIntakes")
        let otherIntakes = Table("otherIntakes")

        // 定义date字段
        let dateColumn = Expression<String>("date")

        // 使用Set来存储唯一的日期
        var uniqueDates = Set<String>()

        // 定义所有需要查询的表
        let tables = [waterIntakes, wineIntakes, coffeeIntakes, milkTeaIntakes, milkIntakes, otherIntakes]

        do {
            for table in tables {
                // 使用group对date进行去重处理
                if let rows = try db?.prepare(table.select(dateColumn).group(dateColumn)) {
                    for row in rows {
                        uniqueDates.insert(row[dateColumn])
                    }
                }
            }
        } catch {
            print("查询日期失败: \(error.localizedDescription)")
        }

        // 将Set转换为数组，并返回
        return Array(uniqueDates)
    }
    
    //从userEverydayPlans表中获取所有有记录的日期
    func getRecordsAllDatesStringFromUserEverydayPlans() -> [String] {
        // 定义表
        let userEverydayPlans = Table("userEverydayPlans")
        
        // 定义date字段
        let dateColumn = Expression<String>("date")
        
        // 使用Set来存储唯一的日期
        var uniqueDates = Set<String>()
        
        do {
            // 使用group对date进行去重处理
            if let rows = try db?.prepare(userEverydayPlans.select(dateColumn).group(dateColumn)) {
                for row in rows {
                    uniqueDates.insert(row[dateColumn])
                }
            }
        } catch {
            print("查询 userEverydayPlans 表的日期失败: \(error.localizedDescription)")
        }
        
        // 将Set转换为数组，并返回
        return Array(uniqueDates)
    }
    
    //获取连续最多的饮水合环天数
    func getMaximumConsecutiveCompletionDay() -> Int {
        let dates = getRecordsAllDatesStringFromIntakes()
        var results: [(String, Bool)] = []
        for date in dates {
            let progress = getDateProgress(date_: date)
            var result: Bool
            if progress >= 1 {
                result = true
            } else {
                result = false
            }
            results.append((date, result))
        }
        
        return maxConsecutiveTruesInConsecutiveDates(results)
    }
    
    //获取连续最多的不喝酒天数
    func getMaximumUnAlcoholDay() -> Int {
        let dates = getRecordsAllDatesStringFromUserEverydayPlans()
        var results: [(String, Bool)] = []
        for date in dates {
            let alcoholIntake = getDateWineIntake(from: date)
            var result: Bool
            if alcoholIntake > 0 {
                result = false
            } else {
                result = true
            }
            results.append((date, result))
        }
        
        return maxConsecutiveTruesInConsecutiveDates(results)
    }
    
    //获取连续最多的不喝咖啡天数
    func getMaximumUnCoffeeineDay() -> Int {
        let dates = getRecordsAllDatesStringFromUserEverydayPlans()
        var results: [(String, Bool)] = []
        for date in dates {
            let coffeeIntake = getDateCoffeeIntake(from: date)
            var result: Bool
            if coffeeIntake > 0 {
                result = false
            } else {
                result = true
            }
            results.append((date, result))
        }
        
        return maxConsecutiveTruesInConsecutiveDates(results)
    }
    
    //获取连续最多的不喝奶茶天数
    func getMaximumUnMilkTeaDay() -> Int {
        let dates = getRecordsAllDatesStringFromUserEverydayPlans()
        var results: [(String, Bool)] = []
        for date in dates {
            let milkTeaIntake = getDateMilkTeaIntake(from: date)
            var result: Bool
            if milkTeaIntake > 0 {
                result = false
            } else {
                result = true
            }
            results.append((date, result))
        }
        
        return maxConsecutiveTruesInConsecutiveDates(results)
    }
    
    //获取连续最多的喝奶天数
    func getMaximumMilkDay() -> Int {
        let dates = getRecordsAllDatesStringFromUserEverydayPlans()
        var results: [(String, Bool)] = []
        for date in dates {
            let milkIntake = getDateMilkIntake(from: date)
            let hasMilk = milkIntakesHasMilkType(for: date)
            var result: Bool
            if milkIntake > 0 && hasMilk == true {
                result = true
            } else {
                result = false
            }
            results.append((date, result))
        }
        
        return maxConsecutiveTruesInConsecutiveDates(results)
    }
    
    //获取连续最多的仅饮水且合环天数
    func getMaximumOnlyWaterDay() -> Int {
        let dates = getRecordsAllDatesStringFromUserEverydayPlans()
        var results: [(String, Bool)] = []
        for date in dates {
            let progress = getDateProgress(date_: date)
            var result: Bool
            if progress >= 1 && getDateWineIntake(from: date) == 0 && getDateCoffeeIntake(from: date) == 0 && getDateMilkTeaIntake(from: date) == 0 && getDateMilkIntake(from: date) == 0 && getDateOtherIntake(from: date) == 0 {
                result = true
            } else {
                result = false
            }
            results.append((date, result))
        }
        
        return maxConsecutiveTruesInConsecutiveDates(results)
    }
    
    //查询某个日期下奶摄入表里是否含有牛奶类型
    private func milkIntakesHasMilkType(for date: String) -> Bool {
        // 定义表
        let milkIntakes = Table("milkIntakes")
        
        // 定义字段
        let dateColumn = Expression<String>("date")
        let typeColumn = Expression<String>("type")
        
        do {
            // 构建查询，查找指定日期且 type 字段为 "牛奶" 的记录
            let query = milkIntakes.filter(dateColumn == date && typeColumn == "牛奶")
            
            // 执行查询并检查是否有任何记录
            if let count = try db?.scalar(query.count), count > 0 {
                return true
            }
        } catch {
            print("查询 milkIntakes 表失败: \(error.localizedDescription)")
        }
        
        return false
    }
    
    // 查找连续日期中连续 true 的最大数量
    func maxConsecutiveTruesInConsecutiveDates(_ data: [(String, Bool)]) -> Int {
        guard !data.isEmpty else { return 0 }

        // 将日期字符串转换为 Date 类型，并按日期排序
        let sortedData = data.compactMap { (dateStr, value) -> (Date, Bool)? in
            guard let date = dateFromString(dateStr) else { return nil }
            return (date, value)
        }.sorted(by: { $0.0 < $1.0 })

        var maxCount = 0
        var currentCount = 0
        var previousDate: Date? = nil

        let calendar = Calendar.current

        for (date, isTrue) in sortedData {
            if let prevDate = previousDate {
                // 检查日期是否连续
                if calendar.isDate(date, inSameDayAs: calendar.date(byAdding: .day, value: 1, to: prevDate)!) {
                    // 如果日期连续，继续计数
                    if isTrue {
                        currentCount += 1
                    } else {
                        currentCount = 0
                    }
                } else {
                    // 日期不连续，重置计数
                    currentCount = isTrue ? 1 : 0
                }
            } else {
                // 处理第一个日期
                currentCount = isTrue ? 1 : 0
            }

            maxCount = max(maxCount, currentCount)
            previousDate = date
        }

        return maxCount
    }
    
    func addICloudAsyncRecord(result_: String, describe_: String, recordID_: String){
        // 定义一个 iCloudAsyncRecord 表
        let iCloudAsyncRecord = Table("iCloudAsyncRecord")
        let date = Expression<String>("date")
        let result = Expression<String>("result")
        let describe = Expression<String>("describe")
        let recordID = Expression<String>("recordID")
        
        do {
            // 如果表不存在则创建表
            try db?.run(iCloudAsyncRecord.create(ifNotExists: true) { table in
                table.column(date)
                table.column(result)
                table.column(describe)
                table.column(recordID)
            })
            
            let insert = iCloudAsyncRecord.insert(date <- getCurrentDateString(), result <- result_, describe <- describe_, recordID <- recordID_)
            try db?.run(insert)
            print("已插入一条同步记录")
        } catch {
            print("插入或更新数据失败: \(error)")
        }
    }
    
    func getLatestRecordIDWithTrueResult() -> String {
        // 定义表
        let iCloudAsyncRecord = Table("iCloudAsyncRecord")
        
        // 定义字段
        let dateColumn = Expression<String>("date")
        let resultColumn = Expression<String>("result")
        let recordIDColumn = Expression<String>("recordID")
        
        do {
            // 构建查询：查找result为"true"的记录，并按date降序排序，限制结果为1
            let query = iCloudAsyncRecord
                .filter(resultColumn == "true")
                .order(dateColumn.desc) // 按日期降序
                .limit(1) // 只取最新的1条
            
            // 执行查询并获取结果
            if let row = try db?.pluck(query) {
                return row[recordIDColumn] // 返回recordID
            }
        } catch {
            print("查询 iCloudAsyncRecord 表失败: \(error.localizedDescription)")
        }
        
        return "-" // 如果没有记录返回 "-"
    }
    
    func getAllICloudAsyncRecords() -> [(time: String, result: String, recordID: String, id: UUID)]{
        // 定义表
        let iCloudAsyncRecord = Table("iCloudAsyncRecord")
        
        // 定义字段
        let dateColumn = Expression<String>("date")
        let resultColumn = Expression<String>("result")
        let recordIDColumn = Expression<String>("recordID")
        
        // 创建结果数组
        var records: [(time: String, result: String, recordID: String, id: UUID)] = []
        
        do {
            // 查询表中的所有记录
            if let rows = try db?.prepare(iCloudAsyncRecord) {
                for row in rows {
                    // 获取date, result, recordID字段值
                    let time = row[dateColumn]
                    let result = row[resultColumn]
                    let recordID = row[recordIDColumn]
                    
                    // 将记录添加到数组中
                    records.append((time: time, result: result, recordID: recordID, id: UUID()))
                }
            }
        } catch {
            print("查询 iCloudAsyncRecord 表失败: \(error.localizedDescription)")
        }
        
        let sortedRecords = records.sorted { $0.time > $1.time }
        
        return sortedRecords
    }
}
