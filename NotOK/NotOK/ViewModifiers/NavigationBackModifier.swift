//
//  NavigationBackModifier.swift
//  NotOK
//
//  Created by Tan Xin Jie on 4/3/25.
//

import SwiftUI

struct NavigationBackModifier: ViewModifier {
    @Environment(\.dismiss) var dismiss
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                }
            }
    }
}

extension View {
    func chevronNavBackButton() -> some View {
        self.modifier(NavigationBackModifier())
    }
}
