//
//  AddWineView.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/10/12.
//

import SwiftUI

struct AddWineView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    @AppStorage("healthSync") private var healthSync = false
    @State private var intake = 100
    @State private var selectedWineType = "啤酒"
    @State private var selectedConcentration = 0
    
    var body: some View {
        ZStack{
            Color(.secondarySystemBackground)
                .ignoresSafeArea()
            
            VStack{
                Spacer()
                
                Image("beer")
                    .resizable()
                    .scaledToFit()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                Text("添加酒")
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
                            .bold()
                            .foregroundColor(.black)
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
                    let alcoholContent = Int(Double(intake) * (Double(selectedConcentration) / 100) * Double(789))
                    DataManager.shared.addWineIntake(date_: DateGetDay(date: Date()), intake_: intake, type_: selectedWineType, concentration_: selectedConcentration, alcoholContent_: alcoholContent, time_: Date())
                    
                    if healthSync {
                        HealthKitManager.addAlcoholIntake(amount: 1, date: Date()) { success, error in
                            if success {
                                print("添加酒精摄入成功")
                            } else {
                                print("添加酒精摄入失败: \(String(describing: error))")
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
                
                Text("*过量饮酒伤身，未成年人禁止饮酒")
                    .padding(.bottom)
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
            }
            .padding(.leading)
            .padding(.trailing)
        }
        .navigationBarTitle("酒", displayMode: .inline)
    }
}

#Preview {
    AddWineView()
}
