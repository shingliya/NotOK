//
//  GlowyTabBarDivider.swift
//  NotOK
//
//  Created by Tan Xin Jie on 14/3/25.
//


import SwiftUI

struct TabBarDivider: View {
    var body: some View {
        GeometryReader { geo in
            Rectangle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.gray.opacity(0.6),
                            Color.gray.opacity(0.4),
                            Color.clear
                        ]),
                        center: .center,
                        startRadius: 1,
                        endRadius: geo.size.width / 1.8
                    )
                )
                .frame(height: 0.5)
                .offset(y: -49)
        }
        .frame(height: 1)
    }
}
