//
//  BTCPriceView.swift
//  NotOK
//
//  Created by Tan Xin Jie on 13/2/25.
//

import SwiftUI

struct CoinsMenuView: View {
    @StateObject private var viewModel = PollingViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Crypto Prices (Polling)")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                List(viewModel.coinDetails.sorted(by: { $0.key < $1.key }), id: \.key) { token, price in
                    NavigationLink(destination: CryptoDetailView(pair: token)) {
                        HStack {
                            Text(token)
                                .font(.headline)
                                .frame(width: 100, alignment: .leading)
                            
                            Spacer()
                            
                            Text("$\(price.price)")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.green)
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
            .onAppear {
                viewModel.startPolling()
            }
        }
    }
}

#Preview {
    CoinsMenuView()
}

struct CryptoDetailView: View {
    let pair: String
    @StateObject private var viewModel: WebSocketViewModel

    init(pair: String) {
        self.pair = pair
        self._viewModel = StateObject(wrappedValue: WebSocketViewModel(tokenPair: pair))
    }
    
    var body: some View {
        VStack {
            Text("Live Price for \(pair)")
                .font(.largeTitle)
                .bold()
                .padding()

            Text("$\(viewModel.coinDetail.price)")
                .font(.system(size: 50, weight: .bold))
                .foregroundColor(.blue)
                .padding()
            
            Spacer()
        }
        .onAppear(){
            viewModel.connect()
        }
        .onDisappear {
            viewModel.disconnect()
        }
    }
}

