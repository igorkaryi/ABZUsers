//
//  NetworkMonitor.swift
//  ABZUsers
//
//  Created by Igor Karyi on 30.07.2025.
//

import Network
import Combine

final class NetworkMonitor: ObservableObject {
    @Published private(set) var isConnected: Bool = true

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }

        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }

    func forceCheck() {
        let path = monitor.currentPath
        DispatchQueue.main.async {
            self.isConnected = path.status == .satisfied
        }
    }
}
