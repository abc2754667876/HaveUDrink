//
//  PickerStyle.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/10/13.
//

import SwiftUI

struct PickerStyle: ViewModifier {
    var isSelected = true

    func body(content: Content) -> some View {
        content
            .foregroundStyle(isSelected ? .white : .black)
            .padding(.horizontal)
            .padding(.vertical, 8)
            .lineLimit(1)
            .clipShape(Capsule())
            .bold()
    }
}

extension View {
    func pickerTextStyle(isSelected: Bool) -> some View {
        modifier(PickerStyle(isSelected: isSelected))
    }
}
