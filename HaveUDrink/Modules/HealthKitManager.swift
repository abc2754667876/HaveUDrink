//
//  HealthKitManager.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/10/18.
//

import HealthKit

final class HealthKitManager {
    
    static let healthStore = HKHealthStore()
    
    // 请求 HealthKit 授权
    static func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        let waterType = HKObjectType.quantityType(forIdentifier: .dietaryWater)!
        let caffeineType = HKObjectType.quantityType(forIdentifier: .dietaryCaffeine)!
        let alcoholType = HKObjectType.quantityType(forIdentifier: .numberOfAlcoholicBeverages)!
        
        let typesToShare: Set = [waterType, caffeineType, alcoholType]
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToShare) { success, error in
            completion(success, error)
        }
    }
    
    // 添加水摄入量
    static func addWaterIntake(amount: Double, date: Date, completion: @escaping (Bool, Error?) -> Void) {
        let waterType = HKQuantityType.quantityType(forIdentifier: .dietaryWater)!
        let waterQuantity = HKQuantity(unit: HKUnit.literUnit(with: .milli), doubleValue: amount)
        
        let waterSample = HKQuantitySample(type: waterType, quantity: waterQuantity, start: date, end: date)
        
        healthStore.save(waterSample) { success, error in
            completion(success, error)
        }
    }
    
    // 添加咖啡因摄入量
    static func addCaffeineIntake(amount: Double, date: Date, completion: @escaping (Bool, Error?) -> Void) {
        let caffeineType = HKQuantityType.quantityType(forIdentifier: .dietaryCaffeine)!
        let caffeineQuantity = HKQuantity(unit: HKUnit.gramUnit(with: .milli), doubleValue: amount)
        
        let caffeineSample = HKQuantitySample(type: caffeineType, quantity: caffeineQuantity, start: date, end: date)
        
        healthStore.save(caffeineSample) { success, error in
            completion(success, error)
        }
    }
    
    // 添加酒精摄入量
    static func addAlcoholIntake(amount: Double, date: Date, completion: @escaping (Bool, Error?) -> Void) {
        let alcoholType = HKQuantityType.quantityType(forIdentifier: .numberOfAlcoholicBeverages)! // 使用 numberOfAlcoholicBeverages
        let alcoholQuantity = HKQuantity(unit: HKUnit.count(), doubleValue: amount) // 使用 count 单位来表示酒精饮料的数量
        
        let alcoholSample = HKQuantitySample(type: alcoholType, quantity: alcoholQuantity, start: date, end: date)
        
        healthStore.save(alcoholSample) { success, error in
            completion(success, error)
        }
    }
}
