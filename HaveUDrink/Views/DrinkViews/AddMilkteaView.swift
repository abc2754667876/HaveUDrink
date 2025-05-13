//
//  AddMilkteaView.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/10/12.
//

import SwiftUI

struct AddMilkteaView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    @State private var intake = 100
    
    @State private var selectedMilkteaBrand = "不选择"
    
    var body: some View {
        ZStack{
            Color(.secondarySystemBackground)
                .ignoresSafeArea()
            
            VStack{
                Spacer()
                
                Image("milkTea")
                    .resizable()
                    .scaledToFit()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                Text("添加奶茶")
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
                        Text("品牌")
                            .bold()
                            .foregroundColor(.black)
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
                    DataManager.shared.addMilkteaIntake(date_: DateGetDay(date: Date()), intake_: intake, brand_: selectedMilkteaBrand, time_: Date())
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
        .navigationBarTitle("奶茶", displayMode: .inline)
    }
}

#Preview {
    AddMilkteaView()
}
