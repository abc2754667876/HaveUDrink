//
//  AddCoffeeView.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/10/12.
//

import SwiftUI

struct AddCoffeeView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    @AppStorage("healthSync") private var healthSync = false
    @State private var intake = 100
    @State private var selectedCoffeeType = "不选择"
    @State private var selectedCoffeeBrand = "不选择"
    @State private var selectedEspressoCount = 1
    
    var body: some View {
        ZStack{
            Color(.secondarySystemBackground)
                .ignoresSafeArea()
            
            VStack{
                Spacer()
                
                Image("coffee")
                    .resizable()
                    .scaledToFit()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                Text("添加咖啡")
                    .bold()
                    .font(.system(size: 28))
                
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
                            .bold()
                            .foregroundColor(.black)
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
                            .bold()
                            .foregroundColor(.black)
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
                            .bold()
                            .foregroundColor(.black)
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
                    DataManager.shared.addCoffeeIntake(date_: DateGetDay(date: Date()), intake_: intake, type_: selectedCoffeeType, brand_: selectedCoffeeBrand, espressoCount_: selectedEspressoCount, caffeeine_: selectedEspressoCount * 63, time_: Date())
                    
                    if healthSync {
                        HealthKitManager.addCaffeineIntake(amount: Double(selectedEspressoCount * 63), date: Date()) { success, error in
                            if success {
                                print("已添加咖啡因摄入")
                            } else {
                                print("添加咖啡因摄入失败: \(String(describing: error))")
                            }
                        }
                    }
                    
                    presentationMode.wrappedValue.dismiss()
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
            }
            .padding(.leading)
            .padding(.trailing)
        }
        .navigationBarTitle("咖啡", displayMode: .inline)
    }
}

#Preview {
    AddCoffeeView()
}
