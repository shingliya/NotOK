//
//  CryptoModel.swift
//  NotOK
//
//  Created by Tan Xin Jie on 24/2/25.
//

import Foundation

struct CryptoPrice: Codable {
//    let pair: String
    let price: String
    let open: String
    let delta: String
    let timestamp: Int
    
    func formattedDeltaPercentage() -> String {
        guard let deltaValue = Double(delta), let openValue = Double(open), openValue != 0.0 else {
            return "0.00%"
        }
        
        let percentage = (deltaValue / openValue) * 100
        
        return String(format: "%+.2f%", percentage)
    }
}

struct CryptoMapper {
    static let cryptoNames: [String: String] = [
        "BTC": "Bitcoin",
        "ETH": "Ethereum",
        "SOL": "Solana",
        "XRP": "Ripple",
        "DOGE": "Dogecoin"
    ]
    
    static let cryptoIcons: [String: String] = [
        "BTC": "bitcoin_icon",
        "ETH": "ethereum_icon",
        "SOL": "solana_icon",
        "XRP": "ripple_icon",
        "DOGE": "dogecoin_icon"
    ]
    
    static func fullName(for symbol: String) -> String {
        return cryptoNames[symbol] ?? symbol
    }
    
    static func iconName(for symbol: String) -> String {
        return cryptoIcons[symbol] ?? "default_icon"
    }
}
