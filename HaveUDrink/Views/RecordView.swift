//
//  RecordView.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/10/13.
//

import SwiftUI
import Charts

struct RecordView: View {
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    
    @State private var navigationTitle = "饮水统计"

    @State private var statisticTypeSelection = ["日统计", "周统计", "月统计", "年统计"]
    @State private var selectedStatisticType = "日统计"
    
    @State private var showDailyRecord = false
    @State private var showMonthlyRecord = false
    @State private var showWeeklyRecord = false
    @State private var showYearlyRecord = false
    @State private var startDate = Date()
    @State private var selectedDate: Date? = Date()
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(.secondarySystemBackground)
                    .ignoresSafeArea()
                
                ScrollView{
                    VStack {
                        SegmentedPicker(
                            selection: $selectedStatisticType,
                            items: $statisticTypeSelection,
                            selectionColor: Color(colorSet)
                        ) { selection in
                            Text(selection)
                        }
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                        
                        Divider()
                        
                        if selectedStatisticType == "日统计" {
                            RecordView_Daily(selectedDate: $selectedDate)
                        } else if selectedStatisticType == "周统计" {
                            RecordView_Weekly()
                        } else if selectedStatisticType == "月统计" {
                            RecordView_Monthly()
                        } else if selectedStatisticType == "年统计" {
                            RecordView_Yearly()
                        }
                    }
                }
                .navigationTitle(navigationTitle)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            Button(action: {
                                if selectedStatisticType == "日统计" {
                                    showDailyRecord = true
                                } else if selectedStatisticType == "周统计" {
                                    startDate = subtractDays(from: Date(), days: 6)!
                                    showWeeklyRecord = true
                                } else if selectedStatisticType == "月统计" {
                                    startDate = subtractDays(from: Date(), days: 29)!
                                    showMonthlyRecord = true
                                } else if selectedStatisticType == "年统计" {
                                    showYearlyRecord = true
                                }
                            }) {
                                Image(systemName: "list.clipboard")
                                    .foregroundColor(Color(colorSet))
                            }
                        }
                    }
    
                    ToolbarItem(placement: .navigationBarLeading) {
                        HStack {
                            NavigationLink(destination: AddAnotherView()){
                                Image(systemName: "plus.square.on.square")
                                    .foregroundColor(Color(colorSet))
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showDailyRecord){
            RecordView_Sheet_DailyRecord(date_: $selectedDate)
        }
        .sheet(isPresented: $showMonthlyRecord){
            RecordView_Sheet_WeeklyAndMonthlyRecord(startDate: $startDate)
        }
        .sheet(isPresented: $showWeeklyRecord){
            RecordView_Sheet_WeeklyAndMonthlyRecord(startDate: $startDate)
        }
        .sheet(isPresented: $showYearlyRecord){
            RecordView_Sheet_YearlyRecord()
        }
    }
}

struct RecordView_Daily: View {
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    
    //@State private var selectedDate: Date? = Date()  // 用于跟踪用户选中的日期
    @Binding var selectedDate: Date?
    @State private var progressData: [Date: Double] = [:]  // 用于存储每个日期的进度数据
    @State private var progress = 0.0
    
    @State private var showDailyRecord = false
    
    let calendar = Calendar.current
    @State private var year = 2024
    @State private var month = 10
    
    let lineWidth: CGFloat = 16
    let ringSize: CGFloat = 135

    var body: some View {
        VStack{
            WaterDatePicker(selectedDate: $selectedDate,
                            progressData: generateSampleProgressData(),
                            month: getCurrentMonth(),
                            year: getCurrentYear())
                .frame(height: 70)  // 控制日历控件的高度
                .padding(.bottom, 5)
            
            Divider()
            
            if DataManager.shared.dateHavePlan(for: DateGetDay(date: selectedDate!)) && DataManager.shared.getDateTotalIntake(for: DateGetDay(date: selectedDate!)) > 0 {
                VStack{
                    HStack{
                        Text("\(DateGetDay2(date: selectedDate!))")
                            .bold()
                            .font(.system(size: 24))
                        Spacer()
                    }
                    .padding(.top)
                    
                    HStack{
                        Spacer()
                        
                        ZStack {
                            // 背景圆环
                            Circle()
                                .stroke(Color(colorSet).opacity(0.15), lineWidth: lineWidth)
                                .frame(width: ringSize, height: ringSize)
                                .shadow(color: Color.gray.opacity(0.15), radius: 15)
                            
                            // 进度圆环
                            Circle()
                                .trim(from: 0, to: progress) // 控制进度
                                .stroke(AngularGradient(gradient: Gradient(colors: [Color(colorSet), Color(colorSet)]), center: .center),
                                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                                .rotationEffect(.degrees(-90)) // 从顶部开始绘制
                                .frame(width: ringSize, height: ringSize)
                                .animation(.easeInOut(duration: 1), value: progress) // 动画效果
                            
                            // 中心文字
                            Text("\(Int(progress * 100))%")
                                .bold()
                                .foregroundColor(Color(colorSet))
                                .font(.custom("GenJyuuGothic-Heavy", size:36))
                        }
                        .padding() // 给外部圆环一些间距，防止裁切
                        .onAppear{
                            withAnimation {
                                progress = DataManager.shared.getDateProgress(date_: DateGetDay(date: selectedDate!))
                            }
                        }
                        .onChange(of: selectedDate) {
                            // 当 selectedDate 改变时，更新 progress
                            if let newDate = selectedDate {
                                withAnimation {
                                    progress = DataManager.shared.getDateProgress(date_: DateGetDay(date: newDate))
                                }
                            }
                        }
                        
                        Spacer()
                        
                        VStack{
                            HStack{
                                Text("实际饮水")
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 14))
                                Spacer()
                            }
                            HStack{
                                Text("\(DataManager.shared.getDateTotalIntake(for: DateGetDay(date: selectedDate!)))ml")
                                    .font(.custom("GenJyuuGothic-Heavy", size:34))
                                    .foregroundStyle(Color(colorSet))
                                Spacer()
                            }
                            .padding(.top, -10)
                            
                            HStack{
                                Text("目标饮水")
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 14))
                                Spacer()
                            }
                            .padding(.top, -20)
                            HStack{
                                Text("\(DataManager.shared.getDatePlan(date: DateGetDay(date: selectedDate!)))ml")
                                    .font(.custom("GenJyuuGothic-Heavy", size:34))
                                    .foregroundStyle(Color(colorSet))
                                Spacer()
                            }
                            .padding(.top, -10)
                        }
                        .padding(.leading)
                    }
                    .padding(.bottom)
                    
                    HStack{
                        Text("饮水统计")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(.bottom, 5)
                    
                    VStack{
                        VStack{
                            let intake = DataManager.shared.getDateTotalIntake(for: DateGetDay(date: selectedDate!))
                            let waterIntake = DataManager.shared.getDateWaterIntakeSum(from: DateGetDay(date: selectedDate!))
                            let percent = Double(waterIntake) / Double(intake) * 100
                            
                            HStack{
                                Image("water")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25)
                                Text("水")
                                    .bold()
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                Text("\(waterIntake)ml · \(Int(percent))%")
                                    .font(.custom("GenJyuuGothic-Heavy", size:18))
                                    .foregroundColor(Color(colorSet))
                            }
                            .padding(.bottom, -3)
                            
                            CustomProgressBar(progress: percent / 100)
                        }
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(.top)
                        
                        VStack{
                            let intake = DataManager.shared.getDateTotalIntake(for: DateGetDay(date: selectedDate!))
                            let wineIntake = DataManager.shared.getDateWineIntake(from: DateGetDay(date: selectedDate!))
                            let percent = Double(wineIntake) / Double(intake) * 100
                            
                            HStack{
                                Image("beer")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25)
                                Text("酒")
                                    .bold()
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                Text("\(wineIntake)ml · \(Int(percent))%")
                                    .font(.custom("GenJyuuGothic-Heavy", size:18))
                                    .foregroundColor(Color(colorSet))
                            }
                            .padding(.bottom, -3)
                            
                            CustomProgressBar(progress: percent / 100)
                        }
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(.top)
                        
                        VStack{
                            let intake = DataManager.shared.getDateTotalIntake(for: DateGetDay(date: selectedDate!))
                            let coffeeIntake = DataManager.shared.getDateCoffeeIntake(from: DateGetDay(date: selectedDate!))
                            let percent = Double(coffeeIntake) / Double(intake) * 100
                            
                            HStack{
                                Image("coffee")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25)
                                Text("咖啡")
                                    .bold()
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                Text("\(coffeeIntake)ml · \(Int(percent))%")
                                    .font(.custom("GenJyuuGothic-Heavy", size:18))
                                    .foregroundColor(Color(colorSet))
                            }
                            .padding(.bottom, -3)
                            
                            CustomProgressBar(progress: percent / 100)
                        }
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(.top)
                        
                        VStack{
                            let intake = DataManager.shared.getDateTotalIntake(for: DateGetDay(date: selectedDate!))
                            let milkTeaIntake = DataManager.shared.getDateMilkTeaIntake(from: DateGetDay(date: selectedDate!))
                            let percent = Double(milkTeaIntake) / Double(intake) * 100
                            
                            HStack{
                                Image("milkTea")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25)
                                Text("奶茶")
                                    .bold()
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                Text("\(milkTeaIntake)ml · \(Int(percent))%")
                                    .font(.custom("GenJyuuGothic-Heavy", size:18))
                                    .foregroundColor(Color(colorSet))
                            }
                            .padding(.bottom, -3)
                            
                            CustomProgressBar(progress: percent / 100)
                        }
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(.top)
                        
                        VStack{
                            let intake = DataManager.shared.getDateTotalIntake(for: DateGetDay(date: selectedDate!))
                            let milkIntake = DataManager.shared.getDateMilkIntake(from: DateGetDay(date: selectedDate!))
                            let percent = Double(milkIntake) / Double(intake) * 100
                            
                            HStack{
                                Image("milk")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25)
                                Text("奶")
                                    .bold()
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                Text("\(milkIntake)ml · \(Int(percent))%")
                                    .font(.custom("GenJyuuGothic-Heavy", size:18))
                                    .foregroundColor(Color(colorSet))
                            }
                            .padding(.bottom, -3)
                            
                            CustomProgressBar(progress: percent / 100)
                        }
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(.top)
                        
                        VStack{
                            let intake = DataManager.shared.getDateTotalIntake(for: DateGetDay(date: selectedDate!))
                            let otherIntake = DataManager.shared.getDateOtherIntake(from: DateGetDay(date: selectedDate!))
                            let percent = Double(otherIntake) / Double(intake) * 100
                            
                            HStack{
                                Image("yinliao")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25)
                                Text("其他")
                                    .bold()
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                Text("\(otherIntake)ml · \(Int(percent))%")
                                    .font(.custom("GenJyuuGothic-Heavy", size:18))
                                    .foregroundColor(Color(colorSet))
                            }
                            .padding(.bottom, -3)
                            
                            CustomProgressBar(progress: percent / 100)
                        }
                        .padding()
                    }
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .background(.white)
                    .cornerRadius(10)
                    .padding(.bottom)
                    
                    HStack{
                        Text("酒精与咖啡因摄入统计")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(.bottom, 5)
                    
                    VStack{
                        let alcoholIntake = DataManager.shared.getDateAlcoholIntake(from: DateGetDay(date: selectedDate!))
                        let coffeeineIntake = DataManager.shared.getDateCoffeeineIntake(from: DateGetDay(date: selectedDate!))
                        
                        HStack{
                            Image("beer")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35)
                            Text("酒精")
                                .font(.system(size: 18))
                                .bold()
                                .padding(.leading, 1)
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            Text("\(alcoholIntake)mg")
                                .font(.custom("GenJyuuGothic-Heavy", size:22))
                                .foregroundColor(Color(colorSet))
                        }
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(.top)
                        
                        HStack{
                            Image("coffee")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35)
                            Text("咖啡因")
                                .font(.system(size: 18))
                                .bold()
                                .padding(.leading, 1)
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            Text("\(coffeeineIntake)mg")
                                .font(.custom("GenJyuuGothic-Heavy", size:22))
                                .foregroundColor(Color(colorSet))
                        }
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(.bottom)
                    }
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .background(.white)
                    .cornerRadius(10)
                    .padding(.bottom)
                    
                    HStack{
                        Text("饮水记录")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(.bottom, 5)
                    
                    Button(action: {
                        showDailyRecord = true
                    }){
                        HStack{
                            Text("查看该日所有饮水记录")
                                .padding(.top)
                                .padding(.bottom)
                                .padding(.leading)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .padding(.trailing)
                        }
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .background(.white)
                        .cornerRadius(10)
                    }
                    .padding(.bottom)
                }
                .padding(.trailing)
                .padding(.leading)
            } else {
                if isFutureDate(selectedDate!) {
                    VStack{
                        HStack{
                            Text("\(DateGetDay2(date: selectedDate!))")
                                .bold()
                                .font(.system(size: 24))
                            Spacer()
                        }
                        .padding(.top)
                        .padding(.leading)
                        
                        Text("当前日期暂无饮水记录")
                            .foregroundStyle(.gray)
                            .font(.system(size: 16))
                            .padding(.top, 200)
                        
                        Spacer()
                    }
                } else {
                    VStack{
                        HStack{
                            Text("\(DateGetDay2(date: selectedDate!))")
                                .bold()
                                .font(.system(size: 24))
                            Spacer()
                        }
                        .padding(.top)
                        .padding(.leading)
                        
                        Text("当前日期无饮水记录")
                            .foregroundStyle(.gray)
                            .font(.system(size: 16))
                            .padding(.top, 200)
                        
                        Spacer()
                    }
                }
            }
        }
        .sheet(isPresented: $showDailyRecord) {
            RecordView_Sheet_DailyRecord(date_: $selectedDate)
        }
        .onAppear{
            year = getCurrentYear()
            month = getCurrentMonth()
        }
    }
    
    // 生成示例进度数据，根据当前月份和年份生成进度条数据
    private func generateSampleProgressData() -> [Date: Double] {
        var progress: [Date: Double] = [:]
        
        let dates = generateDatesForMonth(year: year, month: month)
        for date_ in dates {
            // 随机生成一些进度值，0 到 1 之间
            progress[date_] = DataManager.shared.getDateProgress(date_: DateGetDay(date: date_))
        }
        return progress
    }
    
    // 生成当前月份的所有日期
    private func generateDatesForMonth(year: Int, month: Int) -> [Date] {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        guard let startDate = calendar.date(from: components) else {
            return []
        }
        guard let range = calendar.range(of: .day, in: .month, for: startDate) else {
            return []
        }
        return range.compactMap { day -> Date? in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)
        }
    }
    
    // 格式化日期用于显示
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct RecordView_Weekly: View {
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    @State private var startDate = Date()
    @State private var startDateString = ""
    
    @State private var showWeeklyAndMonthlyRecord = false
    
    @State private var avrWaterIntakePercent = 0.0
    @State private var avrWineIntakePercent = 0.0
    @State private var avrCoffeeIntakePercent = 0.0
    @State private var avrMilkTeaIntakePercent = 0.0
    @State private var avrMilkIntakePercent = 0.0
    @State private var avrOtherIntakePercent = 0.0
    
    @State private var avrIntake = 0
    @State private var avrWaterIntake = 0
    @State private var avrWineIntake = 0
    @State private var avrCoffeeIntake = 0
    @State private var avrMilkTeaIntake = 0
    @State private var avrMilkIntake = 0
    @State private var avrOtherIntake = 0
    
    var body: some View{
        VStack{
            HStack{
                Text("\(startDateString)以来")
                    .bold()
                    .font(.system(size: 24))
                Spacer()
            }
            .padding(.top)
            
            HStack{
                Image("drink1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35)
                    .padding(.leading)
                    .padding(.top)
                    .padding(.bottom)
                Text("平均饮水量")
                    .bold()
                    .font(.system(size: 18))
                    .foregroundStyle(.black)
                
                Spacer()
                
                Text("\(DataManager.shared.getAvrIntakeFromDate(for: startDate))ml")
                    .font(.custom("GenJyuuGothic-Heavy", size:22))
                    .foregroundColor(Color(colorSet))
                    .padding(.trailing)
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .background(.white)
            .cornerRadius(10)
            
            VStack{
                HStack{
                    Image("duigou")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35)
                    Text("饮水合环天数")
                        .bold()
                        .font(.system(size: 18))
                        .foregroundStyle(.black)
                    
                    Spacer()
                    
                    Text("\(DataManager.shared.getFinishDayFromDate(for: startDate))天")
                        .font(.custom("GenJyuuGothic-Heavy", size:22))
                        .foregroundColor(Color(colorSet))
                }
                .padding(.leading)
                .padding(.top)
                .padding(.trailing)
                
                CustomProgressBar(progress: Double(DataManager.shared.getFinishDayFromDate(for: startDate)) / 7)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.bottom)
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .background(.white)
            .cornerRadius(10)
            
            HStack{
                Text("平均饮水统计")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.bottom, 5)
            .padding(.top)
            
            VStack{
                /*
                let avrIntake = DataManager.shared.getAvrIntakeFromDate(for: startDate)
                let avrWaterIntake = DataManager.shared.getAvrWaterIntakeFromDate(for: startDate)
                let avrWineIntake = DataManager.shared.getAvrWineIntakeFromDate(for: startDate)
                let avrCoffeeIntake = DataManager.shared.getAvrCoffeeIntakeFromDate(for: startDate)
                let avrMilkTeaIntake = DataManager.shared.getAvrMilkTeaIntakeFromDate(for: startDate)
                let avrMilkIntake = DataManager.shared.getAvrMilkIntakeFromDate(for: startDate)
                let avrOtherIntake = DataManager.shared.getAvrOtherIntakeFromDate(for: startDate)
                 */
                
                VStack{
                    HStack{
                        Image("water")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25)
                        Text("水")
                            .bold()
                            .foregroundStyle(.black)
                        
                        Spacer()
                        
                        Text("\(avrWaterIntake)ml · \(Int(avrWaterIntakePercent))%")
                            .font(.custom("GenJyuuGothic-Heavy", size:18))
                            .foregroundColor(Color(colorSet))
                    }
                    .padding(.bottom, -3)
                    
                    CustomProgressBar(progress: avrWaterIntakePercent / 100)
                }
                .padding(.leading)
                .padding(.trailing)
                .padding(.top)
                .onAppear{
                    if avrIntake != 0 {
                        avrWaterIntakePercent = Double(avrWaterIntake) / Double(avrIntake) * 100
                    }
                }
                
                VStack{
                    HStack{
                        Image("beer")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25)
                        Text("酒")
                            .bold()
                            .foregroundStyle(.black)
                        
                        Spacer()
                        
                        Text("\(avrWineIntake)ml · \(Int(avrWineIntakePercent))%")
                            .font(.custom("GenJyuuGothic-Heavy", size:18))
                            .foregroundColor(Color(colorSet))
                    }
                    .padding(.bottom, -3)
                    
                    CustomProgressBar(progress: avrWineIntakePercent / 100)
                }
                .padding(.leading)
                .padding(.trailing)
                .padding(.top)
                .onAppear{
                    if avrIntake != 0 {
                        avrWineIntakePercent = Double(avrWineIntake) / Double(avrIntake) * 100
                    }
                }
                
                VStack{
                    HStack{
                        Image("coffee")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25)
                        Text("咖啡")
                            .bold()
                            .foregroundStyle(.black)
                        
                        Spacer()
                        
                        Text("\(avrCoffeeIntake)ml · \(Int(avrCoffeeIntakePercent))%")
                            .font(.custom("GenJyuuGothic-Heavy", size:18))
                            .foregroundColor(Color(colorSet))
                    }
                    .padding(.bottom, -3)
                    
                    CustomProgressBar(progress: avrCoffeeIntakePercent / 100)
                }
                .padding(.leading)
                .padding(.trailing)
                .padding(.top)
                .onAppear{
                    if avrIntake != 0 {
                        avrCoffeeIntakePercent = Double(avrCoffeeIntake) / Double(avrIntake) * 100
                    }
                }
                
                VStack{
                    HStack{
                        Image("milkTea")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25)
                        Text("奶茶")
                            .bold()
                            .foregroundStyle(.black)
                        
                        Spacer()
                        
                        Text("\(avrMilkTeaIntake)ml · \(Int(avrMilkTeaIntakePercent))%")
                            .font(.custom("GenJyuuGothic-Heavy", size:18))
                            .foregroundColor(Color(colorSet))
                    }
                    .padding(.bottom, -3)
                    
                    CustomProgressBar(progress: avrMilkTeaIntakePercent / 100)
                }
                .padding(.leading)
                .padding(.trailing)
                .padding(.top)
                .onAppear{
                    if avrIntake != 0 {
                        avrMilkTeaIntakePercent = Double(avrMilkTeaIntake) / Double(avrIntake) * 100
                    }
                }
                
                VStack{
                    HStack{
                        Image("milk")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25)
                        Text("奶")
                            .bold()
                            .foregroundStyle(.black)
                        
                        Spacer()
                        
                        Text("\(avrMilkIntake)ml · \(Int(avrMilkIntakePercent))%")
                            .font(.custom("GenJyuuGothic-Heavy", size:18))
                            .foregroundColor(Color(colorSet))
                    }
                    .padding(.bottom, -3)
                    
                    CustomProgressBar(progress: avrMilkIntakePercent / 100)
                }
                .padding(.leading)
                .padding(.trailing)
                .padding(.top)
                .onAppear{
                    if avrIntake != 0 {
                        avrMilkIntakePercent = Double(avrMilkIntake) / Double(avrIntake) * 100
                    }
                }
                
                VStack{
                    HStack{
                        Image("yinliao")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25)
                        Text("其他")
                            .bold()
                            .foregroundStyle(.black)
                        
                        Spacer()
                        
                        Text("\(avrOtherIntake)ml · \(Int(avrOtherIntakePercent))%")
                            .font(.custom("GenJyuuGothic-Heavy", size:18))
                            .foregroundColor(Color(colorSet))
                    }
                    .padding(.bottom, -3)
                    
                    CustomProgressBar(progress: avrOtherIntakePercent / 100)
                }
                .padding()
                .onAppear{
                    if avrIntake != 0 {
                        avrOtherIntakePercent = Double(avrOtherIntake) / Double(avrIntake) * 100
                    }
                }
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .background(.white)
            .cornerRadius(10)
            
            HStack{
                Text("平均酒精咖啡因摄入统计")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.bottom, 5)
            .padding(.top)
            
            VStack{
                let avrAlcoholIntake = DataManager.shared.getAvrAlcoholIntakeFromDate(for: startDate)
                let avrCoffeeineIntake = DataManager.shared.getAvrCoffeeineIntakeFromDate(for: startDate)
                
                HStack{
                    Image("beer")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35)
                    Text("酒精")
                        .font(.system(size: 18))
                        .bold()
                        .padding(.leading, 1)
                        .foregroundStyle(.black)
                    
                    Spacer()
                    
                    Text("\(avrAlcoholIntake)mg")
                        .font(.custom("GenJyuuGothic-Heavy", size:22))
                        .foregroundColor(Color(colorSet))
                }
                .padding(.leading)
                .padding(.trailing)
                .padding(.top)
                
                HStack{
                    Image("coffee")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35)
                    Text("咖啡因")
                        .font(.system(size: 18))
                        .bold()
                        .padding(.leading, 1)
                        .foregroundStyle(.black)
                    
                    Spacer()
                    
                    Text("\(avrCoffeeineIntake)mg")
                        .font(.custom("GenJyuuGothic-Heavy", size:22))
                        .foregroundColor(Color(colorSet))
                }
                .padding(.leading)
                .padding(.trailing)
                .padding(.bottom)
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .background(.white)
            .cornerRadius(10)
            .padding(.bottom)
            
            HStack{
                Text("饮水记录")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.bottom, 5)
            
            Button(action: {
                showWeeklyAndMonthlyRecord = true
            }){
                HStack{
                    Text("查看7天内所有饮水记录")
                        .padding(.top)
                        .padding(.bottom)
                        .padding(.leading)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .padding(.trailing)
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .background(.white)
                .cornerRadius(10)
            }
            .padding(.bottom)
        }
        .padding(.leading)
        .padding(.trailing)
        .onAppear{
            startDate = subtractDays(from: Date(), days: 6)!
            startDateString = "\(getYear(from: startDate))年\(getMonth(from: startDate))月\(getDay(from: startDate))日"
            
            avrIntake = DataManager.shared.getAvrIntakeFromDate(for: startDate)
            avrWaterIntake = DataManager.shared.getAvrWaterIntakeFromDate(for: startDate)
            avrWineIntake = DataManager.shared.getAvrWineIntakeFromDate(for: startDate)
            avrCoffeeIntake = DataManager.shared.getAvrCoffeeIntakeFromDate(for: startDate)
            avrMilkTeaIntake = DataManager.shared.getAvrMilkTeaIntakeFromDate(for: startDate)
            avrMilkIntake = DataManager.shared.getAvrMilkIntakeFromDate(for: startDate)
            avrOtherIntake = DataManager.shared.getAvrOtherIntakeFromDate(for: startDate)
        }
        .sheet(isPresented: $showWeeklyAndMonthlyRecord){
            RecordView_Sheet_WeeklyAndMonthlyRecord(startDate: $startDate)
        }
    }
}

struct RecordView_Monthly: View {
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    @State private var startDate = Date()
    @State private var startDateString = ""
    
    @State private var showWeeklyAndMonthlyRecord = false
    
    @State private var avrWaterIntakePercent = 0.0
    @State private var avrWineIntakePercent = 0.0
    @State private var avrCoffeeIntakePercent = 0.0
    @State private var avrMilkTeaIntakePercent = 0.0
    @State private var avrMilkIntakePercent = 0.0
    @State private var avrOtherIntakePercent = 0.0
    
    @State private var avrIntake = 0
    @State private var avrWaterIntake = 0
    @State private var avrWineIntake = 0
    @State private var avrCoffeeIntake = 0
    @State private var avrMilkTeaIntake = 0
    @State private var avrMilkIntake = 0
    @State private var avrOtherIntake = 0
    
    var body: some View{
        VStack{
            HStack{
                Text("\(startDateString)以来")
                    .bold()
                    .font(.system(size: 24))
                Spacer()
            }
            .padding(.top)
            
            HStack{
                Image("drink1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35)
                    .padding(.leading)
                    .padding(.top)
                    .padding(.bottom)
                Text("平均饮水量")
                    .bold()
                    .font(.system(size: 18))
                    .foregroundStyle(.black)
                
                Spacer()
                
                Text("\(DataManager.shared.getAvrIntakeFromDate(for: startDate))ml")
                    .font(.custom("GenJyuuGothic-Heavy", size:22))
                    .foregroundColor(Color(colorSet))
                    .padding(.trailing)
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .background(.white)
            .cornerRadius(10)
            
            VStack{
                HStack{
                    Image("duigou")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35)
                    Text("饮水合环天数")
                        .bold()
                        .font(.system(size: 18))
                        .foregroundStyle(.black)
                    
                    Spacer()
                    
                    Text("\(DataManager.shared.getFinishDayFromDate(for: startDate))天")
                        .font(.custom("GenJyuuGothic-Heavy", size:22))
                        .foregroundColor(Color(colorSet))
                }
                .padding(.leading)
                .padding(.top)
                .padding(.trailing)
                
                CustomProgressBar(progress: Double(DataManager.shared.getFinishDayFromDate(for: startDate)) / 30)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.bottom)
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .background(.white)
            .cornerRadius(10)
            
            HStack{
                Text("平均饮水统计")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                Spacer()
            }
            .padding(.bottom, 5)
            .padding(.top)
            
            VStack{
                VStack{
                    HStack{
                        Image("water")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25)
                        Text("水")
                            .bold()
                            .foregroundStyle(.black)
                        
                        Spacer()
                        
                        Text("\(avrWaterIntake)ml · \(Int(avrWaterIntakePercent))%")
                            .font(.custom("GenJyuuGothic-Heavy", size:18))
                            .foregroundColor(Color(colorSet))
                    }
                    .padding(.bottom, -3)
                    
                    CustomProgressBar(progress: avrWaterIntakePercent / 100)
                }
                .padding(.leading)
                .padding(.trailing)
                .padding(.top)
                .onAppear{
                    if avrIntake != 0 {
                        avrWaterIntakePercent = Double(avrWaterIntake) / Double(avrIntake) * 100
                    }
                }
                
                VStack{
                    HStack{
                        Image("beer")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25)
                        Text("酒")
                            .bold()
                            .foregroundStyle(.black)
                        
                        Spacer()
                        
                        Text("\(avrWineIntake)ml · \(Int(avrWineIntakePercent))%")
                            .font(.custom("GenJyuuGothic-Heavy", size:18))
                            .foregroundColor(Color(colorSet))
                    }
                    .padding(.bottom, -3)
                    
                    CustomProgressBar(progress: avrWineIntakePercent / 100)
                }
                .padding(.leading)
                .padding(.trailing)
                .padding(.top)
                .onAppear{
                    if avrIntake != 0 {
                        avrWineIntakePercent = Double(avrWineIntake) / Double(avrIntake) * 100
                    }
                }
                
                VStack{
                    HStack{
                        Image("coffee")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25)
                        Text("咖啡")
                            .bold()
                            .foregroundStyle(.black)
                        
                        Spacer()
                        
                        Text("\(avrCoffeeIntake)ml · \(Int(avrCoffeeIntakePercent))%")
                            .font(.custom("GenJyuuGothic-Heavy", size:18))
                            .foregroundColor(Color(colorSet))
                    }
                    .padding(.bottom, -3)
                    
                    CustomProgressBar(progress: avrCoffeeIntakePercent / 100)
                }
                .padding(.leading)
                .padding(.trailing)
                .padding(.top)
                .onAppear{
                    if avrIntake != 0 {
                        avrCoffeeIntakePercent = Double(avrCoffeeIntake) / Double(avrIntake) * 100
                    }
                }
                
                VStack{
                    HStack{
                        Image("milkTea")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25)
                        Text("奶茶")
                            .bold()
                            .foregroundStyle(.black)
                        
                        Spacer()
                        
                        Text("\(avrMilkTeaIntake)ml · \(Int(avrMilkTeaIntakePercent))%")
                            .font(.custom("GenJyuuGothic-Heavy", size:18))
                            .foregroundColor(Color(colorSet))
                    }
                    .padding(.bottom, -3)
                    
                    CustomProgressBar(progress: avrMilkTeaIntakePercent / 100)
                }
                .padding(.leading)
                .padding(.trailing)
                .padding(.top)
                .onAppear{
                    if avrIntake != 0 {
                        avrMilkTeaIntakePercent = Double(avrMilkTeaIntake) / Double(avrIntake) * 100
                    }
                }
                
                VStack{
                    HStack{
                        Image("milk")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25)
                        Text("奶")
                            .bold()
                            .foregroundStyle(.black)
                        
                        Spacer()
                        
                        Text("\(avrMilkIntake)ml · \(Int(avrMilkIntakePercent))%")
                            .font(.custom("GenJyuuGothic-Heavy", size:18))
                            .foregroundColor(Color(colorSet))
                    }
                    .padding(.bottom, -3)
                    
                    CustomProgressBar(progress: avrMilkIntakePercent / 100)
                }
                .padding(.leading)
                .padding(.trailing)
                .padding(.top)
                .onAppear{
                    if avrIntake != 0 {
                        avrMilkIntakePercent = Double(avrMilkIntake) / Double(avrIntake) * 100
                    }
                }
                
                VStack{
                    HStack{
                        Image("yinliao")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25)
                        Text("其他")
                            .bold()
                            .foregroundStyle(.black)
                        
                        Spacer()
                        
                        Text("\(avrOtherIntake)ml · \(Int(avrOtherIntakePercent))%")
                            .font(.custom("GenJyuuGothic-Heavy", size:18))
                            .foregroundColor(Color(colorSet))
                    }
                    .padding(.bottom, -3)
                    
                    CustomProgressBar(progress: avrOtherIntakePercent / 100)
                }
                .padding()
                .onAppear{
                    if avrIntake != 0 {
                        avrOtherIntakePercent = Double(avrOtherIntake) / Double(avrIntake) * 100
                    }
                }
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .background(.white)
            .cornerRadius(10)
            
            HStack{
                Text("平均酒精咖啡因摄入统计")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.bottom, 5)
            .padding(.top)
            
            VStack{
                let avrAlcoholIntake = DataManager.shared.getAvrAlcoholIntakeFromDate(for: startDate)
                let avrCoffeeineIntake = DataManager.shared.getAvrCoffeeineIntakeFromDate(for: startDate)
                
                HStack{
                    Image("beer")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35)
                    Text("酒精")
                        .font(.system(size: 18))
                        .bold()
                        .padding(.leading, 1)
                        .foregroundStyle(.black)
                    
                    Spacer()
                    
                    Text("\(avrAlcoholIntake)mg")
                        .font(.custom("GenJyuuGothic-Heavy", size:22))
                        .foregroundColor(Color(colorSet))
                }
                .padding(.leading)
                .padding(.trailing)
                .padding(.top)
                
                HStack{
                    Image("coffee")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35)
                    Text("咖啡因")
                        .font(.system(size: 18))
                        .bold()
                        .padding(.leading, 1)
                        .foregroundStyle(.black)
                    
                    Spacer()
                    
                    Text("\(avrCoffeeineIntake)mg")
                        .font(.custom("GenJyuuGothic-Heavy", size:22))
                        .foregroundColor(Color(colorSet))
                }
                .padding(.leading)
                .padding(.trailing)
                .padding(.bottom)
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .background(.white)
            .cornerRadius(10)
            .padding(.bottom)
            
            HStack{
                Text("饮水记录")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.bottom, 5)
            
            Button(action: {
                showWeeklyAndMonthlyRecord = true
            }){
                HStack{
                    Text("查看30天内所有饮水记录")
                        .padding(.top)
                        .padding(.bottom)
                        .padding(.leading)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .padding(.trailing)
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .background(.white)
                .cornerRadius(10)
            }
            .padding(.bottom)
        }
        .padding(.leading)
        .padding(.trailing)
        .onAppear{
            startDate = subtractDays(from: Date(), days: 29)!
            startDateString = "\(getYear(from: startDate))年\(getMonth(from: startDate))月\(getDay(from: startDate))日"
            
            avrIntake = DataManager.shared.getAvrIntakeFromDate(for: startDate)
            avrWaterIntake = DataManager.shared.getAvrWaterIntakeFromDate(for: startDate)
            avrWineIntake = DataManager.shared.getAvrWineIntakeFromDate(for: startDate)
            avrCoffeeIntake = DataManager.shared.getAvrCoffeeIntakeFromDate(for: startDate)
            avrMilkTeaIntake = DataManager.shared.getAvrMilkTeaIntakeFromDate(for: startDate)
            avrMilkIntake = DataManager.shared.getAvrMilkIntakeFromDate(for: startDate)
            avrOtherIntake = DataManager.shared.getAvrOtherIntakeFromDate(for: startDate)
        }
        .sheet(isPresented: $showWeeklyAndMonthlyRecord){
            RecordView_Sheet_WeeklyAndMonthlyRecord(startDate: $startDate)
        }
    }
}

struct RecordView_Yearly: View {
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    @State private var startDate = Date()
    @State private var startDateString = ""
    
    @State private var showYearlyRecord = false
    
    var body: some View{
        VStack{
            HStack{
                Text("\(startDateString)以来")
                    .bold()
                    .font(.system(size: 24))
                Spacer()
            }
            .padding(.top)
            
            HStack{
                Image("drink1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35)
                    .padding(.leading)
                    .padding(.top)
                    .padding(.bottom)
                Text("平均饮水量")
                    .bold()
                    .font(.system(size: 18))
                    .foregroundStyle(.black)
                
                Spacer()
                
                Text("\(DataManager.shared.getAvrIntakeFromDate(for: startDate))ml")
                    .font(.custom("GenJyuuGothic-Heavy", size:22))
                    .foregroundColor(Color(colorSet))
                    .padding(.trailing)
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .background(.white)
            .cornerRadius(10)
            
            VStack{
                HStack{
                    Image("duigou")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35)
                    Text("饮水合环天数")
                        .bold()
                        .font(.system(size: 18))
                        .foregroundStyle(.black)
                    
                    Spacer()
                    
                    Text("\(DataManager.shared.getFinishDayFromDate(for: startDate))天")
                        .font(.custom("GenJyuuGothic-Heavy", size:22))
                        .foregroundColor(Color(colorSet))
                }
                .padding(.leading)
                .padding(.top)
                .padding(.trailing)
                
                CustomProgressBar(progress: Double(DataManager.shared.getFinishDayFromDate(for: startDate)) / 365)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.bottom)
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .background(.white)
            .cornerRadius(10)
            
            HStack{
                Text("平均饮水统计")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.bottom, 5)
            .padding(.top)
            
            VStack{
                let avrIntake = DataManager.shared.getAvrIntakeFromDate(for: startDate)
                let avrWaterIntake = DataManager.shared.getAvrWaterIntakeFromDate(for: startDate)
                let avrWineIntake = DataManager.shared.getAvrWineIntakeFromDate(for: startDate)
                let avrCoffeeIntake = DataManager.shared.getAvrCoffeeIntakeFromDate(for: startDate)
                let avrMilkTeaIntake = DataManager.shared.getAvrMilkTeaIntakeFromDate(for: startDate)
                let avrMilkIntake = DataManager.shared.getAvrMilkIntakeFromDate(for: startDate)
                let avrOtherIntake = DataManager.shared.getAvrOtherIntakeFromDate(for: startDate)
                
                VStack{
                    if avrIntake > 0 {
                        let percent = Double(avrWaterIntake) / Double(avrIntake) * 100
                        HStack{
                            Image("water")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25)
                            Text("水")
                                .bold()
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            Text("\(avrWaterIntake)ml · \(Int(percent))%")
                                .font(.custom("GenJyuuGothic-Heavy", size:18))
                                .foregroundColor(Color(colorSet))
                        }
                        .padding(.bottom, -3)
                        
                        CustomProgressBar(progress: percent / 100)
                    } else {
                        HStack{
                            Image("water")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25)
                            Text("水")
                                .bold()
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            Text("0ml · 0%")
                                .font(.custom("GenJyuuGothic-Heavy", size:18))
                                .foregroundColor(Color(colorSet))
                        }
                        .padding(.bottom, -3)
                        
                        CustomProgressBar(progress: 0)
                    }
                }
                .padding(.leading)
                .padding(.trailing)
                .padding(.top)
                
                VStack{
                    if avrIntake > 0 {
                        let percent = Double(avrWineIntake) / Double(avrIntake) * 100
                        
                        HStack{
                            Image("beer")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25)
                            Text("酒")
                                .bold()
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            Text("\(avrWineIntake)ml · \(Int(percent))%")
                                .font(.custom("GenJyuuGothic-Heavy", size:18))
                                .foregroundColor(Color(colorSet))
                        }
                        .padding(.bottom, -3)
                        
                        CustomProgressBar(progress: percent / 100)
                    } else {
                        HStack{
                            Image("beer")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25)
                            Text("酒")
                                .bold()
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            Text("0ml · 0%")
                                .font(.custom("GenJyuuGothic-Heavy", size:18))
                                .foregroundColor(Color(colorSet))
                        }
                        .padding(.bottom, -3)
                        
                        CustomProgressBar(progress: 0)
                    }
                }
                .padding(.leading)
                .padding(.trailing)
                .padding(.top)
                
                VStack{
                    if avrIntake > 0 {
                        let percent = Double(avrCoffeeIntake) / Double(avrIntake) * 100
                        
                        HStack{
                            Image("coffee")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25)
                            Text("咖啡")
                                .bold()
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            Text("\(avrCoffeeIntake)ml · \(Int(percent))%")
                                .font(.custom("GenJyuuGothic-Heavy", size:18))
                                .foregroundColor(Color(colorSet))
                        }
                        .padding(.bottom, -3)
                        
                        CustomProgressBar(progress: percent / 100)
                    } else {
                        HStack{
                            Image("coffee")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25)
                            Text("咖啡")
                                .bold()
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            Text("0ml · 0%")
                                .font(.custom("GenJyuuGothic-Heavy", size:18))
                                .foregroundColor(Color(colorSet))
                        }
                        .padding(.bottom, -3)
                        
                        CustomProgressBar(progress: 0)
                    }
                }
                .padding(.leading)
                .padding(.trailing)
                .padding(.top)
                
                VStack{
                    if avrIntake > 0 {
                        let percent = Double(avrMilkTeaIntake) / Double(avrIntake) * 100
                        
                        HStack{
                            Image("milkTea")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25)
                            Text("奶茶")
                                .bold()
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            Text("\(avrMilkTeaIntake)ml · \(Int(percent))%")
                                .font(.custom("GenJyuuGothic-Heavy", size:18))
                                .foregroundColor(Color(colorSet))
                        }
                        .padding(.bottom, -3)
                        
                        CustomProgressBar(progress: percent / 100)
                    } else {
                        HStack{
                            Image("milkTea")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25)
                            Text("奶茶")
                                .bold()
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            Text("0ml · 0%")
                                .font(.custom("GenJyuuGothic-Heavy", size:18))
                                .foregroundColor(Color(colorSet))
                        }
                        .padding(.bottom, -3)
                        
                        CustomProgressBar(progress: 0)
                    }
                }
                .padding(.leading)
                .padding(.trailing)
                .padding(.top)
                
                VStack{
                    if avrIntake > 0 {
                        let percent = Double(avrMilkIntake) / Double(avrIntake) * 100
                        
                        HStack{
                            Image("milk")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25)
                            Text("奶")
                                .bold()
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            Text("\(avrMilkIntake)ml · \(Int(percent))%")
                                .font(.custom("GenJyuuGothic-Heavy", size:18))
                                .foregroundColor(Color(colorSet))
                        }
                        .padding(.bottom, -3)
                        
                        CustomProgressBar(progress: percent / 100)
                    } else {
                        HStack{
                            Image("milk")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25)
                            Text("奶")
                                .bold()
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            Text("0ml · 0%")
                                .font(.custom("GenJyuuGothic-Heavy", size:18))
                                .foregroundColor(Color(colorSet))
                        }
                        .padding(.bottom, -3)
                        
                        CustomProgressBar(progress: 0)
                    }
                }
                .padding(.leading)
                .padding(.trailing)
                .padding(.top)
                
                VStack{
                    if avrIntake > 0 {
                        let percent = Double(avrOtherIntake) / Double(avrIntake) * 100
                        
                        HStack{
                            Image("yinliao")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25)
                            Text("其他")
                                .bold()
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            Text("\(avrOtherIntake)ml · \(Int(percent))%")
                                .font(.custom("GenJyuuGothic-Heavy", size:18))
                                .foregroundColor(Color(colorSet))
                        }
                        .padding(.bottom, -3)
                        
                        CustomProgressBar(progress: percent / 100)
                    } else {
                        HStack{
                            Image("yinliao")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25)
                            Text("其他")
                                .bold()
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            Text("0ml · 0%")
                                .font(.custom("GenJyuuGothic-Heavy", size:18))
                                .foregroundColor(Color(colorSet))
                        }
                        .padding(.bottom, -3)
                        
                        CustomProgressBar(progress: 0)
                    }
                }
                .padding()
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .background(.white)
            .cornerRadius(10)
            
            HStack{
                Text("平均酒精咖啡因摄入统计")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.bottom, 5)
            .padding(.top)
            
            VStack{
                let avrAlcoholIntake = DataManager.shared.getAvrAlcoholIntakeFromDate(for: startDate)
                let avrCoffeeineIntake = DataManager.shared.getAvrCoffeeineIntakeFromDate(for: startDate)
                
                HStack{
                    Image("beer")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35)
                    Text("酒精")
                        .font(.system(size: 18))
                        .bold()
                        .padding(.leading, 1)
                        .foregroundStyle(.black)
                    
                    Spacer()
                    
                    Text("\(avrAlcoholIntake)mg")
                        .font(.custom("GenJyuuGothic-Heavy", size:22))
                        .foregroundColor(Color(colorSet))
                }
                .padding(.leading)
                .padding(.trailing)
                .padding(.top)
                
                HStack{
                    Image("coffee")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35)
                    Text("咖啡因")
                        .font(.system(size: 18))
                        .bold()
                        .padding(.leading, 1)
                        .foregroundStyle(.black)
                    
                    Spacer()
                    
                    Text("\(avrCoffeeineIntake)mg")
                        .font(.custom("GenJyuuGothic-Heavy", size:22))
                        .foregroundColor(Color(colorSet))
                }
                .padding(.leading)
                .padding(.trailing)
                .padding(.bottom)
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .background(.white)
            .cornerRadius(10)
            .padding(.bottom)
            
            HStack{
                Text("饮水记录")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.bottom, 5)
            
            Button(action: {
                showYearlyRecord = true
            }){
                HStack{
                    Text("查看365天内所有饮水记录")
                        .padding(.top)
                        .padding(.bottom)
                        .padding(.leading)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .padding(.trailing)
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .background(.white)
                .cornerRadius(10)
            }
            .padding(.bottom)
        }
        .padding(.leading)
        .padding(.trailing)
        .onAppear{
            startDate = subtractDays(from: Date(), days: 364)!
            startDateString = "\(getYear(from: startDate))年\(getMonth(from: startDate))月\(getDay(from: startDate))日"
        }
        .sheet(isPresented: $showYearlyRecord){
            RecordView_Sheet_YearlyRecord()
        }
    }
}

private struct CustomProgressBar: View {
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    var progress: Double // 进度值，范围从 0.0 到 1.0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if progress < 0.99 {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(Color.gray.opacity(0.1)) // 背景条
                        .frame(height: 20)
                    
                    HStack{
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color(colorSet)) // 进度条颜色
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            .frame(width: geometry.size.width * CGFloat(progress), height: 20)
                            .animation(.easeInOut(duration: 0.5), value: progress) // 动画效果
                        Spacer()
                    }
                } else {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(Color(colorSet)) // 背景条
                        .frame(height: 20)
                }
            }
        }
        .frame(height: 25) // 整个控件的高度
    }
}


#Preview {
    RecordView()
}
