//
//  PollingViewModel.swift
//  NotOK
//
//  Created by Tan Xin Jie on 13/2/25.
//

import SwiftUI

class DiscoverViewModel: ObservableObject {
    @Published var coinDetails: [String: CryptoDetail] = [:]
    @Published var errorMessage: String = ""
    @Published var isConnected: Bool = false
    
    private let session: URLSession
    private let urlstring = "https://192.168.18.106:3001/prices"
    
    init() {
        let sessionConfig = URLSessionConfiguration.default
        let delegate = SSLBypasstURLSessionDelegate()
        self.session = URLSession(configuration: sessionConfig, delegate: delegate, delegateQueue: nil)
    }
    
    func fetchPrices() async {
        guard let url = URL(string: urlstring) else {
            print("DiscoverViewModel - Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await session.data(from: url)
            let decodedData = try JSONDecoder().decode([String: CryptoDetail].self, from: data)
            await MainActor.run {
                self.coinDetails = decodedData
                self.isConnected = true
                self.errorMessage = ""
            }
        } catch {
            print("DiscoverViewModel - Error fetching prices:", error.localizedDescription)
            await MainActor.run {
                self.isConnected = false
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func startPolling() {
        Task.detached { [weak self] in
            guard let self = self else { return }
            
            while true {
                await self.fetchPrices()
                try await Task.sleep(nanoseconds: 2 * 1_000_000_000) // 2 second polling
            }
        }
    }
}
