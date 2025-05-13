//
//  WaterDatePicker.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/10/13.
//

import SwiftUI

struct WaterDatePicker: View {
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    
    @Binding var selectedDate: Date?  // 由外部传入当前选中的日期
    let progressData: [Date: Double]  // 由外部传入进度数据
    let month: Int                    // 由外部传入的月份
    let year: Int                     // 由外部传入的年份
    
    @State private var _month = 0
    @State private var _year = 0
    
    let calendar = Calendar.current
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"    // 显示日期格式
        return formatter
    }()
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 20) {
                    Button(action: {
                        substractYearAndMonth()
                    }){
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20))
                            .foregroundColor(Color(colorSet))
                    }
                    
                    ForEach(generateDates(year: _year, month: _month), id: \.self) { date in
                        dateView(for: date)
                            .id(date)  // 给每个日期视图分配唯一 ID
                    }
                    
                    Button(action: {
                        plusYearAndMonth()
                    }){
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20))
                            .foregroundColor(Color(colorSet))
                    }
                }
                .padding(.trailing)
                .padding(.leading)
            }
            .onAppear {
                _month = month
                _year = year
                
                // 在视图加载时滚动到今天
                if let today = calendar.date(from: DateComponents(year: year, month: month, day: getCurrentDay())) {
                    scrollProxy.scrollTo(today, anchor: .center)
                }
            }
        }
    }
    
    // 日期视图：上部分显示日期，下部分显示圆形进度条
    private func dateView(for date: Date) -> some View {
        let isSelected = selectedDate == date
        let progress = progressData[date] ?? 0.0
        
        return VStack(spacing: 10) {
            // 显示日期
            Text(dateFormatter.string(from: date))
                .font(.custom("GenJyuuGothic-Medium", size:15))
                .foregroundColor(isSelected ? .white : .gray)
                .frame(width: 25, height: 25)  // 固定宽高
                .background(isSelected ? Color(colorSet) : Color.clear)  // 设置选中时的背景颜色
                .clipShape(Circle())  // 将背景设为圆形
            
            // 显示进度条
            CircularProgressView(progress: progress)
                .frame(width: 30, height: 30)
        }
        .onTapGesture {
            selectedDate = date
        }
    }
    
    // 生成某个年份的某个月的所有日期
    private func generateDates(year: Int, month: Int) -> [Date] {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1 // 月份的第一天
        guard let startDate = calendar.date(from: components) else {
            return []
        }
        // 获取该月的天数范围
        guard let range = calendar.range(of: .day, in: .month, for: startDate) else {
            return []
        }
        // 生成该月的所有日期
        return range.compactMap { day -> Date? in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)
        }
    }
    
    // 获取今天的日期
    private func getCurrentDay() -> Int {
        let today = Date()
        let components = calendar.dateComponents([.day], from: today)
        return components.day ?? 1
    }
    
    private func subtractMonth(month_: Int) -> Int {
        if month_ == 1 {
            return 12
        } else {
            return month_ - 1
        }
    }
    
    private func plusMonth(month_: Int) -> Int {
        if month_ == 12 {
            return 1
        } else {
            return month_ + 1
        }
    }
    
    private func substractYearAndMonth(){
        self._month = subtractMonth(month_: _month)
        if _month == 12 {
            _year -= 1
        }
        self.selectedDate = createDate(year: _year, month: _month, day: 1)
    }
    
    private func plusYearAndMonth(){
        self._month = plusMonth(month_: _month)
        if _month == 1 {
            _year += 1
        }
        self.selectedDate = createDate(year: _year, month: _month, day: 1)
    }
}

private struct CircularProgressView: View {
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    
    var progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(colorSet).opacity(0.15), lineWidth: 4) // 背景圆圈
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(AngularGradient(gradient: Gradient(colors: [Color(colorSet), Color(colorSet)]), center: .center),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90)) // 将进度条从顶部开始
        }
    }
}
