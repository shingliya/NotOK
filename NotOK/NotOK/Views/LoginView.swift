//
//  LoginView.swift
//  NotOK
//
//  Created by Tan Xin Jie on 7/2/25.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct LoginView: View {
    @EnvironmentObject var firebaseViewModel: FirebaseViewModel
    
    @Environment(\.dismiss) var dismiss
    @Binding var activeSheet: SheetType?
    
    @State private var loginType = 0
    @State private var loginField = ""
    @FocusState private var isLoginFieldFocused: Bool
    
    @State private var passwordField: String = ""
    @FocusState private var isPasswordFieldFocused: Bool
    
    @State private var isValidEmail = false
    
    @State private var errorMessage: String = ""
    
    
    var body: some View {
        VStack {
            LoginTypeToggleView(loginType: $loginType)
            
            LoginTextField(text: $loginField, isFocused: $isLoginFieldFocused)
                .keyboardType(loginType == 0 ? .numberPad : .emailAddress)
                .textContentType(loginType == 0 ? .telephoneNumber : .emailAddress)
                .disableAutocorrection(true)
                .withClearButton(text: $loginField)
                .onChange(of: loginType) {
                    isLoginFieldFocused = false
                    loginField = ""
                }
                .onChange(of: loginField) {
                    isValidEmail = false
                }
                .padding(.bottom)
            
            if isValidEmail {
                withAnimation {
                    VStack (alignment: .leading) {
                        Text("Login password")
                            .foregroundColor(.gray)
                        LoginTextField(text: $passwordField, isFocused: $isPasswordFieldFocused, isSecure: true)
                        NavigationLink("Forgot your password?", destination: Text("too bad hahaha"))
                            .underline()
                    }
                    .padding(.bottom)
                }
            }
            
            PrimaryButton(isValidEmail ? "Log in" : "Next"){
                withAnimation{
                    if checkValidEmail(loginField) {
                        isValidEmail = true
                    }
                }
                
                // Login function
                if isValidEmail && passwordField.isEmpty == false {
                    firebaseViewModel.login(email: loginField, password: passwordField, onSuccess: {
                        dismiss()
                    }, onFailure: { errorMessage in
                        self.errorMessage = errorMessage
                    })
                }
            }
            .disabled(loginField.isEmpty || (isValidEmail && passwordField.isEmpty))
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
            
            // Login feedback placeholder
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
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
