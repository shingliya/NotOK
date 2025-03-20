//
//  PortfolioView.swift
//  NotOK
//
//  Created by Tan Xin Jie on 10/2/25.
//

import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject var userViewModel: FirebaseViewModel
    
    @Binding var activeSheet: SheetType?
    
    @State private var isLoggedIn = true
    @State private var isValueHidden = false
    
    var body: some View {
        if userViewModel.isLoggedIn {
            NavigationStack {
                if isLoggedIn {
                    VStack {
                        VStack(alignment: .leading) {
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Est total value")
                                            .font(.subheadline)
                                        Button {
                                            isValueHidden.toggle()
                                        } label: {
                                            Image(systemName: isValueHidden ? "eye.slash" : "eye")
                                                .foregroundColor(.white)
                                        }
                                    }
                                    Text(isValueHidden ? "*****" : "\(userViewModel.user?.formattedCashBalance ?? "ERROR") SGD")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    Text(isValueHidden ? "*******" : "+S$0 (+0.00%) Today")
                                        .font(.subheadline)
                                }
                                Spacer()
                            }
                        }
                        VStack {
                            Image(systemName: "square.grid.3x1.folder.badge.plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 75)
                                .padding()
                            Text("Make your first move")
                                .bold()
                            Text("Get crypto to start building your portfolio")
                                .font(.subheadline)
                            PrimaryButton("Make a deposit", foregroundColor: Color.white, backgroundColor: Color.blue){
                            }
                            PrimaryButton("Buy crypto", foregroundColor: Color.white){
                                
                            }
                        }
                        .padding()
                        Spacer()
                    }
                    .navigationTitle("Portfolio")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing){
                            NavigationLink(destination: EmptyView()) {
                                Image(systemName: "book.pages")
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    .padding()
                    
                } else {
                    VStack{
                        Spacer()
                        HStack {
                            PrimaryButton("Log in", foregroundColor: .white, backgroundColor: .black){
                                activeSheet = .login
                            }
                            PrimaryButton("Sign up", foregroundColor: .black, backgroundColor: .white){
                                activeSheet = .login
                            }
                        }
                        .padding()
                    }
                    .sheet(item: $activeSheet) { sheet in
                        NavigationStack {
                            switch sheet {
                            case .login:
                                LoginView(activeSheet: $activeSheet)
                            case .signup:
                                SignupView(activeSheet: $activeSheet)
                            }
                        }
                    }
                }
            }
        } else {
            VStack {
                VStack {
                    Spacer()
                        .frame(height: 500)
                    Text("Level up your portfolio")
                        .font(.system(size: 30, weight: .bold))
                        .multilineTextAlignment(.center)
                }
                .foregroundColor(Color.white)
                Spacer()
                HStack (alignment: .bottom) {
                    PrimaryButton("Login", foregroundColor: .white){
                        activeSheet = .login
                    }
                    PrimaryButton("Sign up", foregroundColor: .black, backgroundColor: .white){
                        activeSheet = .signup
                    }
                }
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    let userViewModel = FirebaseViewModel(mockDataMode: true)
    
    PortfolioView(activeSheet: .constant(nil))
        .environmentObject(userViewModel)
}
