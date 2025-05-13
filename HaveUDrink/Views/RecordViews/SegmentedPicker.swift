//
//  SegmentedPicker.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/10/13.
//

import SwiftUI

struct SegmentedPicker<SelectionValue, Content>: View where SelectionValue: Hashable, Content: View {

    @Namespace private var pickerTransition

    @Binding var selection: SelectionValue?

    @Binding var items: [SelectionValue]

    private var selectionColor: Color = .blue

    private var content: (SelectionValue) -> Content

    init(
        selection: Binding<SelectionValue?>,
        items: Binding<[SelectionValue]>,
        selectionColor: Color = .blue,
        @ViewBuilder content: @escaping (SelectionValue) -> Content
    ) {
        _selection = selection
        _items = items
        self.selectionColor = selectionColor
        self.content = content
    }

    init(
        selection: Binding<SelectionValue>,
        items: Binding<[SelectionValue]>,
        selectionColor: Color = .blue,
        @ViewBuilder content: @escaping (SelectionValue) -> Content
    ) {
        _selection = Binding<SelectionValue?>(selection)
        _items = items
        self.selectionColor = selectionColor
        self.content = content
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [GridItem(.flexible())], spacing: 6) {

                    ForEach(items, id: \.self) { item in
                        let selected = selection == item
                        ZStack {
                            Capsule()
                                .foregroundStyle(selected ? selectionColor : .clear)
                                .animationEffect(isSelected: selected, id: "picker", in: pickerTransition)

                            content(item).id(item)
                                .pickerTextStyle(isSelected: selected)
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selection = item
                                proxy.scrollTo(item, anchor: .center)
                            }
                        }
                    }
                    .onAppear {
                        if let selectedItem = selection {
                            proxy.scrollTo(selectedItem, anchor: .center)
                        } else if let first = items.first {
                            selection = first
                            proxy.scrollTo(first, anchor: .center)
                        }
                    }
                }
                .padding(.horizontal)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
