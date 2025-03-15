//
//  WebSocketViewModel.swift
//  NotOK
//
//  Created by Tan Xin Jie on 13/2/25.
//

import SwiftUI

struct wsCoinResponse: Codable {
    let type: String
    let pairs: [String]
}

struct TakerVolume: Codable {
    var sellVol: String
    var buyVol: String
}

class CoinDetailViewModel: ObservableObject {
    @Published var coinDetail: CryptoDetail = CryptoDetail(pair: "--", price: "--", open: "--", delta: "--", timestamp: 0)
    @Published var takerVolume: TakerVolume = TakerVolume(sellVol: "0.0", buyVol: "0.0")
    var getSellVolPercentage: Int {
        let sellVolDouble = Double(takerVolume.sellVol) ?? 0
        let buyVolDouble = Double(takerVolume.buyVol) ?? 0
        let total = sellVolDouble + buyVolDouble
        if total == 0 {
            return 50
        }
        return Int((sellVolDouble / total) * 100)
    }
    
    private var webSocketTask: URLSessionWebSocketTask?
    private let session: URLSession
    private let selectedPair: String
    
    var isConnected = false
    private var reconnectTask: Task<Void, Never>? = nil
    
    private let wsString = "wss://192.168.18.106:3001"
    private let httpString = "https://192.168.18.106:3001/taker-volume"
    
    // delegate to bypass SSL certificate verification
    init(tokenPair: String) {
        self.selectedPair = tokenPair
        let sessionConfig = URLSessionConfiguration.default
        let delegate = SSLBypasstURLSessionDelegate()
        self.session = URLSession(configuration: sessionConfig, delegate: delegate, delegateQueue: nil)
    }
    
    func connect() {
        guard !isConnected else { return }
        
        guard let url = URL(string: wsString) else {
            print("CoinDetailViewModel - Invalid WebSocket URL")
            return
        }
        
        webSocketTask = session.webSocketTask(with: url)
        if let webSocketTask {
            webSocketTask.resume()
            isConnected = true
        }
        
        Task { await subscribe() }
        Task { await receiveMessage() }
    }
    
    private func subscribe() async {
        let subscribeMessage: [String: Any] = [
            "type": "subscribe",
            "pairs": [selectedPair]
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: subscribeMessage, options: [])
            let jsonString = String(data: jsonData, encoding: .utf8)!
            try await webSocketTask?.send(.string(jsonString))
        } catch {
            print("CoinDetailViewModel - Subscription error: \(error.localizedDescription)")
        }
    }
    
    private func receiveMessage() async {
        guard let webSocketTask = webSocketTask else { return }
        
        while isConnected {
            do {
                let message = try await webSocketTask.receive()
                switch message {
                case .string(let text):
                    if let data = text.data(using: .utf8) {
                        do {
                            let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                            // Message is a subscription confirmation
                            if let type = jsonObject?["type"] as? String, type == "subscribed" {
                                
                                print("CoinDetailViewModel - Subscription Success: \(jsonObject?["pairs"] as? [String] ?? ["Unknown"])")
                                continue
                            }
                            let decodedData = try JSONDecoder().decode(CryptoDetail.self, from: data)
                            await MainActor.run {
                                self.coinDetail = decodedData
                            }
                        } catch {
                            print("CoinDetailViewModel - Error receiving message: \(error.localizedDescription)")
                        }
                    }
                default:
                    fatalError()
                }
            } catch {
                print("CoinDetailViewModel - Connection Error: \(error.localizedDescription)")
                isConnected = false
                await autoReconnect()
                break
            }
        }
    }
    
    private func autoReconnect() async {
        if !isConnected {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            reconnect()
        }
    }
    
    func reconnect() {
        guard !isConnected else { return }
        print("CoinDetailViewModel - Attempting to reconnect...")
        connect()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
        isConnected = false
        reconnectTask?.cancel()
        print("CoinDetailViewModel - Disconnected from WebSocket")
    }
    
    func fetchTakerVolume(ccy: String) async {
        guard let url = URL(string: httpString.appending("?ccy=\(ccy)")) else {
            print("CoinDetailViewModel - fetchTakerVolume Invalid URL")
            return
        }
        do {
            let (data, _) = try await session.data(from: url)
            let decodedData = try JSONDecoder().decode(TakerVolume.self, from: data)
            await MainActor.run {
                self.takerVolume = decodedData
            }
        } catch {
            print("CoinDetailViewModel - Error fetching volume: \(error.localizedDescription)")
        }
    }
}
