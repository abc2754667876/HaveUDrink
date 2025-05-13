//
//  NFCDrinkView_Single_Add.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/11/9.
//

import SwiftUI

struct NFCDrinkView_Single_Add: View {
    @Environment(\.presentationMode) var presentationMode
    
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    
    @AppStorage("nfcDrink_bottleName") private var bottleName = ""
    @AppStorage("nfcDrink_type") private var selectedType = "饮用水"
    
    @AppStorage("nfcDrink_wineType") private var selectedWineType = "啤酒"
    @AppStorage("nfcDrink_concentration") private var selectedConcentration = 0
    @AppStorage("nfcDrink_coffeeType") private var selectedCoffeeType = "不选择"
    @AppStorage("nfcDrink_espressoCount") private var selectedEspressoCount = 1
    @AppStorage("nfcDrink_milkType") private var selectedMilkType = "不选择"
    @AppStorage("nfcDrink_otherType") private var selectedOtherType = "不选择"
    
    @AppStorage("nfcDrink_capacity") private var capacity = 100
    @AppStorage("nfcDrink_needEnsure") private var needEnsure = false
    @AppStorage("healthSync") private var healthSync = false
    
    @State private var buttonTitle = "确认添加"
    @State private var statsText = ""
    @State private var added = false
    
    var body: some View {
        ZStack{
            Color(.secondarySystemBackground)
                .ignoresSafeArea()
            
            VStack{
                if needEnsure {
                    ZStack{
                        if added {
                            Image(systemName: "checkmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70)
                                .foregroundColor(Color(colorSet))
                        } else {
                            Image(systemName: "cup.and.saucer.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100)
                                .foregroundColor(Color(colorSet))
                        }
                    }
                    
                    Text(statsText)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.top)
                    
                    Button(action: {
                        if buttonTitle == "确认添加" {
                            addIntake()
                            buttonTitle = "返回"
                            statsText = "已向\(bottleName)中添加了\(capacity)ml的\(selectedType)摄入"
                            added = true
                        } else if buttonTitle == "返回" {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }){
                        Text(buttonTitle)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(colorSet))
                            .cornerRadius(10)
                    }
                    .padding(.top, 50)
                    .padding(.bottom)
                } else {
                    Image(systemName: "checkmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                        .foregroundColor(Color(colorSet))
                    
                    Text("已向\(bottleName)中添加了\(capacity)ml的\(selectedType)摄入")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.top)
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }){
                        Text("返回")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(colorSet))
                            .cornerRadius(10)
                    }
                    .padding(.top, 50)
                    .padding(.bottom)
                }
            }
            .padding()
        }
        .onAppear{
            if needEnsure {
                statsText = "点击下方按钮，确认向\(bottleName)中添加\(capacity)ml的\(selectedType)摄入"
            } else {
                addIntake()
            }
        }
    }
    
    private func addIntake(){
        if selectedType == "饮用水" {
            if healthSync {
                HealthKitManager.addWaterIntake(amount: Double(capacity), date: Date()) { success, error in
                    if success {
                        print("已添加水摄入")
                    } else {
                        print("添加水摄入失败: \(String(describing: error))")
                    }
                }
            }
            DataManager.shared.addWaterIntake(date_: DateGetDay(date: Date()), intake_: capacity, time_: Date())
        } else if selectedType == "酒" {
            let alcoholContent = Int(Double(capacity) * (Double(selectedConcentration) / 100) * Double(789))
            DataManager.shared.addWineIntake(date_: DateGetDay(date: Date()), intake_: capacity, type_: selectedWineType, concentration_: selectedConcentration, alcoholContent_: alcoholContent, time_: Date())
            if healthSync {
                HealthKitManager.addAlcoholIntake(amount: 1, date: Date()) { success, error in
                    if success {
                        print("添加酒精摄入成功")
                    } else {
                        print("添加酒精摄入失败: \(String(describing: error))")
                    }
                }
            }
        } else if selectedType == "咖啡" {
            DataManager.shared.addCoffeeIntake(date_: DateGetDay(date: Date()), intake_: capacity, type_: selectedCoffeeType, brand_: "不选择", espressoCount_: selectedEspressoCount, caffeeine_: selectedEspressoCount * 63, time_: Date())
            if healthSync {
                HealthKitManager.addCaffeineIntake(amount: Double(selectedEspressoCount * 63), date: Date()) { success, error in
                    if success {
                        print("已添加咖啡因摄入")
                    } else {
                        print("添加咖啡因摄入失败: \(String(describing: error))")
                    }
                }
            }
        } else if selectedType == "奶茶" {
            DataManager.shared.addMilkteaIntake(date_: DateGetDay(date: Date()), intake_: capacity, brand_: "不选择", time_: Date())
        } else if selectedType == "奶" {
            DataManager.shared.addMilkIntake(date_: DateGetDay(date: Date()), intake_: capacity, type_: selectedMilkType, time_: Date())
        } else if selectedType == "其他" {
            DataManager.shared.addOtherIntake(date_: DateGetDay(date: Date()), intake_: capacity, type_: selectedOtherType, time_: Date())
        }
    }
}

#Preview {
    NFCDrinkView_Single_Add()
}
