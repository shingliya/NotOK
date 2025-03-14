//
//  AboutNotOKView.swift
//  NotOK
//
//  Created by Tan Xin Jie on 6/3/25.
//

import SwiftUI

struct AboutNotOKView: View {
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: "notequal.square.fill")
                .resizable()
                .frame(width: 80, height: 80)
            Text("NotOK")
                .font(.title)
                .fontWeight(.bold)
            HStack {
                Text("Version 0.00.0")
                    .font(.caption)
            }
            VStack(alignment: .leading, spacing: 30) {
                NavigationLink (destination: Color.red){
                    HStack {
                        Text("Terms of Service")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
                NavigationLink (destination: Color.red){
                    HStack {
                        Text("Privacy Notice")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
                NavigationLink (destination: Color.red){
                    HStack {
                        Text("Risk and Compilance Disclosures")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
                Divider()
                NavigationLink (destination: Color.red){
                    HStack {
                        Text("Check for updates")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
                Button(action: {
                    // URLCache.shared.removeAllCachedResponses()
                }) {
                    HStack {
                        Text("Clear cache")
                        Spacer()
                        Text("0 MB")
                        Image(systemName: "chevron.right")
                    }
                }
                Spacer()
            }
            .buttonStyle(PlainButtonStyle())
            .padding()
        }
        .navChevronBackbutton()
    }
}

#Preview {
    AboutNotOKView()
}
