//
//  AddMilkView.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/10/12.
//

import SwiftUI

struct AddMilkView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    @State private var intake = 100
    
    @State private var selectedMilkType = "不选择"
    
    var body: some View {
        ZStack{
            Color(.secondarySystemBackground)
                .ignoresSafeArea()
            
            VStack{
                Spacer()
                
                Image("milk")
                    .resizable()
                    .scaledToFit()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                Text("添加奶")
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
                        Text("奶类型")
                            .bold()
                            .foregroundColor(.black)
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
                    DataManager.shared.addMilkIntake(date_: DateGetDay(date: Date()), intake_: intake, type_: selectedMilkType, time_: Date())
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
        .navigationBarTitle("奶", displayMode: .inline)
    }
}

#Preview {
    AddMilkView()
}
