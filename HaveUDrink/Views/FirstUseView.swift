//
//  FirstUseView.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/10/10.
//

import SwiftUI

struct FirstUseView: View {
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    @State private var progress: CGFloat = 0
    @State private var showFirstStack = true // 控制第一个VStack的显示
    @State private var showSecondStack = false // 控制第二个VStack的显示

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.secondarySystemBackground)
                    .ignoresSafeArea()
                
                // 第一个 VStack
                VStack {
                    HelloShape()
                        .trim(from: 0.0, to: progress)
                        .stroke(Self.gradient, style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                        .aspectRatio(contentMode: .fit)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .opacity(showFirstStack ? 1 : 0) // 控制第一个VStack的透明度
                .onAppear(perform: animate)
                .onTapGesture {
                    progress = 0
                    animate()
                }
                .padding(.top)
                
                // 第二个 VStack
                if showSecondStack {
                    VStack {
                        Spacer()
                        
                        Image("icon_cup")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .padding(.bottom, 30)
                        
                        Text("欢迎使用今天喝了么")
                            .bold()
                            .font(.system(size: 32))
                            .padding(.bottom, 5)
                        
                        Text("今天喝了么是一款能够提醒你喝水，并记录你每天水饮用量以及咖啡因、酒精等摄入量的App")
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .padding(.bottom, 50)
                        
                        Spacer()
                        
                        NavigationLink(destination: FirstUseView_st1()) {
                            Text("继续")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(colorSet))
                                .cornerRadius(10)
                                .padding()
                        }
                        .padding(.bottom)
                    }
                    .transition(.opacity) // 渐显效果
                }
            }
        }
    }
    
    static let gradient = LinearGradient(
        gradient: Gradient(colors: [.black, .purple, .orange, .red, .pink, .purple, .blue, .black]),
        startPoint: .leading, endPoint: .trailing
    )
    
    func animate() {
        withAnimation(.easeInOut(duration: 5)) {
            progress = 1
        }
        
        // 6秒后渐隐第一个VStack
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            withAnimation(.easeInOut(duration: 1)) {
                showFirstStack = false // 渐隐第一个VStack
            }
            
            // 一秒后渐显第二个VStack
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.easeInOut(duration: 1)) {
                    showSecondStack = true // 渐显第二个VStack
                }
            }
        }
    }
}

struct FirstUseView_st1: View{
    @AppStorage("athlete") private var athlete = 0.0
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    @State private var selectedOption: Int? = nil
    
    var body: some View{
        NavigationStack{
            ZStack{
                Color(.secondarySystemBackground)
                    .ignoresSafeArea()
                
                VStack{
                    Spacer()
                    
                    Image(systemName: "figure.run")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80)
                        .padding(.bottom)
                        .foregroundColor(Color(colorSet))
                    
                    Text("你是否为运动员")
                        .bold()
                        .font(.system(size: 32))
                        .padding(.bottom, 5)
                    
                    Text("运动员与其他人的每日所需饮水量不同")
                        .multilineTextAlignment(.center)
                        .padding(.leading, 30)
                        .padding(.trailing, 30)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .padding(.bottom, 50)
                    
                    Button(action: {
                        selectedOption = 1
                        athlete = 0.0
                    }) {
                        Text("我不是运动员")
                            .foregroundColor(selectedOption == 1 ? Color(colorSet) : Color.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedOption == 1 ? Color(colorSet) : Color.gray, lineWidth: selectedOption == 1 ? 2 : 0)
                            )
                    }
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.bottom, 5)

                    Button(action: {
                        athlete = 1.0
                        selectedOption = 2
                    }) {
                        Text("我是运动员")
                            .foregroundColor(selectedOption == 2 ? Color(colorSet) : Color.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedOption == 2 ? Color(colorSet) : Color.gray, lineWidth: selectedOption == 2 ? 2 : 0)
                            )
                    }
                    .padding(.trailing)
                    .padding(.leading)
                    
                    Spacer()
                    
                    NavigationLink(destination: FirstUseView_st2()){
                        Text("下一步")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(colorSet))
                            .cornerRadius(10)
                            .padding()
                    }
                    .padding(.bottom)
                }
            }
        }
        .onAppear{
            selectedOption = 1
        }
    }
}

struct FirstUseView_st2: View{
    @AppStorage("activityIntensity") private var acticityIntensity = 1.2
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    @State private var selectedOption: Int? = nil
    
    var body: some View{
        NavigationStack{
            ZStack{
                Color(.secondarySystemBackground)
                    .ignoresSafeArea()
                
                VStack{
                    Spacer()
                    
                    Image(systemName: "figure.badminton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80)
                        .padding(.bottom)
                        .foregroundColor(Color(colorSet))
                    
                    Text("你的每日活动强度")
                        .bold()
                        .font(.system(size: 32))
                        .padding(.bottom, 5)
                    
                    Text("活动强度同样会影响你每日的所需饮水量")
                        .multilineTextAlignment(.center)
                        .padding(.leading, 30)
                        .padding(.trailing, 30)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .padding(.bottom, 50)
                    
                    Button(action: {
                        acticityIntensity = 1.2
                        selectedOption = 1
                    }) {
                        VStack{
                            Text("低活动强度")
                                .foregroundColor(selectedOption == 1 ? Color(colorSet) : Color.black)
                            Text("久坐或很少运动")
                                .foregroundStyle(.gray)
                                .font(.system(size: 13))
                                .padding(.top, -6)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedOption == 1 ? Color(colorSet) : Color.gray, lineWidth: selectedOption == 1 ? 2 : 0)
                        )

                    }
                    .padding(.trailing)
                    .padding(.leading)
                    .padding(.bottom, 5)
                    
                    Button(action: {
                        acticityIntensity = 1.5
                        selectedOption = 2
                    }) {
                        VStack{
                            Text("中等活动强度")
                                .foregroundColor(selectedOption == 2 ? Color(colorSet) : Color.black)
                            Text("每周运动3-6小时")
                                .foregroundStyle(.gray)
                                .font(.system(size: 13))
                                .padding(.top, -6)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedOption == 2 ? Color(colorSet) : Color.gray, lineWidth: selectedOption == 2 ? 2 : 0)
                        )

                    }
                    .padding(.trailing)
                    .padding(.leading)
                    .padding(.bottom, 5)
                    
                    Button(action: {
                        acticityIntensity = 2
                        selectedOption = 3
                    }) {
                        VStack{
                            Text("高活动强度")
                                .foregroundColor(selectedOption == 3 ? Color(colorSet) : Color.black)
                            Text("每周运动6小时以上")
                                .foregroundStyle(.gray)
                                .font(.system(size: 13))
                                .padding(.top, -6)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedOption == 3 ? Color(colorSet) : Color.gray, lineWidth: selectedOption == 3 ? 2 : 0)
                        )

                    }
                    .padding(.trailing)
                    .padding(.leading)
                    
                    Spacer()
                    
                    NavigationLink(destination: FirstUseView_st3()){
                        Text("下一步")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(colorSet))
                            .cornerRadius(10)
                            .padding()
                    }
                    .padding(.bottom)
                }
            }
        }
        .onAppear{
            selectedOption = 1
        }
    }
}

struct FirstUseView_st3: View{
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    @AppStorage("gender") private var gender = 1.0
    @State private var genderSelectedOption: Int? = nil
    
    let weights = Array(10...200)
    
    var body: some View{
        NavigationStack{
            ZStack{
                Color(.secondarySystemBackground)
                    .ignoresSafeArea()
                
                VStack{
                    Spacer()
                    
                    Image(systemName: "person.2.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80)
                        .padding(.bottom)
                        .foregroundColor(Color(colorSet))
                    
                    Text("你的性别")
                        .bold()
                        .font(.system(size: 28))
                        .padding(.bottom, 40)
                    
                    HStack{
                        Text("性别")
                            .font(.system(size: 14))
                            .foregroundStyle(.gray)
                        Spacer()
                    }
                    
                    Button(action: {
                        gender = 1.0
                        genderSelectedOption = 1
                    }) {
                        Text("我是男生")
                            .foregroundColor(genderSelectedOption == 1 ? Color(colorSet) : Color.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(genderSelectedOption == 1 ? Color(colorSet) : Color.gray, lineWidth: genderSelectedOption == 1 ? 2 : 0)
                            )
                    }
                    
                    Button(action: {
                        gender = 0.0
                        genderSelectedOption = 2
                    }) {
                        Text("我是女生")
                            .foregroundColor(genderSelectedOption == 2 ? Color(colorSet) : Color.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(genderSelectedOption == 2 ? Color(colorSet) : Color.gray, lineWidth: genderSelectedOption == 2 ? 2 : 0)
                            )
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: FirstUseView_st4()){
                        Text("下一步")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(colorSet))
                            .cornerRadius(10)
                            .padding()
                    }
                    .padding(.bottom)
                }
                .padding(.trailing)
                .padding(.leading)
            }
        }
        .onAppear{
            genderSelectedOption = 1
        }
    }
}

struct FirstUseView_st4: View{
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    @AppStorage("weight") private var weight = 50.0
    @AppStorage("age") private var age = 25.0
    
    var body: some View{
        NavigationStack{
            ZStack{
                Color(.secondarySystemBackground)
                    .ignoresSafeArea()
                
                VStack{
                    Spacer()
                    
                    Image(systemName: "person.text.rectangle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80)
                        .padding(.bottom)
                        .foregroundColor(Color(colorSet))
                    
                    Text("你的体重与年龄")
                        .bold()
                        .font(.system(size: 28))
                        .padding(.bottom, 40)
                    
                    HStack{
                        Text("体重")
                            .font(.system(size: 14))
                            .foregroundStyle(.gray)
                        Spacer()
                    }
                    .padding(.top, 20)
                    
                    VStack{
                        Text("\(weight, specifier: "%.0f")kg")
                            .bold()
                            .padding(.top)
                            .foregroundColor(Color(colorSet))
                            .font(.custom("GenJyuuGothic-Heavy", size:36))
                        
                        Slider(
                            value: $weight,
                            in: 10...200, // 设定范围
                            step: 1  // 每次滑动步长
                        )
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(.bottom)
                        .accentColor(Color(colorSet)) // 修改滑块颜色
                        .frame(width: .infinity) // 修改滑块宽度
                    }
                    .background(.white)
                    .cornerRadius(10)
                    
                    HStack{
                        Text("年龄")
                            .font(.system(size: 14))
                            .foregroundStyle(.gray)
                        Spacer()
                    }
                    .padding(.top, 20)
                    
                    VStack{
                        Text("\(age, specifier: "%.0f")岁")
                            .bold()
                            .padding(.top)
                            .foregroundColor(Color(colorSet))
                            .font(.custom("GenJyuuGothic-Heavy", size:36))
                        
                        Slider(
                            value: $age,
                            in: 1...120, // 设定范围
                            step: 1  // 每次滑动步长
                        )
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(.bottom)
                        .accentColor(Color(colorSet)) // 修改滑块颜色
                        .frame(width: .infinity) // 修改滑块宽度
                    }
                    .background(.white)
                    .cornerRadius(10)
                    
                    Spacer()
                    
                    NavigationLink(destination: FirstUseView_st5()){
                        Text("下一步")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(colorSet))
                            .cornerRadius(10)
                            .padding()
                    }
                    .padding(.bottom)
                }
                .padding(.leading)
                .padding(.trailing)
            }
        }
    }
}

struct FirstUseView_st5: View{
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    @AppStorage("getupTime") private var getupTime = "07:00"
    @AppStorage("sleepTime") private var sleepTime = "22:00"
    @AppStorage("remindTime") private var remindTime = 15
    @AppStorage("openRemind") private var openRemind = true
    
    @State private var getupTime_ = Date()
    @State private var sleepTime_ = Date()
    @State private var selectedOption: Int? = nil
    
    var body: some View{
        NavigationStack{
            ZStack{
                Color(.secondarySystemBackground)
                    .ignoresSafeArea()
                
                VStack{
                    Spacer()
                    
                    Image(systemName: "bell.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80)
                        .padding(.bottom)
                        .foregroundColor(Color(colorSet))
                    
                    Text("设置提醒计划")
                        .bold()
                        .font(.system(size: 28))
                        .padding(.bottom, 40)
                    
                    HStack{
                        Text("起床与就寝时间")
                            .font(.system(size: 14))
                            .foregroundStyle(.gray)
                        Spacer()
                    }
                    .padding(.leading)
                    
                    VStack{
                        HStack{
                            Text("起床时间")
                                .foregroundStyle(Color(colorSet))
                            
                            Spacer()
                            
                            DatePicker("", selection: $getupTime_, displayedComponents: [.hourAndMinute])
                                .labelsHidden()
                        }
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(.top)
                        
                        HStack{
                            Text("就寝时间")
                                .foregroundStyle(Color(colorSet))
                            
                            Spacer()
                            
                            DatePicker("", selection: $sleepTime_, displayedComponents: [.hourAndMinute])
                                .labelsHidden()
                        }
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(.bottom)
                    }
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .cornerRadius(10)
                    .padding(.leading)
                    .padding(.trailing)
                    
                    HStack{
                        Text("提醒间隔")
                            .font(.system(size: 14))
                            .foregroundStyle(.gray)
                        Spacer()
                    }
                    .padding(.leading)
                    .padding(.top, 20)
                    
                    VStack{
                        HStack{
                            Button(action: {
                                remindTime = 15
                                selectedOption = 1
                            }) {
                                Text("15分钟")
                                    .foregroundColor(selectedOption == 1 ? Color(colorSet) : Color.black)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(selectedOption == 1 ? Color(colorSet) : Color.gray, lineWidth: selectedOption == 1 ? 2 : 0)
                                    )
                            }
                            
                            Button(action: {
                                remindTime = 30
                                selectedOption = 2
                            }) {
                                Text("30分钟")
                                    .foregroundColor(selectedOption == 2 ? Color(colorSet) : Color.black)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(selectedOption == 2 ? Color(colorSet) : Color.gray, lineWidth: selectedOption == 2 ? 2 : 0)
                                    )
                            }
                            
                            Button(action: {
                                remindTime = 60
                                selectedOption = 3
                            }) {
                                Text("1小时")
                                    .foregroundColor(selectedOption == 3 ? Color(colorSet) : Color.black)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(selectedOption == 3 ? Color(colorSet) : Color.gray, lineWidth: selectedOption == 3 ? 2 : 0)
                                    )
                            }
                        }
                        
                        HStack{
                            Button(action: {
                                remindTime = 90
                                selectedOption = 4
                            }) {
                                Text("1.5小时")
                                    .foregroundColor(selectedOption == 4 ? Color(colorSet) : Color.black)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(selectedOption == 4 ? Color(colorSet) : Color.gray, lineWidth: selectedOption == 4 ? 2 : 0)
                                    )
                            }
                            
                            Button(action: {
                                remindTime = 120
                                selectedOption = 5
                            }) {
                                Text("2小时")
                                    .foregroundColor(selectedOption == 5 ? Color(colorSet) : Color.black)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(selectedOption == 5 ? Color(colorSet) : Color.gray, lineWidth: selectedOption == 5 ? 2 : 0)
                                    )
                            }
                            
                            Button(action: {
                                remindTime = 180
                                selectedOption = 6
                            }) {
                                Text("3小时")
                                    .foregroundColor(selectedOption == 6 ? Color(colorSet) : Color.black)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(selectedOption == 6 ? Color(colorSet) : Color.gray, lineWidth: selectedOption == 6 ? 2 : 0)
                                    )
                            }
                        }
                    }
                    .padding(.leading)
                    .padding(.trailing)

                    Spacer()
                    
                    NavigationLink(destination: FirstUseView_st6()){
                        Text("下一步")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(colorSet))
                            .cornerRadius(10)
                            .padding()
                    }
                    .padding(.bottom)
                }
            }
        }
        .onAppear{
            selectedOption = 1
        }
        .onChange(of: getupTime_){
            getupTime = dateToHourAndMinute(getupTime_)
            print(getupTime)
        }
        .onChange(of: sleepTime_){
            sleepTime = dateToHourAndMinute(sleepTime_)
            print(sleepTime)
        }
        
    }
}

struct FirstUseView_st6: View{
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    @AppStorage("gender") private var gender = 0.0
    @AppStorage("weight") private var weight = 50.0
    @AppStorage("age") private var age = 25.0
    @AppStorage("athlete") private var athlete = 0.0
    @AppStorage("activityIntensity") private var acticityIntensity = 1.2
    @AppStorage("firstUse") private var firstUse = true
    
    @State private var intake = 0
    
    var body: some View{
        NavigationStack{
            ZStack{
                Color(.secondarySystemBackground)
                    .ignoresSafeArea()
                
                VStack{
                    Spacer()
                    
                    Image(systemName: "drop.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80)
                        .padding(.bottom)
                        .foregroundColor(Color(colorSet))
                    
                    Text("每日预估饮水量")
                        .bold()
                        .font(.system(size: 28))
                        .padding(.bottom, 40)
                    
                    VStack{
                        Text("\(intake)ml")
                            .bold()
                            .padding(.top, 20)
                            .padding(.bottom, 20)
                            .foregroundColor(Color(colorSet))
                            .font(.custom("GenJyuuGothic-Heavy", size:50))
                    }
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .cornerRadius(10)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.top, 30)
                    
                    Spacer()
                    
                    Button(action: {
                        NotificationManager.shared.requestNotificationAuthorization()
                        firstUse = false
                    }){
                        Text("开始使用")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(colorSet))
                            .cornerRadius(10)
                            .padding()
                    }
                    .padding(.bottom, 5)
                    .padding(.top)
                    
                    Text("*每日预估饮水量根据你提供的性别、体重、活动强度等信息计算而成。每天实际饮水量还受当天气温、湿度等因素的影响")
                        .multilineTextAlignment(.center)
                        .padding(.leading, 30)
                        .padding(.trailing, 30)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .padding(.bottom)
                }
            }
        }
        .onAppear{
            intake = caculateWaterIntake(pal: acticityIntensity, weight: weight, gender: gender, humidity: 77.0, athlete: athlete, hdi: 0.788, altitude: 100.0, age: age, temprature: 25.0)
        }
    }
}

struct HelloShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = 230.0
        path.move(to: CGPoint(x: 0.18942*width, y: 0.64916*height))
                path.addCurve(to: CGPoint(x: 0.27418*width, y: 0.51669*height), control1: CGPoint(x: 0.27418*width, y: 0.51669*height), control2: CGPoint(x: 0.23809*width, y: 0.59394*height))
                path.addCurve(to: CGPoint(x: 0.30536*width, y: 0.34281*height), control1: CGPoint(x: 0.30196*width, y: 0.45722*height), control2: CGPoint(x: 0.31651*width, y: 0.37724*height))
                path.addCurve(to: CGPoint(x: 0.24651*width, y: 0.67414*height), control1: CGPoint(x: 0.26479*width, y: 0.21753*height), control2: CGPoint(x: 0.24062*width, y: 0.67407*height))
                path.addCurve(to: CGPoint(x: 0.28192*width, y: 0.5111*height), control1: CGPoint(x: 0.2524*width, y: 0.6742*height), control2: CGPoint(x: 0.25206*width, y: 0.54125*height))
                path.addCurve(to: CGPoint(x: 0.32367*width, y: 0.53984*height), control1: CGPoint(x: 0.31178*width, y: 0.48094*height), control2: CGPoint(x: 0.3223*width, y: 0.52111*height))
                path.addCurve(to: CGPoint(x: 0.31839*width, y: 0.6355*height), control1: CGPoint(x: 0.32589*width, y: 0.57011*height), control2: CGPoint(x: 0.31687*width, y: 0.61804*height))
                path.addCurve(to: CGPoint(x: 0.43599*width, y: 0.55398*height), control1: CGPoint(x: 0.32473*width, y: 0.70854*height), control2: CGPoint(x: 0.42787*width, y: 0.63682*height))
                path.addCurve(to: CGPoint(x: 0.3834*width, y: 0.61147*height), control1: CGPoint(x: 0.44471*width, y: 0.46492*height), control2: CGPoint(x: 0.3683*width, y: 0.46917*height))
                path.addCurve(to: CGPoint(x: 0.4418*width, y: 0.66942*height), control1: CGPoint(x: 0.38895*width, y: 0.66377*height), control2: CGPoint(x: 0.42346*width, y: 0.67724*height))
                path.addCurve(to: CGPoint(x: 0.552*width, y: 0.38575*height), control1: CGPoint(x: 0.50813*width, y: 0.64115*height), control2: CGPoint(x: 0.55363*width, y: 0.49671*height))
                path.addCurve(to: CGPoint(x: 0.49571*width, y: 0.60864*height), control1: CGPoint(x: 0.54988*width, y: 0.24203*height), control2: CGPoint(x: 0.47856*width, y: 0.38729*height))
                path.addCurve(to: CGPoint(x: 0.57499*width, y: 0.64351*height), control1: CGPoint(x: 0.50232*width, y: 0.69393*height), control2: CGPoint(x: 0.55841*width, y: 0.66619*height))
                path.addCurve(to: CGPoint(x: 0.64978*width, y: 0.36314*height), control1: CGPoint(x: 0.60564*width, y: 0.60157*height), control2: CGPoint(x: 0.65966*width, y: 0.48059*height))
                path.addCurve(to: CGPoint(x: 0.59745*width, y: 0.62607*height), control1: CGPoint(x: 0.63947*width, y: 0.24062*height), control2: CGPoint(x: 0.56181*width, y: 0.44249*height))
                path.addCurve(to: CGPoint(x: 0.6548*width, y: 0.65717*height), control1: CGPoint(x: 0.60934*width, y: 0.68733*height), control2: CGPoint(x: 0.64502*width, y: 0.6666*height))
                path.addCurve(to: CGPoint(x: 0.70474*width, y: 0.51817*height), control1: CGPoint(x: 0.67802*width, y: 0.6348*height), control2: CGPoint(x: 0.6855*width, y: 0.5536*height))
                path.addCurve(to: CGPoint(x: 0.76896*width, y: 0.5601*height), control1: CGPoint(x: 0.72906*width, y: 0.4734*height), control2: CGPoint(x: 0.76738*width, y: 0.50686*height))
                path.addCurve(to: CGPoint(x: 0.70263*width, y: 0.65105*height), control1: CGPoint(x: 0.77246*width, y: 0.67742*height), control2: CGPoint(x: 0.72159*width, y: 0.67749*height))
                path.addCurve(to: CGPoint(x: 0.70448*width, y: 0.51817*height), control1: CGPoint(x: 0.68627*width, y: 0.62823*height), control2: CGPoint(x: 0.68244*width, y: 0.56022*height))
                path.addCurve(to: CGPoint(x: 0.7753*width, y: 0.52099*height), control1: CGPoint(x: 0.71954*width, y: 0.48942*height), control2: CGPoint(x: 0.74363*width, y: 0.48871*height))
                path.addCurve(to: CGPoint(x: 0.80807*width, y: 0.51063*height), control1: CGPoint(x: 0.78825*width, y: 0.53419*height), control2: CGPoint(x: 0.79935*width, y: 0.53183*height))
                return path
        
    }
}

#Preview {
    FirstUseView()
}
