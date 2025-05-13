//
//  DrinkView.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/10/10.
//

import SwiftUI

struct DrinkView: View {
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    @AppStorage("gender") private var gender = 0.0
    @AppStorage("weight") private var weight = 50.0
    @AppStorage("age") private var age = 25.0
    @AppStorage("athlete") private var athlete = 0.0
    @AppStorage("activityIntensity") private var acticityIntensity = 1.2
    @AppStorage("getupTime") private var getupTime = "00:00"
    @AppStorage("sleepTime") private var sleepTime = "00:00"
    @AppStorage("remindTime") private var remindTime = 15
    @AppStorage("firstUse") private var firstUse = true
    
    @State private var dayTemprature_ = ""
    @State private var nightTemprature_ = ""
    @State private var nowSD_ = ""
    @State private var city_ = ""
    @State private var code_ = ""
    @State private var avrTemprature = 0.0
    @State private var avrSD = 0.0
    @State private var navigationTitle = "饮水圆环"
    
    @State private var showChangeIntake = false
    @State private var showSlider = false
    @State private var changeIntakeButtonTitle = "调整"
    @State private var intake = 0
    @State private var nowIntake = 0
    @State private var showAddIntake = false
    @State private var showDailyRecord = false
    @State private var showTargetDescribe = false
    @State private var showComplete = false
    @State private var nowDate: Date? = Date()
    @State private var nextDrinkTime = "00:00"
    @State private var nextIntake = 0
    @State private var showNext = false
    
    @State private var progress: CGFloat = 0 // 模拟的进度
    let lineWidth: CGFloat = 20
    let ringSize: CGFloat = 200
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(.secondarySystemBackground)
                    .ignoresSafeArea()
                
                VStack{
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color(colorSet).opacity(0.15), Color.clear]),
                                             startPoint: .top,
                                             endPoint: .bottom))
                        .frame(height: 500)
                        .ignoresSafeArea(edges: .top) // 确保模糊区域覆盖灵动岛
                    Spacer()
                }
                
                ScrollView{
                    VStack{
                        ZStack {
                            // 背景圆环
                            Circle()
                                .stroke(Color(colorSet).opacity(0.15), lineWidth: lineWidth)
                                .frame(width: ringSize, height: ringSize)
                                .shadow(color: Color.gray.opacity(0.3), radius: 15)
                            
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
                                .font(.custom("GenJyuuGothic-Heavy", size:46))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // 确保父视图有足够的空间
                        .padding() // 给外部圆环一些间距，防止裁切
                        .padding(.top)
                        
                        Text("\(nowIntake)ml")
                            .font(.custom("GenJyuuGothic-Heavy", size:46))
                            .foregroundColor(Color(colorSet))
                        if nowIntake >= intake {
                            HStack(alignment: .top){
                                Text("今日已合环")
                                    .padding(.bottom)
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        showComplete.toggle()
                                        //navigationTitle = ""
                                    }
                                }){
                                    Image(systemName: "info.circle")
                                        .foregroundColor(Color(colorSet))
                                }
                            }
                        } else {
                            Text("今日已饮水")
                                .padding(.bottom)
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                        }
                        
                        if showNext {
                            HStack{
                                Text("下次饮水")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                            .padding(.bottom, 5)
                            
                            HStack{
                                Image(systemName: "clock.badge.checkmark.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 35)
                                    .foregroundColor(Color(colorSet))
                                    .padding(.leading)
                                    .padding(.bottom)
                                    .padding(.top)
                                
                                Text("\(nextDrinkTime)")
                                    .bold()
                                    .font(.custom("GenJyuuGothic-Medium", size:18))
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Text("\(nextIntake)ml")
                                    .font(.custom("GenJyuuGothic-Heavy", size:22))
                                    .padding(.trailing)
                                    .foregroundColor(Color(colorSet))
                            }
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .cornerRadius(10)
                            .padding(.bottom)
                        }
                        
                        HStack{
                            Text("今日目标")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            Button(action: {
                                showTargetDescribe = true
                            }){
                                Image(systemName: "info.circle")
                                    .foregroundColor(Color(colorSet))
                            }
                            Spacer()
                        }
                        .padding(.bottom, 5)
                        
                        VStack{
                            HStack{
                                Text("\(intake)ml")
                                    .font(.custom("GenJyuuGothic-Heavy", size:30))
                                    .foregroundColor(Color(colorSet))
                                    .padding(.leading)
                                    .padding(.top)
                                    .padding(.bottom)
                                
                                Spacer()
                                
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.3)) {  // 包裹在动画中
                                        showChangeIntake.toggle()
                                        if showChangeIntake {
                                            changeIntakeButtonTitle = "完成"
                                        } else {
                                            changeIntakeButtonTitle = "调整"
                                        }
                                        progress = CGFloat(nowIntake) / CGFloat(intake)
                                        DataManager.shared.addPlan(date_: DateGetDay(date: Date()), intake_: intake)
                                    }
                                    
                                    // 在高度动画结束后延迟显示Slider的渐显效果
                                    if showChangeIntake {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {  // 延迟0.3秒
                                            withAnimation(.easeInOut(duration: 0.2)) {  // 渐显动画
                                                showSlider = true  // 显示Slider
                                            }
                                        }
                                    } else {
                                        // 如果按钮被点击关闭时，立即隐藏Slider
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            showSlider = false
                                        }
                                    }
                                    
                                    let realGetupTime = adjustDateByMinutes(HourAndMinuteToDate(getupTime)!, minutes: 30)
                                    let realSleepTime = adjustDateByMinutes(HourAndMinuteToDate(sleepTime)!, minutes: -30)
                                    let times = remainingReminderTimes(from: generateReminderTimes(start: realGetupTime, end: realSleepTime, interval: remindTime))
                                    
                                    print(DataManager.shared.getDatePlan(date: DateGetDay(date: Date())))
                                    print(DataManager.shared.getDateTotalIntake(for: DateGetDay(date: Date())))
                                    
                                    if times.count > 0 && DataManager.shared.getDateTotalIntake(for: DateGetDay(date: Date())) < DataManager.shared.getDatePlan(date: DateGetDay(date: Date())){
                                        nextDrinkTime = dateToHourAndMinute(times.first!)
                                        nextIntake = Int((DataManager.shared.getDatePlan(date: DateGetDay(date: Date())) - DataManager.shared.getDateTotalIntake(for: DateGetDay(date: Date()))) / times.count)
                                        showNext = true
                                    } else {
                                        showNext = false
                                    }
                                }){
                                    Text(changeIntakeButtonTitle)
                                        .foregroundColor(.white)
                                        .padding(.top, 10)
                                        .padding(.bottom, 10)
                                        .padding(.trailing)
                                        .padding(.leading)
                                        .background(Color(colorSet))
                                        .cornerRadius(10)
                                        .padding()
                                        .bold()
                                }
                            }
                            
                            if showChangeIntake {
                                Slider(
                                    value: Binding(
                                        get: { Double(intake) },  // 将 intake 转换为 Double
                                        set: { intake = Int($0) } // 将 Slider 的值转换为 Int
                                    ),
                                    in: 100...5000, // 设定范围
                                    step: 100  // 每次滑动步长
                                )
                                .padding(.leading)
                                .padding(.trailing)
                                .padding(.bottom)
                                .accentColor(Color(colorSet)) // 修改滑块颜色
                                .frame(width: .infinity) // 修改滑块宽度
                                .opacity(showSlider ? 1 : 0)  // 添加渐显效果
                            }
                        }
                        .frame(maxWidth: .infinity) // 控制VStack的最小高度
                        .background(.white)
                        .cornerRadius(10)
                        .animation(.easeInOut(duration: 0.3), value: showChangeIntake) // 对高度变化应用动画
                        
                        HStack{
                            Text("今日饮水统计")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .padding(.bottom, 5)
                        .padding(.top)
                        
                        HStack{
                            Image("icon_cup")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35)
                                .padding(.leading)
                                .padding(.top)
                                .padding(.bottom)
                            Text("饮水次数")
                                .bold()
                                .font(.system(size: 18))
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            Text("\(DataManager.shared.getTotalDrinkCount(for: DateGetDay(date: Date())))次")
                                .font(.custom("GenJyuuGothic-Heavy", size:22))
                                .padding(.trailing)
                                .foregroundColor(Color(colorSet))
                        }
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .cornerRadius(10)
                        
                        VStack{
                            HStack{
                                Image("water")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 35)
                                Text("水")
                                    .bold()
                                    .font(.system(size: 18))
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                Text("\(DataManager.shared.getDateWaterIntakeSum(from: DateGetDay(date: Date())))ml")
                                    .font(.custom("GenJyuuGothic-Heavy", size:22))
                                    .foregroundColor(Color(colorSet))
                            }
                            .padding(.leading)
                            .padding(.trailing)
                            .padding(.top)
                            
                            HStack{
                                Image("beer")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 35)
                                Text("酒")
                                    .bold()
                                    .font(.system(size: 18))
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                Text("\(DataManager.shared.getDateWineIntake(from: DateGetDay(date: Date())))ml")
                                    .font(.custom("GenJyuuGothic-Heavy", size:22))
                                    .foregroundColor(Color(colorSet))
                            }
                            .padding(.leading)
                            .padding(.trailing)
                            
                            HStack{
                                Image("coffee")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 35)
                                Text("咖啡")
                                    .bold()
                                    .font(.system(size: 18))
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                Text("\(DataManager.shared.getDateCoffeeIntake(from: DateGetDay(date: Date())))ml")
                                    .font(.custom("GenJyuuGothic-Heavy", size:22))
                                    .foregroundColor(Color(colorSet))
                            }
                            .padding(.leading)
                            .padding(.trailing)
                            
                            HStack{
                                Image("milkTea")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 35)
                                Text("奶茶")
                                    .bold()
                                    .font(.system(size: 18))
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                Text("\(DataManager.shared.getDateMilkTeaIntake(from: DateGetDay(date: Date())))ml")
                                    .font(.custom("GenJyuuGothic-Heavy", size:22))
                                    .foregroundColor(Color(colorSet))
                            }
                            .padding(.leading)
                            .padding(.trailing)
                            
                            HStack{
                                Image("milk")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 35)
                                Text("奶")
                                    .bold()
                                    .font(.system(size: 18))
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                Text("\(DataManager.shared.getDateMilkIntake(from: DateGetDay(date: Date())))ml")
                                    .font(.custom("GenJyuuGothic-Heavy", size:22))
                                    .foregroundColor(Color(colorSet))
                            }
                            .padding(.leading)
                            .padding(.trailing)
                            
                            HStack{
                                Image("yinliao")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 35)
                                Text("其他")
                                    .bold()
                                    .font(.system(size: 18))
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                Text("\(DataManager.shared.getDateOtherIntake(from: DateGetDay(date: Date())))ml")
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
                        
                        Button(action: {
                            showDailyRecord = true
                        }){
                            HStack{
                                Text("今日所有饮水记录")
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
                        .padding(.bottom, 110)
                        .padding(.top, 5)
                    }
                    .padding(.leading)
                    .padding(.trailing)
                }
                .navigationTitle(navigationTitle)
                .blur(radius: showAddIntake ? 15 : 0) // 模糊效果
                .opacity(showAddIntake ? 0.5 : 1) // 逐渐消失
                //.opacity(showComplete ? 0.3 : 1)
                //.blur(radius: showComplete ? 5 : 0)
                .animation(.easeInOut(duration: 0.5), value: showAddIntake) // 动画效果
                .disabled(false)
                
                VStack{
                    VStack{
                        if showAddIntake {
                            Group {
                                NavigationLink(destination: AddWaterView()){
                                    HStack{
                                        Image("water")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 40)
                                            .padding(.top)
                                            .padding(.bottom)
                                            .padding(.leading, 20)
                                        Text("饮用水")
                                            .font(.system(size: 20))
                                            .bold()
                                            .foregroundStyle(.black)
                                            .padding(.leading, 1)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.forward")
                                            .foregroundColor(Color(colorSet))
                                            .padding(.trailing, 20)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .background(.white)
                                    .cornerRadius(10)
                                }
                                
                                NavigationLink(destination: AddWineView()){
                                    HStack{
                                        Image("beer")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 40)
                                            .padding(.top)
                                            .padding(.bottom)
                                            .padding(.leading, 20)
                                        Text("酒")
                                            .font(.system(size: 20))
                                            .bold()
                                            .foregroundStyle(.black)
                                            .padding(.leading, 1)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.forward")
                                            .foregroundColor(Color(colorSet))
                                            .padding(.trailing, 20)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .background(.white)
                                    .cornerRadius(10)
                                }
                                
                                NavigationLink(destination: AddCoffeeView()){
                                    HStack{
                                        Image("coffee")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 40)
                                            .padding(.top)
                                            .padding(.bottom)
                                            .padding(.leading, 20)
                                        Text("咖啡")
                                            .font(.system(size: 20))
                                            .bold()
                                            .foregroundStyle(.black)
                                            .padding(.leading, 1)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.forward")
                                            .foregroundColor(Color(colorSet))
                                            .padding(.trailing, 20)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .background(.white)
                                    .cornerRadius(10)
                                }
                                
                                NavigationLink(destination: AddMilkteaView()){
                                    HStack{
                                        Image("milkTea")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 40)
                                            .padding(.top)
                                            .padding(.bottom)
                                            .padding(.leading, 20)
                                        Text("奶茶")
                                            .font(.system(size: 20))
                                            .bold()
                                            .foregroundStyle(.black)
                                            .padding(.leading, 1)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.forward")
                                            .foregroundColor(Color(colorSet))
                                            .padding(.trailing, 20)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .background(.white)
                                    .cornerRadius(10)
                                }
                                
                                NavigationLink(destination: AddMilkView()){
                                    HStack{
                                        Image("milk")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 40)
                                            .padding(.top)
                                            .padding(.bottom)
                                            .padding(.leading, 20)
                                        Text("奶")
                                            .font(.system(size: 20))
                                            .bold()
                                            .foregroundStyle(.black)
                                            .padding(.leading, 1)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.forward")
                                            .foregroundColor(Color(colorSet))
                                            .padding(.trailing, 20)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .background(.white)
                                    .cornerRadius(10)
                                }
                                
                                NavigationLink(destination: AddOtherView()){
                                    HStack{
                                        Image("yinliao")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 40)
                                            .padding(.top)
                                            .padding(.bottom)
                                            .padding(.leading, 20)
                                        Text("其他饮品")
                                            .font(.system(size: 20))
                                            .bold()
                                            .foregroundStyle(.black)
                                            .padding(.leading, 1)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.forward")
                                            .foregroundColor(Color(colorSet))
                                            .padding(.trailing, 20)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .background(.white)
                                    .cornerRadius(10)
                                }
                            }
                        }
                    }
                    .blur(radius: showAddIntake ? 0 : 10) // 清晰效果
                    .opacity(showAddIntake ? 0.9 : 0) // 逐渐显现
                    .animation(.easeInOut(duration: 0.5), value: showAddIntake) // 动画效果
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.top)
                    
                    VStack{
                        Spacer()
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showAddIntake.toggle()
                            }
                            
                            nowIntake = DataManager.shared.getDateTotalIntake(for: DateGetDay(date: Date()))
                            progress = CGFloat(nowIntake) / CGFloat(intake)
                            
                            if showAddIntake {
                                navigationTitle = "添加饮品"
                            } else {
                                navigationTitle = "饮水圆环"
                            }
                            
                            let realGetupTime = adjustDateByMinutes(HourAndMinuteToDate(getupTime)!, minutes: 30)
                            let realSleepTime = adjustDateByMinutes(HourAndMinuteToDate(sleepTime)!, minutes: -30)
                            let times = remainingReminderTimes(from: generateReminderTimes(start: realGetupTime, end: realSleepTime, interval: remindTime))
                            
                            print(DataManager.shared.getDatePlan(date: DateGetDay(date: Date())))
                            print(DataManager.shared.getDateTotalIntake(for: DateGetDay(date: Date())))
                            
                            if times.count > 0 && DataManager.shared.getDateTotalIntake(for: DateGetDay(date: Date())) < DataManager.shared.getDatePlan(date: DateGetDay(date: Date())){
                                nextDrinkTime = dateToHourAndMinute(times.first!)
                                nextIntake = Int((DataManager.shared.getDatePlan(date: DateGetDay(date: Date())) - DataManager.shared.getDateTotalIntake(for: DateGetDay(date: Date()))) / times.count)
                                showNext = true
                            } else {
                                showNext = false
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(Color(colorSet))
                                    .shadow(color: Color.gray.opacity(0.5), radius: 10)
                                
                                Text("+")
                                    .font(.custom("GenJyuuGothic-Heavy", size:50))
                                    .foregroundColor(.white)
                                    .rotationEffect(.degrees(showAddIntake ? 45 : 0)) // 旋转45度
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.bottom)
                }
                //.blur(radius: showComplete ? 5 : 0)
                //.opacity(showComplete ? 0.3 : 1)
                
                
                if showComplete {
                    ZStack{
                        ZStack{
                            Color(.black)
                                .ignoresSafeArea()
                        }
                        .opacity(showComplete ? 0.5 : 0)
                        
                        VStack{
                            HStack{
                                Spacer()
                                
                                Button(action: {
                                    withAnimation(.easeIn(duration: 0.5)) {
                                        showComplete.toggle()
                                        //navigationTitle = "饮水圆环"
                                    }
                                }){
                                    Image(systemName: "xmark.circle")
                                        .foregroundColor(.white)
                                        .font(.system(size: 24))
                                }
                            }
                            .frame(width: 270)
                            .padding(.bottom, 5)
                            
                            CompleteView(showComplete: $showComplete, intake: $intake, navigationTitle: $navigationTitle)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showDailyRecord) {
            RecordView_Sheet_DailyRecord(date_: $nowDate)
        }
        .sheet(isPresented: $showTargetDescribe){
            DrinkView_Sheet_TargetDescribe()
        }
        .onAppear{
            if DataManager.shared.userHavePlan(date_: DateGetDay(date: Date())) {
                //已经有记录了
                intake = DataManager.shared.getTodayIntake(for: DateGetDay(date: Date())) ?? 0
                print("已存在记录：\(intake)")
            } else {
                //还没有记录，需要计算新一天的摄入量，然后插入到其中
                WeatherClient.makeRequest { responseString in
                    if let data = responseString.data(using: .utf8),
                       let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        
                        if let code = WeatherDataParser.getCode(from: json){
                            code_ = code
                        }
                        
                        if code_ == "0" {
                            if let city = WeatherDataParser.getAreaCn(from: json){
                                city_ = city
                            }
                            
                            if let dayTemperature = WeatherDataParser.getDayTemperature(from: json) {
                                dayTemprature_ = dayTemperature
                            }
                            
                            if let nightTemperature = WeatherDataParser.getNightTemperature(from: json) {
                                nightTemprature_ = nightTemperature
                            }
                            
                            if let nowSD = WeatherDataParser.getNowSD(from: json) {
                                nowSD_ = nowSD
                            }
                        } else {
                            city_ = "-"
                            dayTemprature_ = "25"
                            nightTemprature_ = "25"
                            nowSD_ = "70"
                            avrTemprature = 25.0
                            avrSD = 70.0
                        }
                    }
                }
                avrTemprature = Double(Int(dayTemprature_) ?? 25) / Double(Int(nightTemprature_) ?? 25)
                avrSD = Double(Int(nowSD_.replacingOccurrences(of: "%", with: "")) ?? 60)
                
                intake = caculateWaterIntake(pal: acticityIntensity, weight: weight, gender: gender, humidity: avrSD, athlete: athlete, hdi: 0.788, altitude: 100.0, age: age, temprature: avrTemprature)
                DataManager.shared.addPlan(date_: DateGetDay(date: Date()), intake_: intake)
                print("未存在记录：\(intake)")
            }
            
            nowIntake = DataManager.shared.getDateTotalIntake(for: DateGetDay(date: Date()))
            progress = CGFloat(nowIntake) / CGFloat(intake)
            
            let realGetupTime = adjustDateByMinutes(HourAndMinuteToDate(getupTime)!, minutes: 30)
            let realSleepTime = adjustDateByMinutes(HourAndMinuteToDate(sleepTime)!, minutes: -30)
            let times = remainingReminderTimes(from: generateReminderTimes(start: realGetupTime, end: realSleepTime, interval: remindTime))
            if times.count > 0 && DataManager.shared.getDateTotalIntake(for: DateGetDay(date: Date())) < DataManager.shared.getDatePlan(date: DateGetDay(date: Date())){
                nextDrinkTime = dateToHourAndMinute(times.first!)
                nextIntake = Int((DataManager.shared.getDatePlan(date: DateGetDay(date: Date())) - DataManager.shared.getDateTotalIntake(for: DateGetDay(date: Date()))) / times.count)
                showNext = true
            }
        }
    }
}

struct CompleteView: View{
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    
    @Binding var showComplete: Bool
    @Binding var intake: Int
    @Binding var navigationTitle: String
    
    @State private var showingShareSheet = false
    @State private var goalAchievedImage: UIImage? = nil
    
    var body: some View{
        ZStack{
            ZStack{    
                VStack{
                    ZStack{
                        /*
                        Text("CONGRATULATION")
                            .font(.custom("GenJyuuGothic-Heavy", size:16))
                            .foregroundStyle(Color(colorSet))
                            .padding(.top)
                            .opacity(0.2)
                         */
                        
                        Text("\(String(getCurrentYear()))/\(getCurrentMonth())/\(getCurrentDay())")
                            .font(.custom("GenJyuuGothic-Heavy", size:28))
                            .foregroundStyle(Color(colorSet))
                            .padding(.top, 25)
                            .opacity(0.15)
                        
                        Text("饮水合环")
                            .bold()
                            .foregroundColor(.black)
                            .font(.system(size: 24))
                    }
                    
                    ZStack {
                        // 背景圆环
                        Circle()
                            .stroke(Color(colorSet).opacity(0.15), lineWidth: 15)
                            .frame(width: 150, height: 150)
                            .shadow(color: Color.gray.opacity(0.3), radius: 17)
                        
                        // 进度圆环
                        Circle()
                            .trim(from: 0, to: 1) // 控制进度
                            .stroke(AngularGradient(gradient: Gradient(colors: [Color(colorSet), Color(colorSet)]), center: .center),
                                    style: StrokeStyle(lineWidth: 17, lineCap: .round))
                            .rotationEffect(.degrees(-90)) // 从顶部开始绘制
                            .frame(width: 150, height: 150)
                            .animation(.easeInOut(duration: 1), value: 1) // 动画效果
                        
                        // 中心文字
                        Text("100%")
                            .bold()
                            .foregroundColor(Color(colorSet))
                            .font(.custom("GenJyuuGothic-Heavy", size:36))
                    }
                    .padding() // 给外部圆环一些间距，防止裁切
                    .padding(.top)
                    
                    Text("我已达成今日\(intake)ml的饮水目标")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .padding(.top)
                    
                    Button(action: {
                        goalAchievedImage = generateGoalAchievedImage()
                        showingShareSheet = true
                    }){
                        Text("分享")
                            .padding(.top)
                            .padding(.bottom)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            .background(Color(colorSet))
                            .cornerRadius(100)
                            .foregroundColor(.white)
                            .bold()
                    }
                    .padding(.top)
                    .padding(.leading)
                    .padding(.trailing)

                }
            }
            .frame(width: 270, height: 430)
            .background(LinearGradient(gradient: Gradient(colors: [Color(colorSet).opacity(0.15), Color(colorSet).opacity(0.05)]),
                                       startPoint: .top,
                                       endPoint: .bottom))
        }
        .background(.white)
        .cornerRadius(15)
        .blur(radius: showComplete ? 0 : 30)
        .opacity(showComplete ? 1 : 0)
        .shadow(color: Color.gray.opacity(0.2), radius: 10)
        .sheet(isPresented: $showingShareSheet) {
            if let image = goalAchievedImage {
                ShareSheet(activityItems: [image])
            }
        }
    }
    
    
    @MainActor func generateGoalAchievedImage() -> UIImage {
        let renderer = ImageRenderer(content: CompleteView_Generate(showComplete: $showComplete, intake: $intake, navigationTitle: $navigationTitle))
        // 设置渲染器的透明背景
        renderer.scale = UIScreen.main.scale
        renderer.isOpaque = false  // 设置为透明
        
        // 导出PNG格式
        return renderer.uiImage?.pngData().flatMap { UIImage(data: $0) } ?? UIImage()
    }
}

struct CompleteView_Generate: View{
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    
    @Binding var showComplete: Bool
    @Binding var intake: Int
    @Binding var navigationTitle: String
    
    @State private var showingShareSheet = false
    @State private var goalAchievedImage: UIImage? = nil
    
    var body: some View{
        ZStack{
            ZStack{
                VStack{
                    ZStack{
                        /*
                        Text("CONGRATULATION")
                            .font(.custom("GenJyuuGothic-Heavy", size:16))
                            .foregroundStyle(Color(colorSet))
                            .padding(.top)
                            .opacity(0.2)
                         */
                        
                        Text("\(String(getCurrentYear()))/\(getCurrentMonth())/\(getCurrentDay())")
                            .font(.custom("GenJyuuGothic-Heavy", size:24))
                            .foregroundStyle(Color(colorSet))
                            .padding(.top, 25)
                            .opacity(0.15)
                        
                        Text("饮水合环")
                            .bold()
                            .foregroundColor(.black)
                            .font(.system(size: 22))
                    }
                    
                    ZStack {
                        // 背景圆环
                        Circle()
                            .stroke(Color(colorSet).opacity(0.15), lineWidth: 15)
                            .frame(width: 150, height: 150)
                            .shadow(color: Color.gray.opacity(0.3), radius: 17)
                        
                        // 进度圆环
                        Circle()
                            .trim(from: 0, to: 1) // 控制进度
                            .stroke(AngularGradient(gradient: Gradient(colors: [Color(colorSet), Color(colorSet)]), center: .center),
                                    style: StrokeStyle(lineWidth: 17, lineCap: .round))
                            .rotationEffect(.degrees(-90)) // 从顶部开始绘制
                            .frame(width: 150, height: 150)
                            .animation(.easeInOut(duration: 1), value: 1) // 动画效果
                        
                        // 中心文字
                        Text("100%")
                            .bold()
                            .foregroundColor(Color(colorSet))
                            .font(.custom("GenJyuuGothic-Heavy", size:36))
                    }
                    .padding() // 给外部圆环一些间距，防止裁切
                    .padding(.top)
                    
                    Text("我已达成今日\(intake)ml的饮水目标")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .padding(.top)
                    
                    HStack{
                        Image("appstore")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18)
                            .shadow(color: Color.gray.opacity(0.2), radius: 5)
                        Text("App Store搜索“今天喝了么”")
                            .font(.custom("GenJyuuGothic-Bold", size:14))
                            .foregroundColor(Color(colorSet))
                            .shadow(color: Color.gray.opacity(0.2), radius: 5)
                    }
                    .padding(.top, 50)
                }
                .frame(width: 270, height: 430)
                .background(LinearGradient(gradient: Gradient(colors: [Color(colorSet).opacity(0.15), Color(colorSet).opacity(0.05)]),
                                           startPoint: .top,
                                           endPoint: .bottom))
            }
            .background(.white)
            .cornerRadius(15)
            .blur(radius: showComplete ? 0 : 30)
            .opacity(showComplete ? 1 : 0)
            .shadow(color: Color.gray.opacity(0.2), radius: 10)
            .sheet(isPresented: $showingShareSheet) {
                if let image = goalAchievedImage {
                    ShareSheet(activityItems: [image])
                }
            }
        }
        .padding()
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

 #Preview {
 DrinkView()
 }
