//
//  DrinkView_Sheet_TargetDescribe.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/11/5.
//

import SwiftUI

struct DrinkView_Sheet_TargetDescribe: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    
    @State private var dayTemprature_ = "-"
    @State private var nightTemprature_ = "-"
    @State private var nowSD_ = "-"
    @State private var city_ = "-"
    @State private var code_ = ""
    @State private var getWeather = true
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(.secondarySystemBackground)
                    .ignoresSafeArea()
                
                ScrollView{
                    VStack{
                        HStack{
                            Text("今日天气")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            Spacer()
                            if !getWeather {
                                Text("\(city_)")
                                    .foregroundStyle((Color(colorSet)))
                            } else {
                                ProgressView()
                            }
                        }
                        .padding(.bottom, 5)
                        .padding(.top)
                        
                        VStack{
                            HStack{
                                Image(systemName: "thermometer.sun.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 35)
                                    .foregroundColor(Color(colorSet))
                                
                                Text("最高气温")
                                    .bold()
                                    .font(.system(size: 18))
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                if !getWeather {
                                    Text("\(dayTemprature_)°C")
                                        .font(.custom("GenJyuuGothic-Heavy", size:22))
                                        .foregroundColor(Color(colorSet))
                                } else {
                                    ProgressView()
                                }
                            }
                            .padding(.leading)
                            .padding(.trailing)
                            .padding(.top)
                            
                            HStack{
                                Image(systemName: "thermometer.snowflake")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 35)
                                    .foregroundColor(Color(colorSet))
                                
                                Text("最低气温")
                                    .bold()
                                    .font(.system(size: 18))
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                if !getWeather {
                                    Text("\(nightTemprature_)°C")
                                        .font(.custom("GenJyuuGothic-Heavy", size:22))
                                        .foregroundColor(Color(colorSet))
                                } else {
                                    ProgressView()
                                }
                            }
                            .padding(.leading)
                            .padding(.trailing)
                            
                            HStack{
                                Image(systemName: "humidity.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 35)
                                    .foregroundColor(Color(colorSet))
                                
                                Text("空气湿度")
                                    .bold()
                                    .font(.system(size: 18))
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                if !getWeather {
                                    Text("\(nowSD_)")
                                        .font(.custom("GenJyuuGothic-Heavy", size:22))
                                        .foregroundColor(Color(colorSet))
                                } else {
                                    ProgressView()
                                }
                            }
                            .padding(.leading)
                            .padding(.trailing)
                            .padding(.bottom)
                        }
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .cornerRadius(10)
                        .padding(.bottom)
                        
                        HStack{
                            Text("个人信息")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .padding(.bottom, 5)
                        
                        VStack{
                            Text("个人信息可以在“我的”中查看和修改")
                                .foregroundStyle(.gray)
                                .font(.system(size: 15))
                                .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .cornerRadius(10)
                        .padding(.bottom)
                        
                        HStack{
                            Text("了解每日饮水目标")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .padding(.bottom, 5)
                        
                        VStack{
                            HStack{
                                Text("“今天喝了么”会每天为你计算合适的饮水量。计算饮水量的算法来自2022年11月25日在《Science》杂志上发表的一篇题为《Variation in human water turnover associated with environmental and lifestyle factors》的文献。")
                                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                                Spacer()
                            }
                            
                            HStack{
                                Text("这篇文献研究了全球不同人群的水周转率（WT），即人体每天消耗的水量。研究团队通过同位素示踪法追踪了5604名来自26个国家、年龄从8天到96岁的人，分析了年龄、身体大小、体成分、活动水平、环境和社会经济状况等因素对水周转率的影响。结果表明，体型较大、体力活动水平高的人群，如运动员和生活在较热环境中的人，其水周转率更高。而孕妇、体力劳动者和生活在低人类发展指数（HDI）国家的人，也有较高的水消耗需求。")
                                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                                Spacer()
                            }
                            .padding(.top, 5)
                            
                            HStack{
                                Text("该研究发现，水周转率在20至30岁男性和20至55岁女性中达到峰值，并随年龄增长而逐渐降低。水周转率还与气候条件密切相关，特别是在高温和高湿度的环境下水消耗量显著增加。此外，研究还显示了体脂率较低、自由水质量较大的个体水周转率较高。")
                                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                                Spacer()
                            }
                            .padding(.top, 5)
                            
                            HStack{
                                Text("文献提出了一套计算水周转率的公式，涵盖性别、体重、体力活动水平、空气温度、湿度和HDI等因素，这为全球公共健康的水需求评估提供了依据。研究还指出，当前”每日饮用8杯水”的建议缺乏科学依据。研究结果表明，不同人群的水需求差异显著，应根据个体情况制定相应的水摄入指南。该公式如下：")
                                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                                Spacer()
                            }
                            .padding(.top, 5)
                            
                            Image("formu")
                                .resizable()
                                .scaledToFit()
                                .padding(.leading)
                                .padding(.trailing)
                            
                            HStack{
                                Text("其中，PAL是身体活动水平，低活动强度为1.2，中等活动强度为1.5，高活动强度为2；body weight是体重；HDI是人类发展指数；sex是性别，男性为1，女性为0；athlete status是运动员状态，0代表非运动员，1代表运动员；humidity是相对湿度；altitude是当地海拔；age是年龄；temprature是一天中的平均温度。")
                                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                                Spacer()
                            }
                            .padding(.top, 5)
                            
                            HStack{
                                Text("水周转率包括通过饮水、食物、呼吸空气中的水分等途径获得的水量。每日合适饮水量约占每日水周转率的60%-80%。")
                                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                                Spacer()
                            }
                            .padding(.top, 5)
                            
                            HStack{
                                Button(action: {
                                    guard let url = URL(string: "https://www.science.org/doi/10.1126/science.abm8668") else {
                                        return
                                    }
                                    if UIApplication.shared.canOpenURL(url) {
                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                    }
                                }){
                                    HStack{
                                        Text("在Science中查看")
                                        Image(systemName: "arrow.up.right")
                                    }
                                }
                                Spacer()
                            }
                            .padding(.top, 5)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .cornerRadius(10)
                        .padding(.bottom)
                    }
                    .padding(.leading)
                    .padding(.trailing)
                    .navigationBarTitle("了解每日饮水目标", displayMode: .inline)
                    .navigationBarItems(leading: cancleBtn)
                }
            }
        }
        .onAppear{
            WeatherClient.makeRequest { responseString in
                if let data = responseString.data(using: .utf8),
                   let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    
                    if let code = WeatherDataParser.getCode(from: json){
                        code_ = code
                    }
                    
                    getWeather = false
                    
                    if code_ == "0" {
                        if let city = WeatherDataParser.getAreaCn(from: json){
                            city_ = city
                        }
                        
                        if let dayTemperature = WeatherDataParser.getDayTemperature(from: json) {
                            dayTemprature_ = dayTemperature
                        }
                        
                        if let nightTemperature = WeatherDataParser.getNightTemperature(from: json) {
                            nightTemprature_ = nightTemperature
                        }
                        
                        if let nowSD = WeatherDataParser.getNowSD(from: json) {
                            nowSD_ = nowSD
                        }
                    } else {
                        city_ = "-"
                        dayTemprature_ = "-"
                        nightTemprature_ = "-"
                        nowSD_ = "-"
                    }
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
}

#Preview {
    DrinkView_Sheet_TargetDescribe()
}
