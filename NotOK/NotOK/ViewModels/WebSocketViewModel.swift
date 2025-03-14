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

class WebSocketViewModel: ObservableObject {
    @Published var coinDetail: CryptoDetail = CryptoDetail(pair: "--", price: "--", open: "--", delta: "--", timestamp: 0)
    
    private var webSocketTask: URLSessionWebSocketTask?
    private let session: URLSession
    private let selectedPair: String
    
    var isConnected = false
    private var reconnectTask: Task<Void, Never>? = nil
    
    private let urlString = "wss://192.168.18.106:3001"
    
    // delegate to bypass SSL certificate verification
    init(tokenPair: String) {
        self.selectedPair = tokenPair
        let sessionConfig = URLSessionConfiguration.default
        let delegate = SSLBypasstURLSessionDelegate()
        self.session = URLSession(configuration: sessionConfig, delegate: delegate, delegateQueue: nil)
    }
    
    func connect() {
        guard !isConnected else { return }
        
        guard let url = URL(string: urlString) else {
            print("WebSocketViewModel - Invalid WebSocket URL")
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
            print("WebSocketViewModel - Subscription error: \(error.localizedDescription)")
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
                                
                                print("WebSocketViewModel - Subscription Success: \(jsonObject?["pairs"] as? [String] ?? ["Unknown"])")
                                continue
                            }
                            let decodedData = try JSONDecoder().decode(CryptoDetail.self, from: data)
                            self.coinDetail = decodedData
                        } catch {
                            print("WebSocketViewModel - Error receiving message: \(error.localizedDescription)")
                        }
                    }
                default:
                    fatalError()
                }
            } catch {
                print("WebSocketViewModel - Connection Error: \(error.localizedDescription)")
                isConnected = false
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
        print("WebSocketViewModel - Attempting to reconnect...")
        connect()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
        isConnected = false
        reconnectTask?.cancel()
        print("WebSocketViewModel - Disconnected from WebSocket")
    }
}

class SSLBypasstURLSessionDelegate: NSObject, URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let trust = challenge.protectionSpace.serverTrust {
            let credential = URLCredential(trust: trust)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
}
