//
//  ProgressBar.swift
//  NotOK
//
//  Created by Tan Xin Jie on 14/3/25.
//

import SwiftUI

struct ProgressBar: View {
    let percentage: CGFloat
    let height: CGFloat = 10
    var barColor: Color = Color.blue
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height:height)
                RoundedRectangle(cornerRadius: 15)
                    .fill(barColor)
                    .frame(width: geometry.size.width * percentage, height: height)
            }
        }
        .frame(height: height)
    }
}
