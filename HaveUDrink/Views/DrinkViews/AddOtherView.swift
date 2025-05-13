//
//  AddOtherView.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/10/12.
//

import SwiftUI

struct AddOtherView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    @State private var intake = 100
    
    @State private var selectedType = "不选择"
    
    var body: some View {
        ZStack{
            Color(.secondarySystemBackground)
                .ignoresSafeArea()
            
            VStack{
                Spacer()
                
                Image("yinliao")
                    .resizable()
                    .scaledToFit()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                Text("添加其他饮品")
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
                    DataManager.shared.addOtherIntake(date_: DateGetDay(date: Date()), intake_: intake, type_: selectedType, time_: Date())
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
            .padding(.trailing)
            .padding(.leading)
        }
        .navigationBarTitle("其他饮品", displayMode: .inline)
    }
}

#Preview {
    AddOtherView()
}
