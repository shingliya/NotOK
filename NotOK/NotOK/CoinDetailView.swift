//
//  CoinDetailView.swift
//  NotOK
//
//  Created by Tan Xin Jie on 24/2/25.
//

import SwiftUI

struct CoinDetailView: View {
    let tokenPair: String
    @StateObject private var viewModel: WebSocketViewModel

    init(tokenPair: String) {
        self.tokenPair = tokenPair
        self._viewModel = StateObject(wrappedValue: WebSocketViewModel(tokenPair: tokenPair))
    }
    
    var body: some View {
        let coinSymbol = tokenPair.split(separator: "-").first ?? ""
        let fullCoinName = CryptoMapper.fullName(for: String(coinSymbol))
        let iconName = CryptoMapper.iconName(for: String(coinSymbol))
        let percentage = viewModel.coinDetail.formattedDeltaPercentage()
        
        VStack (alignment: .leading) {
            HStack {
                Image(iconName)
                    .resizable()
                    .scaledToFit()
                .frame(width: 20, height: 20)
                Text(coinSymbol)
                    .font(.title3)
                    .fontWeight(.bold)
                Text(fullCoinName)
                    .fontWeight(.light)
                Spacer()
            }
            Text("$\(viewModel.coinDetail.price)")
                .font(.title)
            HStack {
                Text("\(viewModel.coinDetail.delta)")
                    .fontWeight(.light)
                    .foregroundColor(viewModel.coinDetail.delta.hasPrefix("-") ? .red : .green)
                Text("(\(percentage))")
                    .fontWeight(.light)
                    .foregroundColor(percentage.hasPrefix("-") ? .red : .green)
                Text("past day")
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .onAppear(){
            viewModel.connect()
        }
        .onDisappear {
            viewModel.disconnect()
        }
    }
}

#Preview {
    CoinDetailView(tokenPair: "BTC-USDT")
        .environmentObject(WebSocketViewModel(tokenPair: ""))
}
