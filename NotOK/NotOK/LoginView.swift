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
    @EnvironmentObject var userViewModel: UserViewModel
    
    @Environment(\.dismiss) var dismiss
    @Binding var activeSheet: SheetType?
    
    @State private var loginType = 0
    @State private var loginField = ""
    @FocusState private var isLoginFieldFocused: Bool
    
    @State private var passwordField: String = ""
    @FocusState private var isPasswordFieldFocused: Bool
    
    @State private var isValidEmail = false
    
    @State private var errorMessage: String = ""
    @State private var isLoggedIn: Bool = false
    
    
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
                    loginUser(email: loginField, password: passwordField)
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
            if isLoggedIn {
                Text("Successfully logged in!")
                    .foregroundColor(.green)
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
    
    func loginUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = "Login failed: \(error.localizedDescription)"
                return
            }
            
            if let authResult = authResult {
                isLoggedIn = true
                errorMessage = ""
                userViewModel.fetchUserData(currentUser: authResult.user)
                dismiss()
//                print("Logged in successfully with user: \(authResult.user.email ?? "No email")")
//                if let loggedUser = Auth.auth().currentUser {
//                    print(loggedUser)
//                }
            }
        }
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
