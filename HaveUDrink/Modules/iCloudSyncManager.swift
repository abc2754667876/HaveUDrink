//
//  iCloudSyncManager.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/10/18.
//

import Foundation
import CloudKit

class iCloudSyncManager {
    static let shared = iCloudSyncManager()
    //let container = CKContainer.default()
    let container = CKContainer(identifier: "iCloud.ZhangBeans.HaveUDrink")
    let database = CKContainer.default().privateCloudDatabase

    // 上传 SQLite 数据库文件到 CloudKit
    func uploadDatabase(completion: @escaping (Result<CKRecord, Error>) -> Void) {
        do {
            // 获取本地 SQLite 文件路径
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("HaveUDrinkUserDatabase.sqlite")

            // 创建 CKRecord 并将数据库文件作为 CKAsset 上传
            let record = CKRecord(recordType: "DatabaseRecord")
            let asset = CKAsset(fileURL: fileURL)
            record["database"] = asset

            database.save(record) { savedRecord, error in
                if let error = error {
                    completion(.failure(error))
                } else if let savedRecord = savedRecord {
                    completion(.success(savedRecord))
                }
            }
        } catch {
            print("Error getting local database file: \(error.localizedDescription)")
        }
    }

    // 从 CloudKit 下载数据库文件
    func downloadDatabase(recordID: CKRecord.ID, completion: @escaping (Result<URL, Error>) -> Void) {
        database.fetch(withRecordID: recordID) { record, error in
            if let error = error {
                completion(.failure(error))
            } else if let record = record, let asset = record["database"] as? CKAsset, let fileURL = asset.fileURL {
                do {
                    // 获取目标文件的路径
                    let targetFileURL = try FileManager.default
                        .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                        .appendingPathComponent("HaveUDrinkUserDatabase.sqlite")

                    // 如果目标路径已存在，删除旧文件
                    if FileManager.default.fileExists(atPath: targetFileURL.path) {
                        try FileManager.default.removeItem(at: targetFileURL)
                    }

                    // 将文件移动到目标路径
                    try FileManager.default.moveItem(at: fileURL, to: targetFileURL)

                    // 返回新的文件路径
                    completion(.success(targetFileURL))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
}
