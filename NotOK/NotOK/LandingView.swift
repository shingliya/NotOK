//
//  LandingView.swift
//  NotOK
//
//  Created by Tan Xin Jie on 7/2/25.
//

import SwiftUI

struct LandingView: View {
    @State private var activeSheet: SheetType? = nil
    
    var body: some View {
        TabView {
            NavigationStack {
                LandingHomeView(activeSheet: $activeSheet)
                Divider()
            }
            .tabItem {
                Label("Home", systemImage: "star")
            }
            VStack {
                DiscoverView()
                Spacer()
                Divider()
            }
            .tabItem {
                Label("Discover", systemImage: "binoculars")
            }
            VStack {
                PortfolioView()
                Spacer()
                Divider()
            }
            .tabItem {
                Label("Portolio", systemImage: "chart.pie.fill")
            }
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

#Preview {
    LandingView()
}

struct LandingHomeView: View {
    @Binding var activeSheet: SheetType?
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                PrimaryButton("Login", foregroundColor: .white){
                    activeSheet = .login
                }
                PrimaryButton("Sign up", foregroundColor: .black, backgroundColor: .white){
                    activeSheet = .login
                }
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading){
                NavigationLink(destination: SideMenuView()) {
                    Image(systemName: "circle.grid.3x3")
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

enum SheetType: Identifiable {
    case login, signup
    var id: String { String(describing: self) }
}
