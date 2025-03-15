//
//  CoinDetailView.swift
//  NotOK
//
//  Created by Tan Xin Jie on 24/2/25.
//

import SwiftUI

struct CoinDetailView: View {
    let tokenPair: String
    @StateObject private var viewModel: CoinDetailViewModel

    init(tokenPair: String) {
        self.tokenPair = tokenPair
        self._viewModel = StateObject(wrappedValue: CoinDetailViewModel(tokenPair: tokenPair))
    }
    
    var body: some View {
        let coinSymbol = tokenPair.split(separator: "-").first ?? ""
        let fullCoinName = CryptoMapper.fullName(for: String(coinSymbol))
        let iconName = CryptoMapper.iconName(for: String(coinSymbol))
        let percentage = viewModel.coinDetail.formattedDeltaPercentage()
        
        ZStack(alignment: .bottom) {
            ScrollView {
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
                        Text("(\(percentage)%)")
                            .fontWeight(.light)
                            .foregroundColor(percentage.hasPrefix("-") ? .red : .green)
                        Text("past day")
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding()
                Spacer()
                    .frame(height: 250)
                Divider()
                VStack (alignment: .leading, spacing: 25) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("About \(fullCoinName)")
                                .font(.title3)
                                .fontWeight(.bold)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        Text("Layer 1")
                            .font(.caption)
                            .padding(5)
                            .background(RoundedRectangle(cornerRadius: 3).fill(Color.gray.opacity(0.3)))
                        Text("Bitcoin is a peer-to-peer form of digital currency")
                    }
                    SentimentDetailView(coinSymbol: coinSymbol)
                    OverallHealthDetailView()
                }
                .padding()
            }
            HStack {
                VStack(alignment: .leading) {
                    Text("$\(viewModel.coinDetail.price)")
                        .bold()
                    Text("\(percentage)%")
                        .foregroundColor(percentage.hasPrefix("-") ? .red : .green)
                }
                Spacer()
                PrimaryButton("Buy and sell", foregroundColor: .white, backgroundColor: .blue){
                }
                .frame(width: UIScreen.main.bounds.width * 0.5)
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .padding(.bottom, 15)
            .padding()
            .background(Color(UIColor.systemGray6))
            .overlay(
                TabBarDivider(yOffset: -97)
                , alignment: .bottom
            )
        }
        .onAppear(){
            viewModel.connect()
        }
        .onDisappear {
            viewModel.disconnect()
        }
        .navChevronBackbutton()
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    CoinDetailView(tokenPair: "BTC-USDT")
        .environmentObject(CoinDetailViewModel(tokenPair: ""))
}

struct OverallHealthDetailView: View {
    let columns = Array(repeating: GridItem(), count: 2)
    let items = ["24h volume", "Market cap", "All-time high", "Average hold time", "Past year return", ""]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Overall health")
                    .font(.title3)
                    .fontWeight(.bold)
                Image(systemName: "info.circle")
                Spacer()
            }
            LazyVGrid(columns: columns, alignment: .leading, spacing: 10){
                ForEach(items, id: \.self) { item in
                    Text(item)
                }
            }
        }
    }
}

struct SentimentDetailView: View {
    var coinSymbol: Substring
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Text("\(coinSymbol) sentiment")
                    .font(.title3)
                    .fontWeight(.bold)
                Image(systemName: "info.circle")
            }
            HStack {
                VStack (alignment: .leading, spacing: 15) {
                    Text("30% Buying")
                    ProgressBar(percentage: 0.3)
                    Text("70% Selling")
                    ProgressBar(percentage: 0.7)
                }
                ZStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: max(100, UIScreen.main.bounds.width * 0.2),
                               height: max(100, UIScreen.main.bounds.width * 0.2))
                    Text("30%")
                        .font(.title)
                        .fontWeight(.bold)
                }
            }
        }
        Spacer()
    }
}


