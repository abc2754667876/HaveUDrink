//
//  RecordView_Sheet_YearlyRecord.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/10/16.
//

import SwiftUI

struct RecordView_Sheet_YearlyRecord: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    
    @State private var monthSelection = ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"]
    @State private var selectedMonth = "10月"
    @State private var yearSelection = [Int]()
    @State private var selectedYear = 2024
    @State private var nowYear = 2024
    @State private var nowMonth = 1
    @State private var dates: [Date] = []
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(.secondarySystemBackground)
                    .ignoresSafeArea()
                
                VStack{
                    SegmentedPicker(
                        selection: $selectedYear,
                        items: $yearSelection,
                        selectionColor: Color(colorSet)
                    ) { selection in
                        //Text("\(selection)")
                        Text(String(selection))
                    }
                    .padding(.top, 5)
                    .padding(.bottom, 5)
                    
                    Divider()
                    
                    SegmentedPicker(
                        selection: $selectedMonth,
                        items: $monthSelection,
                        selectionColor: Color(colorSet)
                    ) { selection in
                        Text(selection)
                    }
                    .padding(.top, 5)
                    .padding(.bottom, 5)
                    
                    Divider()
                    
                    ScrollView{
                        VStack{
                            let haveRecords = DataManager.shared.monthHaveRecords(year: nowYear, month: nowMonth)
                            if haveRecords {
                                ForEach(dates, id: \.self) { date_ in
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
                            } else {
                                Text("\(nowYear)年\(nowMonth)月无饮水数据")
                                    .font(.system(size: 16))
                                    .foregroundStyle(.gray)
                                    .padding(.top, 250)
                            }
                        }
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(.top)
                    }
                }
            }
            .navigationBarTitle("饮水记录", displayMode: .inline)
            .navigationBarItems(leading: cancleBtn)
        }
        .onAppear{
            updateDates(for: selectedMonth)
            selectedMonth = "\(getCurrentMonth())月"
            nowYear = getCurrentYear()
            nowMonth = getCurrentMonth()
            yearSelection = (getCurrentYear() - 10...getCurrentYear()).map { $0 }
            selectedYear = getCurrentYear()
        }
        .onChange(of: selectedMonth) {
            updateDates(for: selectedMonth)
        }
        .onChange(of: selectedYear) {
            nowYear = selectedYear
        }
    }
    
    private func updateDates(for month: String) {
        switch month {
        case "1月": 
            dates = getMonthAndYearAllDates(inYear: getYear(from: Date()), month: 1)
            nowMonth = 1
        case "2月":
            dates = getMonthAndYearAllDates(inYear: getYear(from: Date()), month: 2)
            nowMonth = 2
        case "3月":
            dates = getMonthAndYearAllDates(inYear: getYear(from: Date()), month: 3)
            nowMonth = 3
        case "4月":
            dates = getMonthAndYearAllDates(inYear: getYear(from: Date()), month: 4)
            nowMonth = 4
        case "5月":
            dates = getMonthAndYearAllDates(inYear: getYear(from: Date()), month: 5)
            nowMonth = 5
        case "6月":
            dates = getMonthAndYearAllDates(inYear: getYear(from: Date()), month: 6)
            nowMonth = 6
        case "7月":
            dates = getMonthAndYearAllDates(inYear: getYear(from: Date()), month: 7)
            nowMonth = 7
        case "8月":
            dates = getMonthAndYearAllDates(inYear: getYear(from: Date()), month: 8)
            nowMonth = 8
        case "9月":
            dates = getMonthAndYearAllDates(inYear: getYear(from: Date()), month: 9)
            nowMonth = 9
        case "10月":
            dates = getMonthAndYearAllDates(inYear: getYear(from: Date()), month: 10)
            nowMonth = 10
        case "11月":
            dates = getMonthAndYearAllDates(inYear: getYear(from: Date()), month: 11)
            nowMonth = 11
        case "12月":
            dates = getMonthAndYearAllDates(inYear: getYear(from: Date()), month: 12)
            nowMonth = 12
        default:
            dates = getMonthAndYearAllDates(inYear: getYear(from: Date()), month: 1)
            nowMonth = 1
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

#Preview {
    RecordView_Sheet_YearlyRecord()
}
