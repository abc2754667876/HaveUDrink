import Foundation
import CommonCrypto

struct WeatherClient {
    static func hmacSHA1Text(encryptText: String, encryptKey: String) -> String? {
        guard let keyData = encryptKey.data(using: .utf8),
              let textData = encryptText.data(using: .utf8) else { return nil }

        var result = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        keyData.withUnsafeBytes { keyBytes in
            textData.withUnsafeBytes { textBytes in
                CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), keyBytes.baseAddress, keyBytes.count, textBytes.baseAddress, textBytes.count, &result)
            }
        }
        return Data(result).base64EncodedString()
    }

    static func checkValidationResult(_ sender: Any, _ certificate: SecCertificate?, _ chain: SecTrust?, _ errors: CFError?) -> Bool {
        return true // 始终接受证书
    }
    
    static func makeRequest(completion: @escaping (String) -> Void) {

        // First, fetch the public IP
        fetchPublicIP { ip in
            guard let ip = ip else {
                completion("Failed to retrieve public IP")
                return
            }

            // Now update the querys string with the retrieved IP
            let urlString = "https://service-6drgk6su-1258850945.gz.apigw.tencentcs.com/release/lundear/weather1d"
            let method = "GET"
            let querys = "areaCn=&areaCode=&ip=\(ip)&lat=&lng=&need1hour=&need3hour=&needIndex=&needObserve=&needalarm="
            let source = "market"

            let secretId = "AKIDnjbJb25eef0q2xdh214u184zlp213bd9t3lr"
            let secretKey = "7p6qx8tem22i94jcw5tr97sxgqj8r6euf7lsw2c9"

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss 'GMT'"
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            let dt = dateFormatter.string(from: Date())

            let url = URL(string: urlString + "?" + querys)!

            let signStr = "x-date: \(dt)\n" + "x-source: \(source)"
            guard let sign = hmacSHA1Text(encryptText: signStr, encryptKey: secretKey) else {
                completion("Failed to create HMAC signature")
                return
            }

            let auth = "hmac id=\"\(secretId)\", algorithm=\"hmac-sha1\", headers=\"x-date x-source\", signature=\"\(sign)\""

            var request = URLRequest(url: url)
            request.httpMethod = method
            request.setValue(auth, forHTTPHeaderField: "Authorization")
            request.setValue(source, forHTTPHeaderField: "X-Source")
            request.setValue(dt, forHTTPHeaderField: "X-Date")

            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)

            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion("Request failed with error: \(error.localizedDescription)")
                    return
                }

                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    //print(responseString)
                    completion(responseString)
                } else {
                    completion("Failed to decode response data")
                }
            }

            task.resume()
        }
    }
    
    
    static func fetchPublicIP(completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "https://ipinfo.io/ip") else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to retrieve public IP: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data, let ipAddress = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                completion(nil)
                return
            }

            completion(ipAddress)
        }

        task.resume()
    }
}

// 定义一个静态类来处理 JSON 数据
class WeatherDataParser {
    
    // 1. 提取 day 字段中的 temperature
    static func getDayTemperature(from json: [String: Any]) -> String? {
        guard let data = json["data"] as? [String: Any],
              let day = data["day"] as? [String: Any],
              let temperature = day["temperature"] as? String else {
            return nil
        }
        return temperature
    }
    
    // 2. 提取 night 字段中的 temperature
    static func getNightTemperature(from json: [String: Any]) -> String? {
        guard let data = json["data"] as? [String: Any],
              let night = data["night"] as? [String: Any],
              let temperature = night["temperature"] as? String else {
            return nil
        }
        return temperature
    }
    
    // 3. 提取 now 字段中的 SD (湿度)
    static func getNowSD(from json: [String: Any]) -> String? {
        guard let data = json["data"] as? [String: Any],
              let now = data["now"] as? [String: Any],
              let sd = now["SD"] as? String else {
            return nil
        }
        return sd
    }
    
    // 4. 提取 cityInfo 字段中的 areaCn
    static func getAreaCn(from json: [String: Any]) -> String? {
        guard let data = json["data"] as? [String: Any],
              let cityInfo = data["cityInfo"] as? [String: Any],
              let areaCn = cityInfo["areaCn"] as? String else {
            return nil
        }
        return areaCn
    }
    
    // 5. 提取 code 字段
    static func getCode(from json: [String: Any]) -> String? {
        // 尝试获取 code 字段
        if let code = json["code"] as? String {
            return code
        } else if let code = json["code"] as? Int {
            return "\(code)"  // 如果 code 是整型，转换为字符串返回
        }
        return nil
    }
}
