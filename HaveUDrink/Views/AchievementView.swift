//
//  RemindView.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/10/13.
//

import SwiftUI

struct AchievementView: View {
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    
    @State private var navigationTitle = "成就"
    @State private var showAchieved = false
    @State private var achievementTitle_ = ""
    @State private var medalName_ = ""
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(.secondarySystemBackground)
                    .ignoresSafeArea()
                
                ScrollView{
                    VStack {
                        HStack{
                            Text("健康饮水")
                                .bold()
                                .font(.system(size: 20))
                            
                            Spacer()
                        }
                        
                        AchievementCard(title: "连续1天饮水合环", progress: Double(DataManager.shared.getMaximumConsecutiveCompletionDay()) / Double(1), achieved: isAchieved(day1: DataManager.shared.getMaximumConsecutiveCompletionDay(), day2: 1), medalName: "finish-1-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        AchievementCard(title: "连续3天饮水合环", progress: Double(DataManager.shared.getMaximumConsecutiveCompletionDay()) / Double(3), achieved: isAchieved(day1: DataManager.shared.getMaximumConsecutiveCompletionDay(), day2: 3), medalName: "finish-3-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        AchievementCard(title: "连续7天饮水合环", progress: Double(DataManager.shared.getMaximumConsecutiveCompletionDay()) / Double(7), achieved: isAchieved(day1: DataManager.shared.getMaximumConsecutiveCompletionDay(), day2: 7), medalName: "finish-7-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        AchievementCard(title: "连续15天饮水合环", progress: Double(DataManager.shared.getMaximumConsecutiveCompletionDay()) / Double(15), achieved: isAchieved(day1: DataManager.shared.getMaximumConsecutiveCompletionDay(), day2: 15), medalName: "finish-15-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        AchievementCard(title: "连续30天饮水合环", progress: Double(DataManager.shared.getMaximumConsecutiveCompletionDay()) / Double(30), achieved: isAchieved(day1: DataManager.shared.getMaximumConsecutiveCompletionDay(), day2: 30), medalName: "finish-30-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        AchievementCard(title: "连续100天饮水合环", progress: Double(DataManager.shared.getMaximumConsecutiveCompletionDay()) / Double(100), achieved: isAchieved(day1: DataManager.shared.getMaximumConsecutiveCompletionDay(), day2: 100), medalName: "finish-100-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        AchievementCard(title: "连续365天饮水合环", progress: Double(DataManager.shared.getMaximumConsecutiveCompletionDay()) / Double(365), achieved: isAchieved(day1: DataManager.shared.getMaximumConsecutiveCompletionDay(), day2: 365), medalName: "finish-365-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        
                        HStack{
                            Text("不饮酒")
                                .bold()
                                .font(.system(size: 20))
                            
                            Spacer()
                        }
                        .padding(.top)
                        
                        AchievementCard(title: "连续1天不摄入酒精", progress: Double(DataManager.shared.getMaximumUnAlcoholDay()) / Double(1), achieved: isAchieved(day1: DataManager.shared.getMaximumUnAlcoholDay(), day2: 1), medalName: "alcohol-1-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        AchievementCard(title: "连续3天不摄入酒精", progress: Double(DataManager.shared.getMaximumUnAlcoholDay()) / Double(3), achieved: isAchieved(day1: DataManager.shared.getMaximumUnAlcoholDay(), day2: 3), medalName: "alcohol-3-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        AchievementCard(title: "连续7天不摄入酒精", progress: Double(DataManager.shared.getMaximumUnAlcoholDay()) / Double(7), achieved: isAchieved(day1: DataManager.shared.getMaximumUnAlcoholDay(), day2: 7), medalName: "alcohol-7-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        AchievementCard(title: "连续15天不摄入酒精", progress: Double(DataManager.shared.getMaximumUnAlcoholDay()) / Double(15), achieved: isAchieved(day1: DataManager.shared.getMaximumUnAlcoholDay(), day2: 15), medalName: "alcohol-15-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        AchievementCard(title: "连续30天不摄入酒精", progress: Double(DataManager.shared.getMaximumUnAlcoholDay()) / Double(30), achieved: isAchieved(day1: DataManager.shared.getMaximumUnAlcoholDay(), day2: 30), medalName: "alcohol-30-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        AchievementCard(title: "连续100天不摄入酒精", progress: Double(DataManager.shared.getMaximumUnAlcoholDay()) / Double(100), achieved: isAchieved(day1: DataManager.shared.getMaximumUnAlcoholDay(), day2: 100), medalName: "alcohol-100-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        AchievementCard(title: "连续365天不摄入酒精", progress: Double(DataManager.shared.getMaximumUnAlcoholDay()) / Double(365), achieved: isAchieved(day1: DataManager.shared.getMaximumUnAlcoholDay(), day2: 365), medalName: "alcohol-365-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        
                        HStack{
                            Text("不喝咖啡")
                                .bold()
                                .font(.system(size: 20))
                            
                            Spacer()
                        }
                        .padding(.top)
                        
                        AchievementCard(title: "连续1天不摄入咖啡因", progress: Double(DataManager.shared.getMaximumUnCoffeeineDay()) / Double(1), achieved: isAchieved(day1: DataManager.shared.getMaximumUnCoffeeineDay(), day2: 1), medalName: "coffeeine-1-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        AchievementCard(title: "连续3天不摄入咖啡因", progress: Double(DataManager.shared.getMaximumUnCoffeeineDay()) / Double(3), achieved: isAchieved(day1: DataManager.shared.getMaximumUnCoffeeineDay(), day2: 3), medalName: "coffeeine-3-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        AchievementCard(title: "连续7天不摄入咖啡因", progress: Double(DataManager.shared.getMaximumUnCoffeeineDay()) / Double(7), achieved: isAchieved(day1: DataManager.shared.getMaximumUnCoffeeineDay(), day2: 7), medalName: "coffeeine-7-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        AchievementCard(title: "连续15天不摄入咖啡因", progress: Double(DataManager.shared.getMaximumUnCoffeeineDay()) / Double(15), achieved: isAchieved(day1: DataManager.shared.getMaximumUnCoffeeineDay(), day2: 15), medalName: "coffeeine-15-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        AchievementCard(title: "连续30天不摄入咖啡因", progress: Double(DataManager.shared.getMaximumUnCoffeeineDay()) / Double(30), achieved: isAchieved(day1: DataManager.shared.getMaximumUnCoffeeineDay(), day2: 30), medalName: "coffeeine-30-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        AchievementCard(title: "连续100天不摄入咖啡因", progress: Double(DataManager.shared.getMaximumUnCoffeeineDay()) / Double(100), achieved: isAchieved(day1: DataManager.shared.getMaximumUnCoffeeineDay(), day2: 100), medalName: "coffeeine-100-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        AchievementCard(title: "连续365天不摄入咖啡因", progress: Double(DataManager.shared.getMaximumUnCoffeeineDay()) / Double(365), achieved: isAchieved(day1: DataManager.shared.getMaximumUnCoffeeineDay(), day2: 365), medalName: "coffeeine-365-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        
                        HStack{
                            Text("不喝奶茶")
                                .bold()
                                .font(.system(size: 20))
                            
                            Spacer()
                        }
                        .padding(.top)
                        
                        AchievementCard(title: "连续1天不喝奶茶", progress: Double(DataManager.shared.getMaximumUnMilkTeaDay()) / Double(1), achieved: isAchieved(day1: DataManager.shared.getMaximumUnMilkTeaDay(), day2: 1), medalName: "milkTea-1-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        AchievementCard(title: "连续3天不喝奶茶", progress: Double(DataManager.shared.getMaximumUnMilkTeaDay()) / Double(3), achieved: isAchieved(day1: DataManager.shared.getMaximumUnMilkTeaDay(), day2: 3), medalName: "milkTea-3-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        AchievementCard(title: "连续7天不喝奶茶", progress: Double(DataManager.shared.getMaximumUnMilkTeaDay()) / Double(7), achieved: isAchieved(day1: DataManager.shared.getMaximumUnMilkTeaDay(), day2: 7), medalName: "milkTea-7-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        AchievementCard(title: "连续15天不喝奶茶", progress: Double(DataManager.shared.getMaximumUnMilkTeaDay()) / Double(15), achieved: isAchieved(day1: DataManager.shared.getMaximumUnMilkTeaDay(), day2: 15), medalName: "milkTea-15-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        AchievementCard(title: "连续30天不喝奶茶", progress: Double(DataManager.shared.getMaximumUnMilkTeaDay()) / Double(30), achieved: isAchieved(day1: DataManager.shared.getMaximumUnMilkTeaDay(), day2: 30), medalName: "milkTea-30-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        AchievementCard(title: "连续100天不喝奶茶", progress: Double(DataManager.shared.getMaximumUnMilkTeaDay()) / Double(100), achieved: isAchieved(day1: DataManager.shared.getMaximumUnMilkTeaDay(), day2: 100), medalName: "milkTea-100-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        AchievementCard(title: "连续365天不喝奶茶", progress: Double(DataManager.shared.getMaximumUnMilkTeaDay()) / Double(365), achieved: isAchieved(day1: DataManager.shared.getMaximumUnMilkTeaDay(), day2: 365), medalName: "milkTea-365-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        
                        HStack{
                            Text("睡前一杯奶")
                                .bold()
                                .font(.system(size: 20))
                            
                            Spacer()
                        }
                        .padding(.top)
                        
                        AchievementCard(title: "连续1天喝牛奶", progress: Double(DataManager.shared.getMaximumMilkDay()) / Double(1), achieved: isAchieved(day1: DataManager.shared.getMaximumMilkDay(), day2: 1), medalName: "milk-1-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        AchievementCard(title: "连续3天喝牛奶", progress: Double(DataManager.shared.getMaximumMilkDay()) / Double(3), achieved: isAchieved(day1: DataManager.shared.getMaximumMilkDay(), day2: 3), medalName: "milk-3-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        AchievementCard(title: "连续7天喝牛奶", progress: Double(DataManager.shared.getMaximumMilkDay()) / Double(7), achieved: isAchieved(day1: DataManager.shared.getMaximumMilkDay(), day2: 7), medalName: "milk-7-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        AchievementCard(title: "连续15天喝牛奶", progress: Double(DataManager.shared.getMaximumMilkDay()) / Double(15), achieved: isAchieved(day1: DataManager.shared.getMaximumMilkDay(), day2: 15), medalName: "milk-15-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        AchievementCard(title: "连续30天喝牛奶", progress: Double(DataManager.shared.getMaximumMilkDay()) / Double(30), achieved: isAchieved(day1: DataManager.shared.getMaximumMilkDay(), day2: 30), medalName: "milk-30-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        AchievementCard(title: "连续100天喝牛奶", progress: Double(DataManager.shared.getMaximumMilkDay()) / Double(100), achieved: isAchieved(day1: DataManager.shared.getMaximumMilkDay(), day2: 100), medalName: "milk-100-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        AchievementCard(title: "连续365天喝牛奶", progress: Double(DataManager.shared.getMaximumMilkDay()) / Double(365), achieved: isAchieved(day1: DataManager.shared.getMaximumMilkDay(), day2: 365), medalName: "milk-365-get", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        
                        HStack{
                            Text("坚持奖牌")
                                .bold()
                                .font(.system(size: 20))
                            
                            Spacer()
                        }
                        .padding(.top)
                        
                        AchievementCard(title: "连续15天饮水合环且仅饮水", progress: Double(DataManager.shared.getMaximumOnlyWaterDay()) / Double(15), achieved: isAchieved(day1: DataManager.shared.getMaximumOnlyWaterDay(), day2: 15), medalName: "medal_tong", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        AchievementCard(title: "连续30天饮水合环且仅饮水", progress: Double(DataManager.shared.getMaximumOnlyWaterDay()) / Double(30), achieved: isAchieved(day1: DataManager.shared.getMaximumOnlyWaterDay(), day2: 30), medalName: "medal_yin", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        AchievementCard(title: "连续60天饮水合环且仅饮水", progress: Double(DataManager.shared.getMaximumOnlyWaterDay()) / Double(60), achieved: isAchieved(day1: DataManager.shared.getMaximumOnlyWaterDay(), day2: 60), medalName: "medal_jin", showAchieved: $showAchieved, achievementTitle_: $achievementTitle_, medalName_: $medalName_)
                        HStack{
                            Text("*获得坚持金牌后将解锁金色颜色主题")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            
                            Spacer()
                        }
                    }
                    .padding()
                }
                .navigationTitle(navigationTitle)
                
                if showAchieved {
                    ZStack{
                        ZStack{
                            Color(.black)
                                .ignoresSafeArea()
                        }
                        .opacity(showAchieved ? 0.5 : 0)
                        
                        VStack{
                            HStack{
                                Spacer()
                                
                                Button(action: {
                                    withAnimation(.easeIn(duration: 0.5)) {
                                        showAchieved.toggle()
                                    }
                                }){
                                    Image(systemName: "xmark.circle")
                                        .foregroundColor(.white)
                                        .font(.system(size: 24))
                                }
                            }
                            .frame(width: 270)
                            .padding(.bottom, 5)
                            
                            //CompleteView(showAchieved: $showAchieved, intake: $intake, navigationTitle: $navigationTitle)
                            
                            AchievedView(showAchieved: $showAchieved, achievementTitle: $achievementTitle_, navigationTitle: $navigationTitle, medalName: $medalName_)
                        }
                    }
                }
            }
        }
    }
    
    //day1是实际天数，day2是目标天数
    private func isAchieved(day1: Int, day2: Int) -> Bool{
        if day1 >= day2 {
            return true
        } else {
            return false
        }
    }
}

private struct AchievementCard: View {
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    @State private var sealColor = Color(.gray)
    
    var title: String
    var progress: Double
    var achieved: Bool
    var medalName: String
    @Binding var showAchieved: Bool
    @Binding var achievementTitle_: String
    @Binding var medalName_: String
    
    var body: some View {
        Button(action: {
            if achieved {
                achievementTitle_ = title
                medalName_ = medalName
                withAnimation(.easeInOut(duration: 0.5)) {
                    showAchieved = true
                }
            }
        }){
            HStack{
                if achieved {
                    Image(medalName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60)
                        .padding(.top)
                        .padding(.bottom)
                        .padding(.leading)
                } else {
                    Image(medalName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60)
                        .padding(.top)
                        .padding(.bottom)
                        .padding(.leading)
                        .opacity(0.2)
                }
                
                VStack(alignment: .leading){
                    HStack{
                        Text(title)
                            .font(.system(size: 18))
                            .bold()
                            .foregroundStyle(.black)
                        
                        if achieved {
                            Image("medal")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18)
                        }
                    }
                    
                    CustomProgressBar(progress: progress)
                        .padding(.trailing)
                }
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .background(.white)
            .cornerRadius(10)
            .padding(.top, 1)
            .padding(.bottom, 5)
            .onAppear{
                if achieved {
                    sealColor = Color(.green)
                } else {
                    sealColor = Color(.gray)
                }
            }

        }
    }
}

private struct CustomProgressBar: View {
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    var progress: Double // 进度值，范围从 0.0 到 1.0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if progress < 0.99 {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(Color.gray.opacity(0.1)) // 背景条
                        .frame(height: 20)
                    
                    HStack{
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color(colorSet)) // 进度条颜色
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            .frame(width: geometry.size.width * CGFloat(progress), height: 20)
                            .animation(.easeInOut(duration: 0.5), value: progress) // 动画效果
                        Spacer()
                    }
                } else {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(Color(colorSet)) // 背景条
                        .frame(height: 20)
                }
            }
        }
        .frame(height: 25) // 整个控件的高度
    }
}

struct AchievedView: View{
    @State private var colorSet = "goldColor"
    
    @Binding var showAchieved: Bool
    @Binding var achievementTitle: String
    @Binding var navigationTitle: String
    @Binding var medalName: String
    
    @State private var showingShareSheet = false
    @State private var goalAchievedImage: UIImage? = nil
    
    var body: some View{
        ZStack{
            ZStack{
                VStack{
                    ZStack{
                        Text("CONGRATULATION")
                            .font(.custom("GenJyuuGothic-Heavy", size:16))
                            .foregroundStyle(Color(colorSet))
                            .padding(.top)
                            .opacity(0.2)
                        
                        Text("获得成就")
                            .bold()
                            .foregroundColor(.black)
                            .font(.system(size: 21))
                    }
                    
                    Image(medalName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 170)
                    
                    Text("我获得了“\(achievementTitle)”的饮水成就")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .padding(.top)
                        .padding(.leading)
                        .padding(.trailing)
                    
                    Button(action: {
                        goalAchievedImage = generateGoalAchievedImage()
                        showingShareSheet = true
                    }){
                        Text("分享")
                            .padding(.top)
                            .padding(.bottom)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            .background(Color(colorSet))
                            .cornerRadius(100)
                            .foregroundColor(.white)
                            .bold()
                    }
                    .padding(.top)
                    .padding(.leading)
                    .padding(.trailing)

                }
            }
            .frame(width: 270, height: 400)
            .background(LinearGradient(gradient: Gradient(colors: [Color(colorSet).opacity(0.15), Color(colorSet).opacity(0.05)]),
                                       startPoint: .top,
                                       endPoint: .bottom))
        }
        .background(.white)
        .cornerRadius(15)
        .blur(radius: showAchieved ? 0 : 30)
        .opacity(showAchieved ? 1 : 0)
        .shadow(color: Color.gray.opacity(0.2), radius: 10)
        .sheet(isPresented: $showingShareSheet) {
            if let image = goalAchievedImage {
                ShareSheet(activityItems: [image])
            }
        }
    }
    
    @MainActor func generateGoalAchievedImage() -> UIImage {
        let renderer = ImageRenderer(content: AchievedView_Generate(showAchieved: $showAchieved, achievementTitle: $achievementTitle, navigationTitle: $navigationTitle, medalName: $medalName))
        // 设置渲染器的透明背景
        renderer.scale = UIScreen.main.scale
        renderer.isOpaque = false  // 设置为透明
        
        // 导出PNG格式
        return renderer.uiImage?.pngData().flatMap { UIImage(data: $0) } ?? UIImage()
    }
}

struct AchievedView_Generate: View{
    @State private var colorSet = "goldColor"
    
    @Binding var showAchieved: Bool
    @Binding var achievementTitle: String
    @Binding var navigationTitle: String
    @Binding var medalName: String
    
    @State private var goalAchievedImage: UIImage? = nil
    
    var body: some View{
        ZStack{
            ZStack{
                ZStack{
                    VStack{
                        ZStack{
                            Text("CONGRATULATION")
                                .font(.custom("GenJyuuGothic-Heavy", size:16))
                                .foregroundStyle(Color(colorSet))
                                .padding(.top)
                                .opacity(0.2)
                            
                            Text("获得成就")
                                .bold()
                                .foregroundColor(.black)
                                .font(.system(size: 21))
                        }
                        
                        Image(medalName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 170)
                        
                        Text("我获得了“\(achievementTitle)”的饮水成就")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .padding(.top)
                            .padding(.leading)
                            .padding(.trailing)
                        
                        HStack{
                            Image("appstore")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18)
                                .shadow(color: Color.gray.opacity(0.2), radius: 5)
                            Text("App Store搜索“今天喝了么”")
                                .font(.custom("GenJyuuGothic-Bold", size:14))
                                .foregroundColor(Color(colorSet))
                                .shadow(color: Color.gray.opacity(0.2), radius: 5)
                        }
                        .padding(.top, 50)
                    }
                }
                .frame(width: 270, height: 400)
                .background(LinearGradient(gradient: Gradient(colors: [Color(colorSet).opacity(0.15), Color(colorSet).opacity(0.05)]),
                                           startPoint: .top,
                                           endPoint: .bottom))
            }
            .background(.white)
            .cornerRadius(15)
            .blur(radius: showAchieved ? 0 : 30)
            .opacity(showAchieved ? 1 : 0)
            .shadow(color: Color.gray.opacity(0.2), radius: 10)
        }
        .padding()
    }
}


#Preview {
    AchievementView()
}
