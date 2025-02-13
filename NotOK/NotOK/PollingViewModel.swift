//
//  PollingViewModel.swift
//  NotOK
//
//  Created by Tan Xin Jie on 13/2/25.
//

import SwiftUI

class PollingViewModel: ObservableObject {
    @Published var prices: [String: CryptoPrice] = [:]
    
    private let session: URLSession
    
        
    init() {
        let sessionConfig = URLSessionConfiguration.default
        
        // Custom URLSession with SSL Trust for Self-Signed Certs
        let delegate = WebSocketURLSessionDelegate()
        self.session = URLSession(configuration: sessionConfig, delegate: delegate, delegateQueue: nil)
    }
    
    
    func fetchPrices() {
        
        guard let url = URL(string: "https://192.168.18.88:3001/prices") else {
            print("Invalid URL")
            return
        }
        
        session.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching prices:", error ?? "Unknown error")
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([String: CryptoPrice].self, from: data)
                DispatchQueue.main.async {
                    self.prices = decodedData
                }
            } catch {
                print("JSON decoding error:", error)
            }
        }.resume()
    }
    
    
    func startPolling() {
        fetchPrices()
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            self.fetchPrices()
        }
    }
}

