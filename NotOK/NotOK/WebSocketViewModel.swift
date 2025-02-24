//
//  WebSocketViewModel.swift
//  NotOK
//
//  Created by Tan Xin Jie on 13/2/25.
//

import SwiftUI

class WebSocketViewModel: ObservableObject {
    @Published var coinDetail: CryptoPrice = CryptoPrice(pair: "--", price: "--", open: "--", delta: "--", timestamp: 0)
    
    private var webSocketTask: URLSessionWebSocketTask?
    private let session: URLSession
    private let selectedPair: String
    
    init(tokenPair: String) {
        self.selectedPair = tokenPair
        let sessionConfig = URLSessionConfiguration.default
        let delegate = WebSocketURLSessionDelegate()
        self.session = URLSession(configuration: sessionConfig, delegate: delegate, delegateQueue: nil)
    }
    
    func connect() {
        guard let url = URL(string: "wss://192.168.18.88:3001") else {
            print("Invalid WebSocket URL")
            return
        }
        
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        
        print("Connected to WebSocket Server")
        subscribeToPair()
        receiveMessage()
    }
    
    private func subscribeToPair() {
        let subscribeMessage: [String: Any] = [
            "type": "subscribe",
            "pairs": [selectedPair]
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: subscribeMessage, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                webSocketTask?.send(.string(jsonString)) { error in
                    if let error = error {
                        print("WebSocket subscription error:", error)
                    } else {
                        print("Subscribed to pairs:", self.selectedPair)
                    }
                }
            }
        } catch {
            print("Failed to encode subscription message:", error)
        }
    }
    
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    if let data = text.data(using: .utf8) {
                        do {
                            let decodedData = try JSONDecoder().decode(CryptoPrice.self, from: data)
                            DispatchQueue.main.async {
                                self?.coinDetail = decodedData
                            }
                        } catch {
                            print("Failed to decode JSON:", error)
                        }
                    }
                case .data(let data):
                    print("Received binary data:", data)
                @unknown default:
                    fatalError()
                }
                
                self?.receiveMessage()
                
            case .failure(let error):
                print("WebSocket error:", error)
            }
        }
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        print("Disconnected from WebSocket")
    }
}

class WebSocketURLSessionDelegate: NSObject, URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let trust = challenge.protectionSpace.serverTrust {
            let credential = URLCredential(trust: trust)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
}
