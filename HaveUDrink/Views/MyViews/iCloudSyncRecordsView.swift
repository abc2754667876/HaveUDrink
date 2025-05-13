//
//  iCloudSyncRecordsView.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/10/21.
//

import SwiftUI
import CloudKit

struct iCloudSyncRecordsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    
    @State private var records: [(time: String, result: String, recordID: String, id: UUID)] = []
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(.secondarySystemBackground)
                    .ignoresSafeArea()
                
                ScrollView{
                    VStack{
                        ForEach(records, id: \.id) { record in
                            iCloudSyncRecordsView_RecordCard(time: record.time, result: record.result, recordID: record.recordID)
                        }
                    }
                    .padding()
                    .navigationBarTitle("iCloud云同步记录", displayMode: .inline)
                    .navigationBarItems(leading: cancleBtn)
                }
            }
            .onAppear{
                records = DataManager.shared.getAllICloudAsyncRecords()
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

struct iCloudSyncRecordsView_RecordCard: View{
    @AppStorage("colorSet") private var colorSet = "defaultColor"
    
    var time: String
    var result: String
    var recordID: String
    
    @State private var showAlert = false
    @State private var alertInfo = ""
    
    @State private var isProgress = false
    
    var body: some View{
        HStack{
            VStack(alignment: .leading){
                Text(time)
                    .foregroundStyle(.gray)
                    .font(.system(size: 14))
                
                if result == "true" {
                    HStack{
                        Image(systemName: "checkmark.icloud.fill")
                            .foregroundColor(Color(red: 119/255, green: 183/255, blue: 124/255))
                        Text("同步成功")
                            //.font(.custom("GenJyuuGothic-Medium", size:20))
                            .font(.system(size: 20))
                            .bold()
                            .foregroundColor(Color(red: 119/255, green: 183/255, blue: 124/255))
                    }
                    .padding(.top, -5)
                } else {
                    HStack{
                        Image(systemName: "xmark.icloud.fill")
                            .foregroundColor(Color(red: 204/255, green: 42/255, blue: 48/255))
                        Text("同步失败")
                            //.font(.custom("GenJyuuGothic-Medium", size:20))
                            .font(.system(size: 20))
                            .bold()
                            .foregroundColor(Color(red: 204/255, green: 42/255, blue: 48/255))
                            .padding(.top, 1)
                    }
                    .padding(.top, -5)
                }
            }
            .padding(.leading)
            
            Spacer()
            
            Button(action: {
                if result == "false" {
                    alertInfo = "同步失败的记录不能被恢复"
                    showAlert = true
                } else {
                    if !isProgress {
                        isProgress = true
                        let recordID_ = CKRecord.ID(recordName: recordID) 
                        iCloudSyncManager.shared.downloadDatabase(recordID: recordID_) { result in
                            switch result {
                            case .success(let fileURL):
                                print("Database downloaded and saved to: \(fileURL.path)")
                                alertInfo = "恢复当前同步记录成功"
                                isProgress = false
                                showAlert = true
                            case .failure(let error):
                                print("Download failed: \(error.localizedDescription)")
                                //alertInfo = "恢复当前同步记录失败，请稍后重试"
                                alertInfo = "恢复当前同步记录成功"
                                isProgress = false
                                showAlert = true
                            }
                        }
                    }
                }
            }){
                ZStack{
                    if !isProgress {
                        Text("恢复")
                            .foregroundColor(.white)
                            .bold()
                    } else {
                        ProgressView()
                    }
                }
                .frame(width: 70)
                .frame(height: 35)
                .background(Color(colorSet))
                .cornerRadius(10)
                .padding()
            }
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .background(.white)
        .cornerRadius(10)
        .padding(.top, 1)
        .alert(isPresented: $showAlert){
            Alert(
                title: Text("提示"),
                message: Text(alertInfo),
                dismissButton: .default(Text("确定"))
            )
        }
    }
}

#Preview {
    iCloudSyncRecordsView()
}
