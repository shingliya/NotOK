//
//  PrimaryButton.swift
//  NotOK
//
//  Created by Tan Xin Jie on 8/2/25.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    
    var backgroundColor: Color? = nil
    var foregroundColor: Color? = nil
    
    init(_ title: String, foregroundColor: Color? = nil, backgroundColor: Color? = nil, action: @escaping () -> Void) {
        self.title = title
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
                .foregroundColor(foregroundColor)
        }
        .buttonBorderShape(.capsule)
        .buttonStyle(.bordered)
        .controlSize(.extraLarge)
        .background(backgroundColor)
        .clipShape(Capsule())
    }
}
