//
//  AddWaterView.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/10/11.
//

import SwiftUI

struct AddWaterView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    @AppStorage("healthSync") private var healthSync = false
    @State private var intake = 100
    
    var body: some View {
        ZStack{
            Color(.secondarySystemBackground)
                .ignoresSafeArea()

            VStack{
                Spacer()
                
                Image("water")
                    .resizable()
                    .scaledToFit()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                Text("添加饮用水")
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
                
                Spacer()
                
                Button(action: {
                    DataManager.shared.addWaterIntake(date_: DateGetDay(date: Date()), intake_: intake, time_: Date())
                    
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
            }
            .padding(.trailing)
            .padding(.leading)
        }
        .navigationBarTitle("饮用水", displayMode: .inline)
    }
}

#Preview {
    AddWaterView()
}
