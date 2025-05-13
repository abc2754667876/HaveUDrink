//
//  NFCDrink.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/11/9.
//

import SwiftUI

struct NFCDrinkView: View {
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    
    @State private var showAddBottle = false
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(.secondarySystemBackground)
                    .ignoresSafeArea()
                
                ScrollView{
                    VStack{

                    }
                }
            }
        }
        .sheet(isPresented: $showAddBottle){
            NFCView_Sheet_AddBottle()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button(action: {
                        showAddBottle = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(Color(colorSet))
                    }
                }
            }
        }
    }
}

#Preview {
    NFCDrinkView()
}
