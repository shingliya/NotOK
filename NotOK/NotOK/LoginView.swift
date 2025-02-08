//
//  LoginView.swift
//  NotOK
//
//  Created by Tan Xin Jie on 7/2/25.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var activeSheet: SheetType?
    
    @State private var loginName = ""
    @State private var loginType = 0
    @FocusState private var isLoginFieldFocused: Bool
    
    @State private var password: String = ""
    @FocusState private var isPasswordFieldFocused: Bool
    
    @State private var isValidEmail = false
    
    var body: some View {
        VStack {
            LoginTypeToggleView(loginType: $loginType)
            
            LoginTextField(text: $loginName, isFocused: $isLoginFieldFocused)
                .keyboardType(loginType == 0 ? .numberPad : .emailAddress)
                .textContentType(loginType == 0 ? .telephoneNumber : .emailAddress)
                .disableAutocorrection(true)
                .withClearButton(text: $loginName)
                .onChange(of: loginType) {
                    isLoginFieldFocused = false
                    loginName = ""
                }
                .onChange(of: loginName) {
                    isValidEmail = false
                }
                .padding(.bottom)
            
            if isValidEmail {
                withAnimation {
                    VStack (alignment: .leading) {
                        Text("Login password")
                            .foregroundColor(.gray)
                        LoginTextField(text: $password, isFocused: $isPasswordFieldFocused, isSecure: true)
                        NavigationLink("Forgot your password?", destination: Text("too bad hahaha"))
                            .underline()
                    }
                    .padding(.bottom)
                }
            }
            
            PrimaryButton(isValidEmail ? "Log in" : "Next"){
                withAnimation{
                    if checkValidEmail(loginName) {
                        isValidEmail = true
                    }
                }
            }
            .disabled(loginName.isEmpty || (isValidEmail && password.isEmpty))
            .padding(.bottom)
            
            HStack {
                Text("Don't have an account?")
                Button {
                    dismiss()
                    activeSheet = .signup
                } label: {
                    Text("Sign up")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
            }
            
            Spacer()
            
            ZStack {
                Divider()
                Text("or continue with")
                    .padding()
                    .background(Color(UIColor.systemBackground))
            }
            Button {
                // Call Apple Account Login
            } label: {
                Image(systemName: "applelogo")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(
                        Circle()
                            .stroke(Color.white, lineWidth: 0.5)
                    )
            }
        }
        .padding()
        .navigationTitle("Log in")
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
    
    func checkValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return predicate.evaluate(with: email)
    }
}

#Preview {
    LoginView(activeSheet: .constant(.login))
}

struct LoginTypeToggleView: View {
    @Binding var loginType: Int
    
    var body: some View {
        HStack {
            ForEach(0..<2) { index in
                Text(index == 0 ? "Phone" : "Email")
                    .fontWeight(loginType == index ? .bold : .regular)
                    .foregroundColor(loginType == index ? .white : .gray)
                    .onTapGesture {
                        withAnimation(.snappy) {
                            loginType = index
                        }
                    }
                    .padding(.trailing)
            }
            Spacer()
        }
    }
}
