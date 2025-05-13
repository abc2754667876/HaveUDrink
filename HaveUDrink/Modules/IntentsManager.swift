//
//  IntentsManager.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/10/28.
//

import Foundation
import AppIntents
import SwiftUI
 //NFCDrinkView_Single_Add
// 添加水的快捷指令
struct AddIntakeIntent: AppIntent{
    var value: Never?
    
    static var title: LocalizedStringResource = "添加饮品"
    static var description = IntentDescription("添加饮品")

    static var openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult{
        UserDefaults.standard.set(true, forKey: "ShouldOpenAddView")
        NotificationCenter.default.post(name: .openAddView, object: nil)
        return .result()
    }
}

struct AddNFCIntakeIntent: AppIntent{
    var value: Never?
    
    static var title: LocalizedStringResource = "一贴饮水"
    static var description = IntentDescription("一贴饮水")

    static var openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult{
        UserDefaults.standard.set(true, forKey: "ShouldOpenAddNFCView")
        NotificationCenter.default.post(name: .openAddNFCView, object: nil)
        return .result()
    }
}
