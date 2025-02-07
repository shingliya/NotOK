//
//  SignupView.swift
//  NotOK
//
//  Created by Tan Xin Jie on 7/2/25.
//

import SwiftUI

struct SignupView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var activeSheet: SheetType?
    
    var body: some View {
        VStack {
            VStack (alignment: .leading) {
                Text("Where do you currently live?")
                    .font(
                        .title
                        .weight(.bold)
                    )
                Text("Your answers get you started in the right place and ensures accurate verification later.")
            }
            Spacer()
            Button {
              // Call login here
            }  label : {
                Text("Create account")
                    .frame(maxWidth: .infinity)
            }
            .buttonBorderShape(.capsule)
            .buttonStyle(.bordered)
            .controlSize(.extraLarge)
            .padding(.bottom)
            
            Button {
                dismiss()
                activeSheet = .login
            }  label : {
                Text("Log in instead")
                    .frame(maxWidth: .infinity)
            }
            .buttonBorderShape(.capsule)
            .buttonStyle(.bordered)
            .controlSize(.extraLarge)
            .padding(.bottom)
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarLeading){
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

#Preview {
    SignupView(activeSheet: .constant(.signup))
}
