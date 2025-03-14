//
//  SignupView.swift
//  NotOK
//
//  Created by Tan Xin Jie on 7/2/25.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct SignupView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var activeSheet: SheetType?
    
    @State private var selectedCountry: String = "Singapore"
    @State private var isShowCountries = false
    
    var body: some View {
        NavigationStack {
            VStack (alignment: .leading) {
                VStack (alignment: .leading, spacing: 10) {
                    Text("Where do you currently live?")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Your answers get you started in the right place and ensures accurate verification later.")
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                    
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
                NavigationLink(destination: SignupEmailView()){
                    Text("Create Account")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color.black)
                }
                .buttonBorderShape(.capsule)
                .buttonStyle(.bordered)
                .controlSize(.extraLarge)
                .background(Color.white)
                .clipShape(Capsule())
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
}

struct SignupEmailView: View {
    @State private var email: String = ""
    @FocusState private var isEmailFieldFocused: Bool
    @State private var isValidEmail: Bool = false
    
    var body: some View {
        VStack {
            VStack (alignment: .leading, spacing: 10){
                HStack {
                    Text("Enter your email")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                }
                Text("Ensure this email can receive verification codes.")
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
                TextField("", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .onChange(of: email) {
                        isValidEmail = checkValidEmail(email)
                    }
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isEmailFieldFocused ? Color.white : Color.gray, lineWidth: 1)
                    )
                    .focused($isEmailFieldFocused)
                    .animation(.snappy, value: isEmailFieldFocused)
                    .padding(.vertical, 15)
                Button {
                    
                } label: {
                    Text("Have a referral code?")
                        .font(.callout)
                        .underline()
                        .foregroundColor(Color.white)
                }
            }
            Spacer()
            PrimaryButton("Sign up", foregroundColor: isValidEmail ? .black : .white, backgroundColor: isValidEmail ? .white : .black){
                createUserWithEmail(email: email)
            }
            .disabled(isValidEmail == false)
            .padding(.bottom, 8)
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
        .navChevronBackbutton()
    }
    
    func checkValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return predicate.evaluate(with: email)
    }
    
    func createUserWithEmail(email: String) {
        Auth.auth().createUser(withEmail: email, password: "123456") { authResult, error in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
            } else if let authResult = authResult {
                print("User created successfully: \(authResult.user.uid)")
                print("Email: \(authResult.user.email ?? "No email")")
            }
        }
    }
}

//#Preview {
//    SignupEmailView()
//}

#Preview {
    SignupView(activeSheet: .constant(.signup))
}
