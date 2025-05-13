//
//  NetworkMonitor.swift
//  HaveUDrink
//
//  Created by Chengzhi 张 on 2024/10/24.
//

import Foundation
import Network

class NetworkMonitor {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)

    init() {
        monitor.start(queue: queue)
    }

    func isConnected(completion: @escaping (Bool) -> Void) {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                // 网络连接正常
                completion(true)
            } else {
                // 没有网络连接
                completion(false)
            }
        }
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
