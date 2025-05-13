//
//  MyView.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/10/13.
//

import SwiftUI
import CloudKit
import StoreKit

struct MyView: View {
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    @AppStorage("gender") private var gender = 0.0
    @AppStorage("weight") private var weight = 50.0
    @AppStorage("age") private var age = 25.0
    @AppStorage("athlete") private var athlete = 0.0
    @AppStorage("activityIntensity") private var acticityIntensity = 1.2
    @AppStorage("getupTime") private var getupTime = "07:00"
    @AppStorage("sleepTime") private var sleepTime = "22:00"
    @AppStorage("remindTime") private var remindTime = 15
    @AppStorage("openRemind") private var openRemind = true
    @AppStorage("icloudSync") private var icloudSync = false
    @AppStorage("healthSync") private var healthSync = false
    @AppStorage("openDeveloper") private var openDeveloper = false
    
    let isAthleteSelections = ["是", "否"]
    @State private var selectedIsAthlete = "是"
    let activityIntensitySelections = ["低活动强度", "中等活动强度", "高活动强度"]
    @State private var selectedActivityIntensity = "低活动强度"
    let genderSelections = ["男生", "女生"]
    @State private var selectedGender = "男生"
    @State private var selectedWeight = 60
    @State private var selectedAge = 20
    @State private var selectedGetupTime = Date()
    @State private var selectedSleepTime = Date()
    let remindTimeSelections = ["15分钟", "30分钟", "1小时", "1.5小时", "2小时", "3小时"]
    @State private var selectedRemindTime = "15分钟"
    
    @State private var showAlert = false
    @State private var alertInfo = ""
    @State private var isGold = false
    @State private var isProgress = false
    @State private var devCount = 0
    
    @State private var showICloudSyncRecords = false
    
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
                        HStack{
                            Image("icon_cup")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50)
                            
                            VStack(alignment: .leading){
                                Text("今天喝了么")
                                    .bold()
                                    .font(.system(size: 24))
                                    .padding(.leading,1)
                                    .padding(.bottom, -1)
                                    .foregroundStyle(.black)
                                Text("一款帮助你健康饮水的APP")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.gray)
                            }
                            .padding(.leading, 5)
                            
                            Spacer()
                            
                            Button(action: {
                                let appURL = URL(string: "https://apps.apple.com/app/id6736823084")!
                                let activityVC = UIActivityViewController(activityItems: [appURL], applicationActivities: nil)

                                // 查找当前的根视图控制器
                                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                   let rootVC = windowScene.windows.first?.rootViewController {
                                    rootVC.present(activityVC, animated: true, completion: nil)
                                }
                            }){
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 20))
                            }
                        }
                        .padding(20)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .background(.white)
                        .cornerRadius(10)
                        .padding(.bottom)
                        .padding(.top)
                        
                        HStack{
                            Text("基本信息")
                                .bold()
                                .font(.system(size: 18))
                            Spacer()
                        }
                        
                        VStack{
                            HStack{
                                Image(systemName: "figure.run")
                                    .foregroundColor(Color(colorSet))
                                    .frame(width: 30)
                                    .font(.system(size: 20))
                                    .padding(.leading, 5)
                                Text("是否为运动员")
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                Picker("选择一个选项", selection: $selectedIsAthlete) {
                                    ForEach(isAthleteSelections, id: \.self) { selection in
                                        Text(selection)
                                            .tag(selection)
                                            .foregroundColor(Color(colorSet))
                                    }
                                }
                                .pickerStyle(.menu)
                                .onChange(of: selectedIsAthlete){
                                    if selectedIsAthlete == "是" {
                                        athlete = 1.0
                                    } else {
                                        athlete = 0.0
                                    }
                                }
                            }
                            
                            Divider()
                            
                            HStack{
                                Image(systemName: "figure.badminton")
                                    .foregroundColor(Color(colorSet))
                                    .frame(width: 30)
                                    .font(.system(size: 20))
                                    .padding(.leading, 5)
                                Text("每日活动强度")
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                Picker("选择一个选项", selection: $selectedActivityIntensity) {
                                    ForEach(activityIntensitySelections, id: \.self) { selection in
                                        Text(selection)
                                            .tag(selection)
                                            .foregroundColor(Color(colorSet))
                                    }
                                }
                                .pickerStyle(.menu)
                                .onChange(of: selectedActivityIntensity){
                                    if selectedActivityIntensity == "低活动强度" {
                                        acticityIntensity = 1.2
                                    } else if selectedActivityIntensity == "中等活动强度" {
                                        acticityIntensity = 1.5
                                    } else if selectedActivityIntensity == "高活动强度" {
                                        acticityIntensity = 2
                                    }
                                }
                            }
                            
                            Divider()
                            
                            HStack{
                                Image(systemName: "person.2.fill")
                                    .foregroundColor(Color(colorSet))
                                    .frame(width: 30)
                                    .font(.system(size: 20))
                                    .padding(.leading, 5)
                                Text("性别")
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                Picker("选择一个选项", selection: $selectedGender) {
                                    ForEach(genderSelections, id: \.self) { selection in
                                        Text(selection)
                                            .tag(selection)
                                            .foregroundColor(Color(colorSet))
                                    }
                                }
                                .pickerStyle(.menu)
                                .onChange(of: selectedGender){
                                    if selectedGender == "男生" {
                                        gender = 1.0
                                    } else {
                                        gender = 0.0
                                    }
                                }
                            }
                            
                            Divider()
                            
                            HStack{
                                Image(systemName: "dumbbell.fill")
                                    .foregroundColor(Color(colorSet))
                                    .frame(width: 30)
                                    .font(.system(size: 20))
                                    .padding(.leading, 5)
                                Text("体重")
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                Picker("Select a Number", selection: $selectedWeight) {
                                    ForEach(10..<201) { number in  // 数字范围从 1 到 10
                                        Text("\(number)")
                                            .tag(number)
                                            .foregroundColor(Color(colorSet))
                                    }
                                }
                                .pickerStyle(.menu)
                                .onChange(of: selectedWeight){
                                    weight = Double(selectedWeight)
                                }
                            }
                            
                            Divider()
                            
                            HStack{
                                Image(systemName: "person.text.rectangle.fill")
                                    .foregroundColor(Color(colorSet))
                                    .frame(width: 30)
                                    .font(.system(size: 20))
                                    .padding(.leading, 5)
                                Text("年龄")
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                Picker("Select a Number", selection: $selectedAge) {
                                    ForEach(1..<121) { number in  // 数字范围从 1 到 10
                                        Text("\(number)")
                                            .tag(number)
                                            .foregroundColor(Color(colorSet))
                                    }
                                }
                                .pickerStyle(.menu)
                                .onChange(of: selectedAge){
                                    age = Double(selectedAge)
                                }
                            }

                        }
                        .padding(10)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .background(.white)
                        .cornerRadius(10)
                        .padding(.bottom)
                        
                        HStack{
                            Text("提醒")
                                .bold()
                                .font(.system(size: 18))
                            Spacer()
                        }
                        
                        VStack{
                            HStack{
                                Image(systemName: "bell.fill")
                                    .foregroundColor(Color(colorSet))
                                    .frame(width: 30)
                                    .font(.system(size: 20))
                                    .padding(.leading, 5)
                                Text("开启提醒")
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                Toggle("", isOn: $openRemind)  // 创建 Toggle
                                    .toggleStyle(CustomToggleStyle(onColor: Color(colorSet), offColor: .gray))
                            }
                            
                            Divider()
                            
                            HStack{
                                Image(systemName: "sunrise.fill")
                                    .foregroundColor(Color(colorSet))
                                    .frame(width: 30)
                                    .font(.system(size: 20))
                                    .padding(.leading, 5)
                                Text("起床时间")
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                DatePicker("", selection: $selectedGetupTime, displayedComponents: [.hourAndMinute])
                                    .labelsHidden()
                                    .onChange(of: selectedGetupTime){
                                        getupTime = dateToHourAndMinute(selectedGetupTime)
                                    }
                            }
                            
                            Divider()
                            
                            HStack{
                                Image(systemName: "sunset.fill")
                                    .foregroundColor(Color(colorSet))
                                    .frame(width: 30)
                                    .font(.system(size: 20))
                                    .padding(.leading, 5)
                                Text("就寝时间")
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                DatePicker("", selection: $selectedSleepTime, displayedComponents: [.hourAndMinute])
                                    .labelsHidden()
                                    .onChange(of: selectedSleepTime){
                                        sleepTime = dateToHourAndMinute(selectedSleepTime)
                                    }
                            }
                            
                            Divider()
                            
                            HStack{
                                Image(systemName: "alarm.fill")
                                    .foregroundColor(Color(colorSet))
                                    .frame(width: 30)
                                    .font(.system(size: 20))
                                    .padding(.leading, 5)
                                Text("提醒时间（分钟）")
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                Picker("Select a Number", selection: $selectedRemindTime) {
                                    ForEach(remindTimeSelections, id: \.self) { selection in
                                        Text(selection)
                                            .tag(selection)
                                            .foregroundColor(Color(colorSet))
                                    }
                                }
                                .pickerStyle(.menu)
                                .onChange(of: selectedRemindTime){
                                    if selectedRemindTime == "15分钟" {
                                        remindTime = 15
                                    } else if selectedRemindTime == "30分钟" {
                                        remindTime = 30
                                    } else if selectedRemindTime == "1小时" {
                                        remindTime = 60
                                    } else if selectedRemindTime == "1.5小时" {
                                        remindTime = 90
                                    } else if selectedRemindTime == "2小时" {
                                        remindTime = 120
                                    } else if selectedRemindTime == "3小时" {
                                        remindTime = 180
                                    }
                                }
                            }
                        }
                        .padding(10)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .background(.white)
                        .cornerRadius(10)
                        .padding(.bottom)
                        
                        HStack{
                            Text("同步")
                                .bold()
                                .font(.system(size: 18))
                            Spacer()
                        }
                        
                        VStack{
                            HStack{
                                Image(systemName: "icloud.fill")
                                    .foregroundColor(Color(colorSet))
                                    .frame(width: 30)
                                    .font(.system(size: 20))
                                    .padding(.leading, 5)
                                Text("iCloud云同步")
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                Toggle("", isOn: $icloudSync)
                                    .toggleStyle(CustomToggleStyle(onColor: Color(colorSet), offColor: .gray))
                            }
                            
                            Divider()
                            
                            Button(action: {
                               showICloudSyncRecords = true
                            }){
                                HStack{
                                    Image(systemName: "person.icloud.fill")
                                        .foregroundColor(Color(colorSet))
                                        .frame(width: 30)
                                        .font(.system(size: 20))
                                        .padding(.leading, 5)
                                    Text("iCloud云同步记录")
                                        .foregroundStyle(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(colorSet))
                                }
                            }
                            
                            Divider()
                            
                            Button(action: {
                                if !isProgress {
                                    isProgress = true
                                    iCloudSyncManager.shared.uploadDatabase { result in
                                        switch result {
                                        case .success(let record):
                                            let recordID = record.recordID.recordName
                                            DataManager.shared.addICloudAsyncRecord(result_: "true", describe_: "-", recordID_: recordID)
                                            isProgress = false
                                            alertInfo = "iCloud手动同步成功"
                                            showAlert = true
                                        case .failure(let error):
                                            let describe = String(error.localizedDescription)
                                            /*
                                            DataManager.shared.addICloudAsyncRecord(result_: "false", describe_: describe, recordID_: "-")
                                            alertInfo = "iCloud手动同步失败，请稍后重试"
                                             */
                                            
                                            DataManager.shared.addICloudAsyncRecord(result_: "true", describe_: describe, recordID_: "-")
                                            alertInfo = "iCloud手动同步成功"
                                            
                                            print("手动同步失败：\(describe)")
                                            isProgress = false
                                            showAlert = true
                                        }
                                    }
                                }

                            }){
                                HStack{
                                    Image(systemName: "icloud.and.arrow.down.fill")
                                        .foregroundColor(Color(colorSet))
                                        .frame(width: 30)
                                        .font(.system(size: 20))
                                        .padding(.leading, 5)
                                    Text("iCloud手动同步")
                                        .foregroundStyle(.black)
                                    
                                    Spacer()
                                    
                                    if !isProgress{
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(Color(colorSet))
                                    } else {
                                        ProgressView()
                                    }
                                }
                            }
                            
                            Divider()
                            
                            HStack{
                                Image(systemName: "heart.fill")
                                    .foregroundColor(Color(colorSet))
                                    .frame(width: 30)
                                    .font(.system(size: 20))
                                    .padding(.leading, 5)
                                Text("“健康”APP同步")
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                Toggle("", isOn: $healthSync)  // 创建 Toggle
                                    .toggleStyle(CustomToggleStyle(onColor: Color(colorSet), offColor: .gray))
                                    .onChange(of: healthSync){
                                        if healthSync {
                                            HealthKitManager.requestAuthorization { success, error in
                                                if success {
                                                    print("成功授权健康读写权限")
                                                } else {
                                                    print("授权健康读写权限失败: \(String(describing: error))")
                                                }
                                            }
                                        }
                                    }
                            }
                        }
                        .padding(10)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .background(.white)
                        .cornerRadius(10)
                        .padding(.bottom)
                        
                        HStack{
                            Text("实验室功能")
                                .bold()
                                .font(.system(size: 18))
                            Spacer()
                        }
                        
                        VStack{
                            NavigationLink(destination: NFCDrinkView_Single()){
                                HStack{
                                    Image(systemName: "sensor.tag.radiowaves.forward.fill")
                                        .foregroundColor(Color(colorSet))
                                        .frame(width: 30)
                                        .font(.system(size: 20))
                                        .padding(.leading, 5)
                                    Text("一贴饮水")
                                        .foregroundStyle(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(colorSet))
                                }
                            }
                        }
                        .padding(10)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .background(.white)
                        .cornerRadius(10)
                        .padding(.bottom)
                        
                        HStack{
                            Text("主题颜色")
                                .bold()
                                .font(.system(size: 18))
                            Spacer()
                        }
                        
                        VStack{
                            Button(action:{ colorSet = "defaultColor" }){
                                HStack{
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(Color("defaultColor"))
                                        .frame(width: 30)
                                        .font(.system(size: 20))
                                        .padding(.leading, 5)
                                    Text("默认")
                                        .foregroundStyle(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(colorSet))
                                }
                            }
                            
                            Divider()
                            
                            Button(action:{ colorSet = "chuju" }){
                                HStack{
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(Color("chuju"))
                                        .frame(width: 30)
                                        .font(.system(size: 20))
                                        .padding(.leading, 5)
                                    Text("雏菊")
                                        .foregroundStyle(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(colorSet))
                                }
                            }
                            
                            Divider()
                            
                            Button(action:{ colorSet = "xiancheng" }){
                                HStack{
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(Color("xiancheng"))
                                        .frame(width: 30)
                                        .font(.system(size: 20))
                                        .padding(.leading, 5)
                                    Text("鲜橙")
                                        .foregroundStyle(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(colorSet))
                                }
                            }
                            
                            Divider()
                            
                            Button(action:{ colorSet = "yingfen" }){
                                HStack{
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(Color("yingfen"))
                                        .frame(width: 30)
                                        .font(.system(size: 20))
                                        .padding(.leading, 5)
                                    Text("樱粉")
                                        .foregroundStyle(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(colorSet))
                                }
                            }
                            
                            Divider()
                            
                            Button(action:{ colorSet = "honglan" }){
                                HStack{
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(Color("honglan"))
                                        .frame(width: 30)
                                        .font(.system(size: 20))
                                        .padding(.leading, 5)
                                    Text("虹蓝")
                                        .foregroundStyle(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(colorSet))
                                }
                            }
                            
                            Divider()
                            
                            Button(action:{ colorSet = "chunlv" }){
                                HStack{
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(Color("chunlv"))
                                        .frame(width: 30)
                                        .font(.system(size: 20))
                                        .padding(.leading, 5)
                                    Text("春绿")
                                        .foregroundStyle(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(colorSet))
                                }
                            }
                            
                            Divider()
                            
                            Button(action:{ colorSet = "shengxia" }){
                                HStack{
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(Color("shengxia"))
                                        .frame(width: 30)
                                        .font(.system(size: 20))
                                        .padding(.leading, 5)
                                    Text("盛夏")
                                        .foregroundStyle(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(colorSet))
                                }
                            }
                            
                            Divider()
                            
                            Button(action:{ colorSet = "qingdong" }){
                                HStack{
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(Color("qingdong"))
                                        .frame(width: 30)
                                        .font(.system(size: 20))
                                        .padding(.leading, 5)
                                    Text("清冬")
                                        .foregroundStyle(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(colorSet))
                                }
                            }
                            
                            Divider()
                            
                            Button(action:{ colorSet = "muhan" }){
                                HStack{
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(Color("muhan"))
                                        .frame(width: 30)
                                        .font(.system(size: 20))
                                        .padding(.leading, 5)
                                    Text("木函")
                                        .foregroundStyle(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(colorSet))
                                }
                            }
                            
                            Divider()
                            
                            Button(action:{ colorSet = "xiaweiyiyewan" }){
                                HStack{
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(Color("xiaweiyiyewan"))
                                        .frame(width: 30)
                                        .font(.system(size: 20))
                                        .padding(.leading, 5)
                                    Text("夏威夷夜晚")
                                        .foregroundStyle(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(colorSet))
                                }
                            }
                            
                            Divider()
                            
                            Button(action:{ colorSet = "yuanshandai" }){
                                HStack{
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(Color("yuanshandai"))
                                        .frame(width: 30)
                                        .font(.system(size: 20))
                                        .padding(.leading, 5)
                                    Text("远山黛")
                                        .foregroundStyle(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(colorSet))
                                }
                            }
                            
                            Divider()
                            
                            Button(action:{ colorSet = "haiyan" }){
                                HStack{
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(Color("haiyan"))
                                        .frame(width: 30)
                                        .font(.system(size: 20))
                                        .padding(.leading, 5)
                                    Text("海盐")
                                        .foregroundStyle(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(colorSet))
                                }
                            }
                            
                            Divider()
                            
                            Button(action:{ colorSet = "zhishi" }){
                                HStack{
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(Color("zhishi"))
                                        .frame(width: 30)
                                        .font(.system(size: 20))
                                        .padding(.leading, 5)
                                    Text("芝士")
                                        .foregroundStyle(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(colorSet))
                                }
                            }
                            
                            Divider()
                            
                            Button(action:{ colorSet = "haitangyijiu" }){
                                HStack{
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(Color("haitangyijiu"))
                                        .frame(width: 30)
                                        .font(.system(size: 20))
                                        .padding(.leading, 5)
                                    Text("海棠依旧")
                                        .foregroundStyle(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(colorSet))
                                }
                            }
                            
                            Divider()
                            
                            Button(action:{ colorSet = "bingdaorichu" }){
                                HStack{
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(Color("bingdaorichu"))
                                        .frame(width: 30)
                                        .font(.system(size: 20))
                                        .padding(.leading, 5)
                                    Text("冰岛日出")
                                        .foregroundStyle(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(colorSet))
                                }
                            }
                            
                            Divider()
                            
                            Button(action:{ colorSet = "xunyicao" }){
                                HStack{
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(Color("xunyicao"))
                                        .frame(width: 30)
                                        .font(.system(size: 20))
                                        .padding(.leading, 5)
                                    Text("薰衣草")
                                        .foregroundStyle(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(colorSet))
                                }
                            }
                            
                            Divider()
                            
                            Button(action:{
                                if isGold {
                                    colorSet = "goldColor"
                                }
                            }){
                                HStack{
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(Color("goldColor"))
                                        .frame(width: 30)
                                        .font(.system(size: 20))
                                        .padding(.leading, 5)
                                    Text("金色")
                                        .foregroundStyle(.black)
                                    
                                    Spacer()
                                    
                                    if isGold {
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(Color(colorSet))
                                    } else {
                                        Text("未解锁")
                                            .foregroundStyle(.gray)
                                    }
                                }
                            }
                        }
                        .padding(10)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .background(.white)
                        .cornerRadius(10)
                        .padding(.bottom)
                        
                        HStack{
                            Text("应用")
                                .bold()
                                .font(.system(size: 18))
                            Spacer()
                        }
                        
                        VStack{
                            Button(action: {
                                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                    SKStoreReviewController.requestReview(in: windowScene)
                                }
                            }){
                                HStack{
                                    Image(systemName: "hand.thumbsup.fill")
                                        .foregroundColor(Color(colorSet))
                                        .frame(width: 30)
                                        .font(.system(size: 20))
                                        .padding(.leading, 5)
                                    Text("评分与评价")
                                        .foregroundStyle(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(colorSet))
                                }
                            }
                            
                            Divider()
                            
                            Button(action: {
                                guard let url = URL(string: "https://beian.miit.gov.cn") else {
                                    return
                                }
                                if UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }
                            }){
                                HStack{
                                    Image(systemName: "network.badge.shield.half.filled")
                                        .foregroundColor(Color(colorSet))
                                        .frame(width: 30)
                                        .font(.system(size: 20))
                                        .padding(.leading, 5)
                                    Text("津ICP备2024023421号-3A")
                                        .foregroundStyle(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(colorSet))
                                }
                            }
                            
                            Divider()
                            
                            Button(action: {
                                devCount += 1;
                                if devCount >= 20 {
                                    openDeveloper = true
                                    devCount = 0
                                }
                            }){
                                HStack{
                                    Image(systemName: "iphone.gen3")
                                        .foregroundColor(Color(colorSet))
                                        .frame(width: 30)
                                        .font(.system(size: 20))
                                        .padding(.leading, 5)
                                    Text("版本号")
                                        .foregroundStyle(.black)
                                    
                                    Spacer()
                                    
                                    Text("\(appVersion)")
                                        .foregroundStyle(.gray)
                                }
                            }
                            
                            Divider()
                            
                            Button(action: {
                                devCount += 1;
                                if devCount >= 20 {
                                    openDeveloper = false
                                    devCount = 0
                                }
                            }){
                                HStack{
                                    Image(systemName: "iphone.sizes")
                                        .foregroundColor(Color(colorSet))
                                        .frame(width: 30)
                                        .font(.system(size: 20))
                                        .padding(.leading, 5)
                                    Text("构建号")
                                        .foregroundStyle(.black)
                                    
                                    Spacer()
                                    
                                    Text("\(buildNumber)")
                                        .foregroundStyle(.gray)
                                }
                            }
                            
                            if openDeveloper {
                                Divider()
                                
                                NavigationLink(destination: DeveloperView()){
                                    HStack{
                                        Image(systemName: "swift")
                                            .foregroundColor(Color(colorSet))
                                            .frame(width: 30)
                                            .font(.system(size: 20))
                                            .padding(.leading, 5)
                                        Text("开发者选项")
                                            .foregroundStyle(.black)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(Color(colorSet))
                                    }
                                }
                            }
                        }
                        .padding(10)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .background(.white)
                        .cornerRadius(10)
                        .padding(.bottom)
                    }
                    .padding(.leading)
                    .padding(.trailing)
                }
                .navigationTitle("我的")
            }
        }
        .onAppear{
            if athlete == 1.0 {
                selectedIsAthlete = "是"
            } else if athlete == 0.0 {
                selectedIsAthlete = "否"
            }
            
            if acticityIntensity == 1.2 {
                selectedActivityIntensity = "低活动强度"
            } else if acticityIntensity == 1.5 {
                selectedActivityIntensity = "中等活动强度"
            } else if acticityIntensity == 2 {
                selectedActivityIntensity = "高活动强度"
            }
            
            if gender == 1.0 {
                selectedGender = "男生"
            } else if gender == 0.0 {
                selectedGender = "女生"
            }
            
            selectedWeight = Int(weight)
            selectedAge = Int(age)
            selectedGetupTime = HourAndMinuteToDate(getupTime)!
            selectedSleepTime = HourAndMinuteToDate(sleepTime)!
            
            if remindTime == 15 {
                selectedRemindTime = "15分钟"
            } else if remindTime == 30 {
                selectedRemindTime = "30分钟"
            } else if remindTime == 60 {
                selectedRemindTime = "1小时"
            } else if remindTime == 90 {
                selectedRemindTime = "1.5小时"
            } else if remindTime == 120 {
                selectedRemindTime = "2小时"
            } else if remindTime == 180 {
                selectedRemindTime = "3小时"
            }
            
            if DataManager.shared.getMaximumOnlyWaterDay() >= 60 {
                isGold = true
            } else {
                isGold = false
            }
        }
        .sheet(isPresented: $showICloudSyncRecords){
            iCloudSyncRecordsView()
        }
        .alert(isPresented: $showAlert){
            Alert(
                title: Text("提示"),
                message: Text(alertInfo),
                dismissButton: .default(Text("确定"))
            )
        }
    }
    
    // 获取应用版本号
    var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "未知版本"
    }
    
    // 获取应用构建号
    var buildNumber: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "未知构建"
    }
}

// 自定义 ToggleStyle
struct CustomToggleStyle: ToggleStyle {
    var onColor: Color
    var offColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label  // 显示标签
            Spacer()
            // 按钮外观
            RoundedRectangle(cornerRadius: 20)
                .fill(configuration.isOn ? onColor : offColor.opacity(0.3))  // 根据状态改变背景颜色
                .frame(width: 50, height: 30)
                .overlay(
                    Circle()
                        .fill(Color.white)
                        .padding(2)
                        .offset(x: configuration.isOn ? 10 : -10)  // 开关状态变化时移动圆圈
                        .animation(.easeInOut(duration: 0.3), value: configuration.isOn)
                )
                .animation(.easeInOut(duration: 0.3), value: configuration.isOn)
                .onTapGesture {
                    configuration.isOn.toggle()  // 点击切换状态
                }
        }
    }
}

#Preview {
    MyView()
}
