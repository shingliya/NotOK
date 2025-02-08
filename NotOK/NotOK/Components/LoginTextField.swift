//
//  LoginTextField.swift
//  NotOK
//
//  Created by Tan Xin Jie on 8/2/25.
//

import SwiftUI

struct LoginTextField: View {
    @Binding var text: String
    @FocusState.Binding var isFocused: Bool
    
    var isSecure: Bool = false
    
    var body: some View {
        if isSecure {
            SecureField("", text: $text)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isFocused ? Color.white : Color.gray, lineWidth: 1)
                )
                .focused($isFocused)
                .animation(.snappy, value: isFocused)
        } else {
            TextField("", text: $text)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isFocused ? Color.white : Color.gray, lineWidth: 1)
                )
                .focused($isFocused)
                .animation(.snappy, value: isFocused)
        }
    }
}
