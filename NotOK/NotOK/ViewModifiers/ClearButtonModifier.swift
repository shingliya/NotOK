//
//  ClearButtonModifier.swift
//  NotOK
//
//  Created by Tan Xin Jie on 8/2/25.
//

import SwiftUI

struct ClearButton: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if !text.isEmpty {
                        Button(action: { text = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 10)
                        }
                    }
                },
                alignment: .trailing
            )
    }
}

extension View {
    func withClearButton(text: Binding<String>) -> some View {
        self.modifier(ClearButton(text: text))
    }
}
