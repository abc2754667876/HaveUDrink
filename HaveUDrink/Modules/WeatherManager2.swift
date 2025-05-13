//
//  WeatherManager2.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/11/19.
//

import Foundation

struct WeatherManager2 {
    let appcode = "9f62b2d4a4fc4d0396989c3cc8d2e297"
    let host = "https://getweather.market.alicloudapi.com"
    let path = "/lundear/weather1d"
    
    func fetchWeather(areaCode: String, completion: @escaping (Result<String, Error>) -> Void) {
        let querys = "?areaCode=\(areaCode)&areaCn=areaCn&ip=ip&lng=lng&lat=lat&needalarm=needalarm&need1hour=need1hour&need3hour=need3hour&needIndex=needIndex&needObserve=needObserve"
        let urlString = "\(host)\(path)\(querys)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 5.0)
        request.httpMethod = "GET"
        request.addValue("APPCODE \(appcode)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data, let bodyString = String(data: data, encoding: .utf8) {
                completion(.success(bodyString))
            } else {
                completion(.failure(NSError(domain: "NoData", code: 1, userInfo: nil)))
            }
        }
        
        task.resume()
    }
}
