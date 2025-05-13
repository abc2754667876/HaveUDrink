//
//  RecordView_Sheet_DailyRecord.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/10/15.
//

import SwiftUI

struct RecordView_Sheet_DailyRecord: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    
    @Binding var date_: Date?
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(.secondarySystemBackground)
                    .ignoresSafeArea()
                
                ScrollView{
                    VStack{
                        let intakes = DataManager.shared.getDateAllIntakes_GroupByHour(for: DateGetDay(date: date_!))
                        let groupedIntakes = Dictionary(grouping: intakes, by: { $0.hour })
                        
                        ForEach(groupedIntakes.keys.sorted(), id: \.self) { hour in
                            HStack{
                                Text(hour)
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 14))
                                Spacer()
                            }
                            .padding(.top)
                            
                            VStack{
                                VStack{
                                    ForEach(groupedIntakes[hour]!.indices, id: \.self) { index in
                                        let intake = groupedIntakes[hour]![index]
                                        
                                        HStack{
                                            if intake.name == "水" {
                                                Image("water")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 35)
                                            } else if intake.name == "酒" {
                                                Image("beer")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 35)
                                            } else if intake.name == "咖啡" {
                                                Image("coffee")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 35)
                                            } else if intake.name == "奶茶" {
                                                Image("milkTea")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 35)
                                            } else if intake.name == "奶" {
                                                Image("milk")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 35)
                                            } else if intake.name == "其他" {
                                                Image("yinliao")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 35)
                                            }
                                            
                                            Text(intake.name)
                                                .font(.system(size: 18))
                                                .bold()
                                                .padding(.leading, 1)
                                                .foregroundStyle(.black)
                                            
                                            HStack{
                                                if intake.type != "-" {
                                                    smallLable(content: intake.type)
                                                }
                                                if intake.brand != "-" {
                                                    smallLable(content: intake.brand)
                                                }
                                                if intake.concentration != "-" {
                                                    smallLable(content: "\(intake.concentration)度")
                                                }
                                                if intake.espressoCount != "-" {
                                                    smallLable(content: "\(intake.espressoCount)份浓缩")
                                                }
                                            }
                                            
                                            Spacer()
                                            
                                            Text("\(intake.intake)ml")
                                                .font(.custom("GenJyuuGothic-Heavy", size:24))
                                                .foregroundStyle(Color(colorSet))
                                        }
                                        .padding(.leading)
                                        .padding(.trailing)
                                    }
                                }
                                .padding(.top)
                                .padding(.bottom)
                            }
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            .background(.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.leading)
                    .padding(.trailing)
                    .navigationBarTitle("饮水记录", displayMode: .inline)
                    .navigationBarItems(leading: cancleBtn)
                }
            }
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
    
    // 小标签
    private func smallLable(content: String) -> some View {
        HStack{
            Text(content)
                .font(.system(size: 14))
                .padding(.top, 3)
                .padding(.bottom, 3)
                .padding(.leading, 5)
                .padding(.trailing, 5)
                .foregroundColor(Color(colorSet))
        }
        .background(Color(colorSet).opacity(0.15))
        .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
    }
}
