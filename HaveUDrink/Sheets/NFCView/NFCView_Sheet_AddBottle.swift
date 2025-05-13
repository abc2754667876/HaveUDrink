//
//  NFCView_Sheet_AddBottle.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/11/9.
//

import SwiftUI

struct NFCView_Sheet_AddBottle: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    
    @State private var bottleName = ""
    @State private var selectedType = "饮用水"
    
    @State private var selectedWineType = "啤酒"
    @State private var selectedConcentration = 0
    @State private var selectedCoffeeType = "不选择"
    @State private var selectedEspressoCount = 1
    @State private var selectedMilkType = "不选择"
    @State private var selectedOtherType = "不选择"
    
    @State private var capacity = 100
    @State private var statsText = "将手机靠近NFC标签，并且不要移动"
    
    @State private var uuid = ""
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(.secondarySystemBackground)
                    .ignoresSafeArea()
                
                ScrollView{
                    VStack{
                        HStack{
                            Text("水杯信息")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .padding(.bottom, 5)
                        .padding(.top)
                        
                        VStack{
                            HStack{
                                Text("水杯名称")
                                    .bold()
                                
                                Spacer()
                                
                                TextField("例如“咖啡杯”", text: $bottleName)
                                    .padding(10)
                                    .background(Color(UIColor.systemGray6))
                                    .cornerRadius(8)
                                    .padding(.leading, 40)
                            }
                            
                            HStack{
                                Text("饮品类型")
                                    .bold()
                                
                                Spacer()
                                
                                Picker("饮品选择", selection: $selectedType) {
                                    Text("饮用水").tag("饮用水")
                                    Text("酒").tag("酒")
                                    Text("咖啡").tag("咖啡")
                                    Text("奶茶").tag("奶茶")
                                    Text("奶").tag("奶")
                                    Text("其他").tag("其他")
                                }
                                .pickerStyle(MenuPickerStyle())
                            }
                        }
                        .padding()
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .background(.white)
                        .cornerRadius(10)
                        
                        if selectedType == "酒" {
                            NFCView_Sheet_AddBottle_Wine(selectedWineType: $selectedWineType, selectedConcentration: $selectedConcentration)
                        } else if selectedType == "咖啡" {
                            NFCView_Sheet_AddBottle_Coffee(selectedCoffeeType: $selectedCoffeeType, selectedEspressoCount: $selectedEspressoCount)
                        } else if selectedType == "奶" {
                            NFCView_Sheet_AddBottle_Milk(selectedMilkType: $selectedMilkType)
                        } else if selectedType == "其他" {
                            NFCView_Sheet_AddBottle_Other(selectedOtherType: $selectedOtherType)
                        }
                        
                        HStack{
                            Text("水杯容量")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .padding(.bottom, 5)
                        .padding(.top)
                        
                        VStack{
                            Slider(
                                value: Binding(
                                    get: { Double(capacity) },  // 将 capacity 转换为 Double
                                    set: { capacity = Int($0) } // 将 Slider 的值转换为 Int
                                ),
                                in: 10...1000, // 设定范围
                                step: 10  // 每次滑动步长
                            )
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                            .padding(.top)
                            .accentColor(Color(colorSet)) // 修改滑块颜色
                            .frame(width: .infinity) // 修改滑块宽度
                            
                            Text("\(capacity)ml")
                                .font(.custom("GenJyuuGothic-Heavy", size:36))
                                .foregroundColor(Color(colorSet))
                                .padding(.bottom)
                        }
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .background(.white)
                        .cornerRadius(10)
                        
                        HStack{
                            Text("设置NFC")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .padding(.bottom, 5)
                        .padding(.top)
                        
                        VStack{
                            Image(systemName: "iphone.gen2.radiowaves.left.and.right")
                                .resizable()
                                .scaledToFit()
                                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                                .foregroundColor(Color(colorSet))
                                .padding(.top, 30)
                            
                            Text(statsText)
                                .foregroundStyle(.gray)
                                .font(.system(size: 15))
                                .padding(.top)
                                .padding(.bottom, 30)
                        }
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .background(.white)
                        .cornerRadius(10)
                    }
                    .padding(.leading)
                    .padding(.trailing)
                    .navigationBarTitle("添加水杯", displayMode: .inline)
                    .navigationBarItems(leading: cancleBtn)
                }
            }
        }
        .onAppear{
            let uuid_ = UUID()
            uuid = uuid_.uuidString
        }
    }
    
    private var cancleBtn: some View{
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }){
            Text("关闭")
                .foregroundStyle(Color(colorSet))
        }
    }
}

struct NFCView_Sheet_AddBottle_Wine: View{
    @Binding var selectedWineType: String
    @Binding var selectedConcentration: Int
    
    var body: some View{
        HStack{
            Text("饮品设置")
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

    }
}

struct NFCView_Sheet_AddBottle_Coffee: View{
    @Binding var selectedCoffeeType: String
    @Binding var selectedEspressoCount: Int
    
    var body: some View{
        HStack{
            Text("饮品设置")
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
                Text("浓缩数量（份）")
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
    }
}

struct NFCView_Sheet_AddBottle_Milk: View{
    @Binding var selectedMilkType: String
    
    var body: some View{
        HStack{
            Text("饮品设置")
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
    }
}

struct NFCView_Sheet_AddBottle_Other: View{
    @Binding var selectedOtherType: String
    
    var body: some View{
        HStack{
            Text("饮品设置")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(.bottom, 5)
        .padding(.top)
        
        VStack{
            HStack{
                Text("饮品类型")
                    .bold()
                Spacer()
                Picker("饮品选择", selection: $selectedOtherType) {
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
    }
}

#Preview {
    NFCView_Sheet_AddBottle()
}
