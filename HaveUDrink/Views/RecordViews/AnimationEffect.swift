//
//  AnimationEffect.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/10/13.
//

import SwiftUI

struct AnimationEffect: ViewModifier {
    var isSelected = true
    var id: String
    var namespace: Namespace.ID

    func body(content: Content) -> some View {
        if isSelected {
            content.matchedGeometryEffect(id: id, in: namespace)
        } else {
            content
        }
    }
}

extension View {
    func animationEffect(isSelected: Bool, id: String, in namespace: Namespace.ID) -> some View {
        modifier(AnimationEffect(isSelected: isSelected, id: id, namespace: namespace))
    }
}
