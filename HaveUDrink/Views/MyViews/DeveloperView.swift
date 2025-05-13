//
//  DeveloperView.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/11/6.
//

import SwiftUI

struct DeveloperView: View {
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    @AppStorage("firstUse") private var firstUse = true
    
    @State private var showAlert = false
    @State private var alertInfo = ""
    
    @State private var isDocumentPickerForSavePresented = false
    @State private var isDocumentPickerForImportPresented = false
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(.secondarySystemBackground)
                    .ignoresSafeArea()
                
                VStack{
                    VStack{
                        Image(systemName: "swift")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color(colorSet))
                            .frame(width: 40)
                        Text("开发者选项")
                            .font(.system(size: 24))
                            .foregroundStyle(.black)
                            .bold()
                        Text("开发者选项是在设备上调试、测试和优化应用的功能。请慎用该页面的功能，谨防数据丢失。")
                            .multilineTextAlignment(.center)
                            .padding(.top, 1)
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                    }
                    .padding(25)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .background(.white)
                    .cornerRadius(10)
                    .padding(.bottom)
                    
                    VStack{
                        Button(action: {
                            isDocumentPickerForSavePresented = true
                        }){
                            HStack{
                                Text("导出数据")
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color(colorSet))
                            }
                        }
                        .sheet(isPresented: $isDocumentPickerForSavePresented) {
                            DocumentPickerView(forSaving: true) { selectedURL in
                                if let selectedURL = selectedURL {
                                    copyDatabase(to: selectedURL)
                                } else {
                                    print("用户取消了保存操作")
                                }
                            }
                        }
                        
                        Divider()
                        
                        Button(action: {
                            isDocumentPickerForImportPresented = true
                        }){
                            HStack{
                                Text("导入数据")
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color(colorSet))
                            }
                        }
                        .sheet(isPresented: $isDocumentPickerForImportPresented) {
                            DocumentPickerView(forSaving: false) { selectedURL in
                                if let selectedURL = selectedURL {
                                    importDatabase(from: selectedURL)
                                } else {
                                    print("用户取消了导入操作")
                                }
                            }
                        }
                        
                        Divider()
                        
                        Button(action: {
                            firstUse = true
                            alertInfo = "已设置为首次使用状态，本操作不会清除数据"
                            showAlert = true
                        }){
                            HStack{
                                Text("设为首次使用状态")
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color(colorSet))
                            }
                        }
                    }
                    .padding(10)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .background(.white)
                    .cornerRadius(10)
                    .padding(.bottom)
                    
                    Spacer()
                }
                .padding(.trailing)
                .padding(.leading)
            }
        }
        .alert("提示", isPresented: $showAlert) {
            Button("确定", role: .cancel) {}
        } message: {
            Text(alertInfo)
        }
    }
    
    private func copyDatabase(to destinationURL: URL) {
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("HaveUDrinkUserDatabase.sqlite")
            
            if FileManager.default.fileExists(atPath: fileURL.path) {
                let destinationFileURL = destinationURL.appendingPathComponent("HaveUDrinkUserDatabase_\(getCurrentDateString()).sqlite")
                try FileManager.default.copyItem(at: fileURL, to: destinationFileURL)
                print("数据库已成功保存到自定义位置")
            } else {
                print("原始数据库文件不存在")
            }
        } catch {
            print("复制数据库失败: \(error)")
        }
    }
    
    private func importDatabase(from sourceURL: URL) {
        do {
            let destinationURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("HaveUDrinkUserDatabase.sqlite")
            
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
            }
            
            try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
            print("数据库已成功导入")
        } catch {
            print("导入数据库失败: \(error)")
        }
    }
}

// 使用 UIViewControllerRepresentable 封装 UIDocumentPickerViewController
struct DocumentPickerView: UIViewControllerRepresentable {
    var forSaving: Bool
    var completion: (URL?) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(completion: completion)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        if forSaving {
            return UIDocumentPickerViewController(forExporting: [URL(fileURLWithPath: NSTemporaryDirectory())], asCopy: true)
        } else {
            let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item])
            picker.delegate = context.coordinator
            picker.allowsMultipleSelection = false
            return picker
        }
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var completion: (URL?) -> Void

        init(completion: @escaping (URL?) -> Void) {
            self.completion = completion
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            completion(urls.first)
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            completion(nil)
        }
    }
}

#Preview {
    DeveloperView()
}
