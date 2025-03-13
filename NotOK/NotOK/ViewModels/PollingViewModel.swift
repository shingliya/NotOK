//
//  PollingViewModel.swift
//  NotOK
//
//  Created by Tan Xin Jie on 13/2/25.
//

import SwiftUI

class PollingViewModel: ObservableObject {
    @Published var coinDetails: [String: CryptoDetail] = [:]
    @Published var errorMessage: String = ""
    @Published var isConnected: Bool = false
    
    private let session = URLSession.shared
    private let url = URL(string: "https://192.168.18.88:3001/prices")!
    
    func fetchPrices() async {
        guard let url = URL(string: "https://192.168.18.88:3001/prices") else {
            print("PollingViewModel - Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await session.data(from: url)
            let decodedData = try JSONDecoder().decode([String: CryptoDetail].self, from: data)
            self.coinDetails = decodedData
            self.isConnected = true
            self.errorMessage = ""
        } catch {
            
        }
    }
    
    func startPolling() {
        Task.detached { [weak self] in
            guard let self = self else { return }
            
            while true {
                await fetchPrices()
                try await Task.sleep(nanoseconds: 2 * 1_000_000_000) // 2 second polling
            }
        }
    }
}

