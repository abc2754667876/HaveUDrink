//
//  AddAnotherView.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/11/4.
//

import SwiftUI

struct AddAnotherView: View {
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    
    @State private var selectedDate = Date()
    @State private var imageName = "water"
    @State private var title = "补录饮用水"
    @State private var selectedOption: Int? = 1
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(.secondarySystemBackground)
                    .ignoresSafeArea()
                
                ScrollView{
                    VStack{
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                            .padding(.top, 20)
                        Text(title)
                            .bold()
                            .font(.system(size: 28))
                        
                        HStack{
                            Text("饮品选择")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .padding(.bottom, 5)
                        .padding(.top)
                        
                        VStack{
                            HStack{
                                Button(action: {
                                    selectedOption = 1
                                }) {
                                    Text("饮用水")
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
                                    selectedOption = 2
                                }) {
                                    Text("酒")
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
                                    selectedOption = 3
                                }) {
                                    Text("咖啡")
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
                                    selectedOption = 4
                                }) {
                                    Text("奶茶")
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
                                    selectedOption = 5
                                }) {
                                    Text("奶")
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
                                    selectedOption = 6
                                }) {
                                    Text("其他饮品")
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
                        
                        HStack{
                            Text("时间")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .padding(.bottom, 5)
                        .padding(.top)
                        
                        VStack{
                            HStack{
                                DatePicker("选择日期和时间", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                                    .datePickerStyle(GraphicalDatePickerStyle())
                            }
                            .padding()
                        }
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .background(.white)
                        .cornerRadius(10)
                        
                        if selectedOption == 1 {
                            AddAnotherView_Water(selectedDate: $selectedDate)
                        } else if selectedOption == 2 {
                            AddAnotherView_Wine(selectedDate: $selectedDate)
                        } else if selectedOption == 3 {
                            AddAnotherView_Coffee(selectedDate: $selectedDate)
                        } else if selectedOption == 4 {
                            AddAnotherView_MilkTea(selectedDate: $selectedDate)
                        } else if selectedOption == 5 {
                            AddAnotherView_Milk(selectedDate: $selectedDate)
                        } else if selectedOption == 6 {
                            AddAnotherView_Other(selectedDate: $selectedDate)
                        }
                    }
                    .padding(.trailing)
                    .padding(.leading)
                }
            }
            .onChange(of: selectedOption){
                if selectedOption == 1 {
                    imageName = "water"
                    title = "补录饮用水"
                } else if selectedOption == 2 {
                    imageName = "beer"
                    title = "补录酒"
                } else if selectedOption == 3 {
                    imageName = "coffee"
                    title = "补录咖啡"
                } else if selectedOption == 4 {
                    imageName = "milkTea"
                    title = "补录奶茶"
                } else if selectedOption == 5 {
                    imageName = "milk"
                    title = "补录奶"
                } else if selectedOption == 6 {
                    imageName = "yinliao"
                    title = "补录其他"
                }
            }
        }
    }
}

struct AddAnotherView_Water: View{
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    @AppStorage("healthSync") private var healthSync = false
    @State private var intake = 100
    @State private var showAlert = false
    @State private var alertInfo = "补录成功"
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var selectedDate:Date
    
    var body: some View{
        HStack{
            Text("摄入量")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(.bottom, 5)
        .padding(.top)
        
        VStack{
            Slider(
                value: Binding(
                    get: { Double(intake) },  // 将 intake 转换为 Double
                    set: { intake = Int($0) } // 将 Slider 的值转换为 Int
                ),
                in: 10...2500, // 设定范围
                step: 10  // 每次滑动步长
            )
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .padding(.top)
            .accentColor(Color(colorSet)) // 修改滑块颜色
            .frame(width: .infinity) // 修改滑块宽度
            
            Text("\(intake)ml")
                .font(.custom("GenJyuuGothic-Heavy", size:36))
                .foregroundColor(Color(colorSet))
                .padding(.bottom)
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .background(.white)
        .cornerRadius(10)
        
        Spacer()
        
        Button(action: {
            if !DataManager.shared.dateHavePlan(for: DateGetDay(date: selectedDate)) {
                alertInfo = "补录失败，当前日期无饮水计划"
                showAlert = true
                return
            }
            
            DataManager.shared.addWaterIntake(date_: DateGetDay(date: selectedDate), intake_: intake, time_: selectedDate)
            
            if healthSync {
                HealthKitManager.addWaterIntake(amount: Double(intake), date: Date()) { success, error in
                    if success {
                        print("已添加水摄入")
                    } else {
                        print("添加水摄入失败: \(String(describing: error))")
                    }
                }
            }
            
            presentationMode.wrappedValue.dismiss()
            alertInfo = "补录成功，时间：\(getDateString(date: selectedDate))"
            showAlert = true
        }){
            Text("确定添加")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(colorSet))
                .cornerRadius(10)
                .padding()
        }
        .padding(.bottom)
        .padding(.top)
        .alert("补录", isPresented: $showAlert) {
            Button("确定", role: .cancel) {}
        } message: {
            Text(alertInfo)
        }
    }
}

struct AddAnotherView_Wine: View{
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    @AppStorage("healthSync") private var healthSync = false
    @State private var intake = 100
    @State private var selectedWineType = "啤酒"
    @State private var selectedConcentration = 0
    @State private var showAlert = false
    @State private var alertInfo = "补录成功"
    
    @Binding var selectedDate:Date
    
    var body: some View{
        HStack{
            Text("摄入量")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(.bottom, 5)
        .padding(.top)
        
        VStack{
            Slider(
                value: Binding(
                    get: { Double(intake) },  // 将 intake 转换为 Double
                    set: { intake = Int($0) } // 将 Slider 的值转换为 Int
                ),
                in: 10...2500, // 设定范围
                step: 10  // 每次滑动步长
            )
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .padding(.top)
            .accentColor(Color(colorSet)) // 修改滑块颜色
            .frame(width: .infinity) // 修改滑块宽度
            
            Text("\(intake)ml")
                .font(.custom("GenJyuuGothic-Heavy", size:36))
                .foregroundColor(Color(colorSet))
                .padding(.bottom)
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .background(.white)
        .cornerRadius(10)
        
        HStack{
            Text("摄入设置")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(.bottom, 5)
        .padding(.top)
        
        VStack{
            HStack{
                Text("酒类型")
                    .foregroundColor(.black)
                    .bold()
                Spacer()
                Picker("饮品选择", selection: $selectedWineType) {
                    Text("啤酒").tag("啤酒")
                    Text("白酒").tag("白酒")
                    Text("葡萄酒").tag("葡萄酒")
                    Text("鸡尾酒").tag("鸡尾酒")
                    Text("威士忌").tag("威士忌")
                    Text("香槟").tag("香槟")
                    Text("伏特加").tag("伏特加")
                    Text("龙舌兰").tag("龙舌兰")
                    Text("朗姆酒").tag("朗姆酒")
                    Text("果酒").tag("果酒")
                    Text("药酒").tag("药酒")
                    Text("黄酒").tag("黄酒")
                    Text("米酒").tag("米酒")
                    Text("其他酒").tag("其他酒")
                }
                .pickerStyle(MenuPickerStyle())
            }
            .padding(.top)
            .padding(.trailing)
            .padding(.leading)
            
            HStack{
                Text("酒精浓度（%）")
                    .foregroundColor(.black)
                    .bold()
                Spacer()
                Picker("数字选择", selection: $selectedConcentration) {
                    ForEach(0...96, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
                .pickerStyle(MenuPickerStyle()) // 可以选择不同的样式
            }
            .padding(.trailing)
            .padding(.leading)
            .padding(.bottom)
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .background(.white)
        .cornerRadius(10)
        
        Spacer()
        
        Button(action: {
            if !DataManager.shared.dateHavePlan(for: DateGetDay(date: selectedDate)) {
                alertInfo = "补录失败，当前日期无饮水计划"
                showAlert = true
                return
            }
            
            let alcoholContent = Int(Double(intake) * (Double(selectedConcentration) / 100) * Double(789))
            DataManager.shared.addWineIntake(date_: DateGetDay(date: selectedDate), intake_: intake, type_: selectedWineType, concentration_: selectedConcentration, alcoholContent_: alcoholContent, time_: selectedDate)
            
            presentationMode.wrappedValue.dismiss()
            alertInfo = "补录成功，时间：\(getDateString(date: selectedDate))"
            showAlert = true
        }){
            Text("确定添加")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(colorSet))
                .cornerRadius(10)
                .padding()
        }
        .padding(.top)
        .alert("补录", isPresented: $showAlert) {
            Button("确定", role: .cancel) {}
        } message: {
            Text(alertInfo)
        }
        
        Text("*过量饮酒伤身，未成年人禁止饮酒")
            .padding(.bottom)
            .foregroundColor(.gray)
            .font(.system(size: 14))
    }
}

struct AddAnotherView_Coffee: View{
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    @AppStorage("healthSync") private var healthSync = false
    @State private var intake = 100
    @State private var selectedCoffeeType = "不选择"
    @State private var selectedCoffeeBrand = "不选择"
    @State private var selectedEspressoCount = 1
    @State private var showAlert = false
    @State private var alertInfo = "补录成功"
    
    @Binding var selectedDate:Date
    
    var body: some View{
        HStack{
            Text("摄入量")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(.bottom, 5)
        .padding(.top)
        
        VStack{
            Slider(
                value: Binding(
                    get: { Double(intake) },  // 将 intake 转换为 Double
                    set: { intake = Int($0) } // 将 Slider 的值转换为 Int
                ),
                in: 10...1000, // 设定范围
                step: 10  // 每次滑动步长
            )
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .padding(.top)
            .accentColor(Color(colorSet)) // 修改滑块颜色
            .frame(width: .infinity) // 修改滑块宽度
            
            Text("\(intake)ml")
                .font(.custom("GenJyuuGothic-Heavy", size:36))
                .foregroundColor(Color(colorSet))
                .padding(.bottom)
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .background(.white)
        .cornerRadius(10)
        
        HStack{
            Text("摄入设置")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(.bottom, 5)
        .padding(.top)
        
        VStack{
            HStack{
                Text("咖啡类型")
                    .foregroundColor(.black)
                    .bold()
                Spacer()
                Picker("饮品选择", selection: $selectedCoffeeType) {
                    Text("不选择").tag("不选择")
                    Text("意式浓缩").tag("意式浓缩")
                    Text("美式").tag("美式")
                    Text("拿铁").tag("拿铁")
                    Text("卡布奇诺").tag("卡布奇诺")
                    Text("摩卡").tag("摩卡")
                    Text("冷萃").tag("冷萃")
                    Text("法压壶").tag("法压壶")
                    Text("其他").tag("其他")
                }
                .pickerStyle(MenuPickerStyle())
            }
            .padding(.top)
            .padding(.trailing)
            .padding(.leading)
            
            HStack{
                Text("品牌")
                    .foregroundColor(.black)
                    .bold()
                Spacer()
                Picker("饮品选择", selection: $selectedCoffeeBrand) {
                    Text("不选择").tag("不选择")
                    Text("星巴克").tag("星巴克")
                    Text("瑞幸").tag("瑞幸")
                    Text("库迪").tag("库迪")
                    Text("幸运咖").tag("幸运咖")
                    Text("西西弗矢量").tag("西西弗矢量")
                    Text("KCOFFEE").tag("KCOFFEE")
                    Text("McCafé").tag("McCafé")
                    Text("M Stand").tag("M Stand")
                    Text("ARABICA").tag("ARABICA")
                    Text("MANNER").tag("MANNER")
                    Text("COSTA COFFEE").tag("COSTA COFFEE")
                    Text("Tims").tag("Tims")
                    Text("BLUE BOTTLE").tag("BLUE BOTTLE")
                    Text("其他").tag("其他")
                }
                .pickerStyle(MenuPickerStyle())
            }
            .padding(.trailing)
            .padding(.leading)
            
            HStack{
                Text("浓缩数量（份）")
                    .foregroundColor(.black)
                    .bold()
                Spacer()
                Picker("数字选择", selection: $selectedEspressoCount) {
                    ForEach(1...10, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
                .pickerStyle(MenuPickerStyle()) // 可以选择不同的样式
            }
            .padding(.trailing)
            .padding(.leading)
            .padding(.bottom)
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .background(.white)
        .cornerRadius(10)
        
        Spacer()
        
        Button(action: {
            if !DataManager.shared.dateHavePlan(for: DateGetDay(date: selectedDate)) {
                alertInfo = "补录失败，当前日期无饮水计划"
                showAlert = true
                return
            }
            
            DataManager.shared.addCoffeeIntake(date_: DateGetDay(date: selectedDate), intake_: intake, type_: selectedCoffeeType, brand_: selectedCoffeeBrand, espressoCount_: selectedEspressoCount, caffeeine_: selectedEspressoCount * 63, time_: selectedDate)
            
            presentationMode.wrappedValue.dismiss()
            alertInfo = "补录成功，时间：\(getDateString(date: selectedDate))"
            showAlert = true
        }){
            Text("确定添加")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(colorSet))
                .cornerRadius(10)
                .padding()
        }
        .padding(.top)
        .padding(.bottom)
        .alert("补录", isPresented: $showAlert) {
            Button("确定", role: .cancel) {}
        } message: {
            Text(alertInfo)
        }
    }
}

struct AddAnotherView_MilkTea: View{
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    @State private var intake = 100
    
    @State private var selectedMilkteaBrand = "不选择"
    @State private var showAlert = false
    @State private var alertInfo = "补录成功"
    
    @Binding var selectedDate:Date
    
    var body: some View{
        HStack{
            Text("摄入量")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(.bottom, 5)
        .padding(.top)
        
        VStack{
            Slider(
                value: Binding(
                    get: { Double(intake) },  // 将 intake 转换为 Double
                    set: { intake = Int($0) } // 将 Slider 的值转换为 Int
                ),
                in: 10...1000, // 设定范围
                step: 10  // 每次滑动步长
            )
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .padding(.top)
            .accentColor(Color(colorSet)) // 修改滑块颜色
            .frame(width: .infinity) // 修改滑块宽度
            
            Text("\(intake)ml")
                .font(.custom("GenJyuuGothic-Heavy", size:36))
                .foregroundColor(Color(colorSet))
                .padding(.bottom)
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .background(.white)
        .cornerRadius(10)
        
        HStack{
            Text("摄入设置")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(.bottom, 5)
        .padding(.top)
        
        VStack{
            HStack{
                Text("品牌")
                    .foregroundColor(.black)
                    .bold()
                Spacer()
                Picker("饮品选择", selection: $selectedMilkteaBrand) {
                    Text("不选择").tag("不选择")
                    Text("蜜雪冰城").tag("蜜雪冰城")
                    Text("阿水大杯茶").tag("阿水大杯茶")
                    Text("沪上阿姨").tag("沪上阿姨")
                    Text("喜茶").tag("喜茶")
                    Text("茶百道").tag("茶百道")
                    Text("奈雪的茶").tag("奈雪的茶")
                    Text("霸王茶姬").tag("霸王茶姬")
                    Text("茶颜悦色").tag("茶颜悦色")
                    Text("书亦烧仙草").tag("书亦烧仙草")
                    Text("古茗").tag("古茗")
                    Text("益禾堂").tag("益禾堂")
                    Text("一点点").tag("一点点")
                    Text("茉酸奶").tag("茉酸奶")
                    Text("CoCo都可").tag("CoCo都可")
                    Text("兰熊").tag("兰熊")
                    Text("七分甜").tag("七分甜")
                    Text("茉莉奶白").tag("茉莉奶白")
                    Text("茶话弄").tag("茶话弄")
                    Text("甜啦啦").tag("甜啦啦")
                    Text("其他").tag("其他")
                }
                .pickerStyle(MenuPickerStyle())
            }
            .padding(.top)
            .padding(.trailing)
            .padding(.leading)
            .padding(.bottom)
            
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .background(.white)
        .cornerRadius(10)
        
        Spacer()
        
        Button(action: {
            if !DataManager.shared.dateHavePlan(for: DateGetDay(date: selectedDate)) {
                alertInfo = "补录失败，当前日期无饮水计划"
                showAlert = true
                return
            }
            
            DataManager.shared.addMilkteaIntake(date_: DateGetDay(date: selectedDate), intake_: intake, brand_: selectedMilkteaBrand, time_: selectedDate)
            presentationMode.wrappedValue.dismiss()
            alertInfo = "补录成功，时间：\(getDateString(date: selectedDate))"
            showAlert = true
        }){
            Text("确定添加")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(colorSet))
                .cornerRadius(10)
                .padding()
        }
        .padding(.top)
        .padding(.bottom)
        .alert("补录", isPresented: $showAlert) {
            Button("确定", role: .cancel) {}
        } message: {
            Text(alertInfo)
        }
    }
}

struct AddAnotherView_Milk: View{
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    @State private var intake = 100
    
    @State private var selectedMilkType = "不选择"
    @State private var showAlert = false
    @State private var alertInfo = "补录成功"
    
    @Binding var selectedDate:Date
    
    var body: some View{
        HStack{
            Text("摄入量")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(.bottom, 5)
        .padding(.top)
        
        VStack{
            Slider(
                value: Binding(
                    get: { Double(intake) },  // 将 intake 转换为 Double
                    set: { intake = Int($0) } // 将 Slider 的值转换为 Int
                ),
                in: 10...1000, // 设定范围
                step: 10  // 每次滑动步长
            )
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .padding(.top)
            .accentColor(Color(colorSet)) // 修改滑块颜色
            .frame(width: .infinity) // 修改滑块宽度
            
            Text("\(intake)ml")
                .font(.custom("GenJyuuGothic-Heavy", size:36))
                .foregroundColor(Color(colorSet))
                .padding(.bottom)
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .background(.white)
        .cornerRadius(10)
        
        HStack{
            Text("摄入设置")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(.bottom, 5)
        .padding(.top)
        
        VStack{
            HStack{
                Text("奶类型")
                    .foregroundColor(.black)
                    .bold()
                Spacer()
                Picker("饮品选择", selection: $selectedMilkType) {
                    Text("不选择").tag("不选择")
                    Text("牛奶").tag("牛奶")
                    Text("羊奶").tag("羊奶")
                    Text("水牛奶").tag("水牛奶")
                    Text("豆奶").tag("豆奶")
                    Text("杏仁奶").tag("杏仁奶")
                    Text("燕麦奶").tag("燕麦奶")
                    Text("果奶").tag("果奶")
                    Text("酸奶").tag("酸奶")
                    Text("椰奶").tag("椰奶")
                    Text("奶精饮品").tag("奶精饮品")
                    Text("其他").tag("其他")
                }
                .pickerStyle(MenuPickerStyle())
            }
            .padding(.top)
            .padding(.trailing)
            .padding(.leading)
            .padding(.bottom)
            
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .background(.white)
        .cornerRadius(10)
        
        Spacer()
        
        Button(action: {
            if !DataManager.shared.dateHavePlan(for: DateGetDay(date: selectedDate)) {
                alertInfo = "补录失败，当前日期无饮水计划"
                showAlert = true
                return
            }
            
            DataManager.shared.addMilkIntake(date_: DateGetDay(date: selectedDate), intake_: intake, type_: selectedMilkType, time_: selectedDate)
            presentationMode.wrappedValue.dismiss()
            alertInfo = "补录成功，时间：\(getDateString(date: selectedDate))"
            showAlert = true
        }){
            Text("确定添加")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(colorSet))
                .cornerRadius(10)
                .padding()
        }
        .padding(.top)
        .padding(.bottom)
        .alert("补录", isPresented: $showAlert) {
            Button("确定", role: .cancel) {}
        } message: {
            Text(alertInfo)
        }
    }
}

struct AddAnotherView_Other: View{
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    @State private var intake = 100
    
    @State private var selectedType = "不选择"
    @State private var showAlert = false
    @State private var alertInfo = "补录成功"
    
    @Binding var selectedDate:Date
    
    var body: some View{
        HStack{
            Text("摄入量")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(.bottom, 5)
        .padding(.top)
        
        VStack{
            Slider(
                value: Binding(
                    get: { Double(intake) },  // 将 intake 转换为 Double
                    set: { intake = Int($0) } // 将 Slider 的值转换为 Int
                ),
                in: 10...1000, // 设定范围
                step: 10  // 每次滑动步长
            )
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .padding(.top)
            .accentColor(Color(colorSet)) // 修改滑块颜色
            .frame(width: .infinity) // 修改滑块宽度
            
            Text("\(intake)ml")
                .font(.custom("GenJyuuGothic-Heavy", size:36))
                .foregroundColor(Color(colorSet))
                .padding(.bottom)
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .background(.white)
        .cornerRadius(10)
        
        HStack{
            Text("摄入设置")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(.bottom, 5)
        .padding(.top)
        
        VStack{
            HStack{
                Text("饮品类型")
                    .foregroundColor(.black)
                    .bold()
                Spacer()
                Picker("饮品选择", selection: $selectedType) {
                    Text("不选择").tag("不选择")
                    Text("果茶").tag("果茶")
                    Text("茶叶饮品").tag("茶叶饮品")
                    Text("果汁").tag("果汁")
                    Text("蜂蜜水").tag("蜂蜜水")
                    Text("气泡饮品").tag("气泡饮品")
                    Text("粥").tag("粥")
                    Text("汤").tag("汤")
                    Text("汤药").tag("汤药")
                    Text("露饮品").tag("露饮品")
                    Text("其他").tag("其他")
                }
                .pickerStyle(MenuPickerStyle())
            }
            .padding(.top)
            .padding(.trailing)
            .padding(.leading)
            .padding(.bottom)
            
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .background(.white)
        .cornerRadius(10)
        
        Spacer()
        
        Button(action: {
            if !DataManager.shared.dateHavePlan(for: DateGetDay(date: selectedDate)) {
                alertInfo = "补录失败，当前日期无饮水计划"
                showAlert = true
                return
            }
            
            DataManager.shared.addOtherIntake(date_: DateGetDay(date: selectedDate), intake_: intake, type_: selectedType, time_: selectedDate)
            presentationMode.wrappedValue.dismiss()
            alertInfo = "补录成功，时间：\(getDateString(date: selectedDate))"
            showAlert = true
        }){
            Text("确定添加")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(colorSet))
                .cornerRadius(10)
                .padding()
        }
        .padding(.top)
        .padding(.bottom)
        .alert("补录", isPresented: $showAlert) {
            Button("确定", role: .cancel) {}
        } message: {
            Text(alertInfo)
        }
    }
}

#Preview {
    AddAnotherView()
}
