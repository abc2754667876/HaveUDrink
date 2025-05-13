//
//  RecordView_Sheet_WeeklyAndMonthlyRecord.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/10/16.
//

import SwiftUI

struct RecordView_Sheet_WeeklyAndMonthlyRecord: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    
    @Binding var startDate: Date
    let today = Date()
    
    // 生成从起始日期到当天的所有日期
    var dateRange: [Date] {
        var dates: [Date] = []
        var currentDate = startDate
        let calendar = Calendar.current
        
        while currentDate <= today {
            dates.append(currentDate)
            // 增加一天
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return dates
    }
    
    var body: some View {
        NavigationView {
            ZStack{
                Color(.secondarySystemBackground)
                    .ignoresSafeArea()
                ScrollView{
                    VStack{
                        ForEach(dateRange, id: \.self) { date_ in
                            let intakes = DataManager.shared.getDateAllIntakes_OrderByTime(for: DateGetDay(date: date_))
                            if intakes.count != 0 {
                                HStack{
                                    Text("\(getYear(from: date_))年\(getMonth(from: date_))月\(getDay(from: date_))日")
                                        .font(.system(size: 14))
                                        .foregroundStyle(.gray)
                                    
                                    CircularProgressView(progress: DataManager.shared.getDateProgress(date_: DateGetDay(date: date_)))
                                        .frame(width: 20, height: 20)
                                    
                                    Spacer()
                                }
                                .padding(.bottom, 1)
                                
                                VStack{
                                    VStack{
                                        ForEach(intakes, id: \.uuid) { intake in
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
                                .padding(.bottom)
                            }
                        }
                    }
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.top)
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

private struct CircularProgressView: View {
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    
    var progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(colorSet).opacity(0.15), lineWidth: 3) // 背景圆圈
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(AngularGradient(gradient: Gradient(colors: [Color(colorSet), Color(colorSet)]), center: .center),
                        style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .rotationEffect(.degrees(-90)) // 将进度条从顶部开始
        }
    }
}
