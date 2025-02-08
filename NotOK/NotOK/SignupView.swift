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

    @State private var selectedCountry: String = "Singapore"
    @State private var isShowCountries = false
    
    var body: some View {
        VStack (alignment: .leading) {
            VStack (alignment: .leading) {
                Text("Where do you currently live?")
                    .font(
                        .title
                        .weight(.bold)
                    )
                Text("Your answers get you started in the right place and ensures accurate verification later.")
            }
            .padding(.bottom)
            
            Text("I live in")
            Button {
                isShowCountries.toggle()
            } label: {
                HStack {
                    Label{
                        Text(selectedCountry)
                    } icon : {
                        Image(.singapore)
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    Spacer()
                    Image(systemName: "chevron.down")
                }
                .foregroundColor(.white)
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.gray)
            )
            
            Spacer()
            PrimaryButton("Create account", foregroundColor: .black, backgroundColor: .white){
                // Call create account function
            }
            PrimaryButton("Log in instead", foregroundColor: .white){
                dismiss()
                activeSheet = .login
            }
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
        .sheet(isPresented: $isShowCountries, content: {
            EmptyView()
        })
    }
}

#Preview {
    SignupView(activeSheet: .constant(.signup))
}
