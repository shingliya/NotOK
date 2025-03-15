//
//  TradeView.swift
//  NotOK
//
//  Created by Tan Xin Jie on 15/3/25.
//

import SwiftUI

struct TradeView: View {
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Button(action: {}){
                    HStack {
                        Image("bitcoin_icon")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("BTC")
                        Image(systemName: "chevron.down")
                    }
                }
                .buttonStyle(.bordered)
                HStack {
                    Spacer()
                    VStack(alignment: .trailing) {
                        HStack {
                            Text("50 USD")
                                .font(.system(size: 42, weight: .bold))
                            Image(systemName: "chevron.down")
                        }
                        HStack {
                            Image(systemName: "arrow.up.arrow.down")
                            Text("≈0.0043902 BTC")
                        }
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(UIColor.systemGray6))
            )
            .padding()
            VStack(alignment: .leading) {
                Text("Select your payment method")
                HStack {
                    Image(systemName: "wallet.bifold.fill")
                    Text("Your balance")
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("$0")
                        Text("available")
                    }
                    Image(systemName: "chevron.right")
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(UIColor.systemGray6))
            )
            .padding()
            
            PrimaryButton("Buy"){
                
            }
        }
    }
}

#Preview {
    TradeView()
}
