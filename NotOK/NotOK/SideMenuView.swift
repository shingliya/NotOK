//
//  SideMenuView.swift
//  NotOK
//
//  Created by Tan Xin Jie on 10/2/25.
//

import SwiftUI

struct SideMenuView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var activeSheet: SheetType? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            VStack(alignment: .leading) {
                Text("Welcome to OKX")
                    .font(
                        .title2
                        .weight(.bold)
                    )
                Text("Experience lightning-fast tading and low fees")
                    .fontWeight(.light)
            }
            HStack {
                PrimaryButton("Log in", foregroundColor: .white, backgroundColor: .black){
                    activeSheet = .login
                }
                PrimaryButton("Sign up", foregroundColor: .black, backgroundColor: .white){
                    activeSheet = .login
                }
            }
            VStack(alignment: .leading) {
                Text("More")
                    .fontWeight(.bold)
                HStack {
                    Button{
                        
                    } label: {
                        VStack {
                            Image(systemName: "questionmark.circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                            Text("Support")
                        }
                        .foregroundColor(.white)
                    }
                    .padding()
                    Button{
                        
                    } label: {
                        VStack {
                            Image(systemName: "gearshape")
                                .resizable()
                                .frame(width: 25, height: 25)
                            Text("Preferences")
                        }
                        .foregroundColor(.white)
                    }
                    .padding()
                }
            }
            Spacer()
        }
        .padding()
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

#Preview {
    SideMenuView()
}
