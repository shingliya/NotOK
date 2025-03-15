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
                HomeView(activeSheet: $activeSheet)
            }
            .tabItem {
                Label("Home", systemImage: "notequal")
            }
            NavigationStack {
                DiscoverView()
            }
            .tabItem {
                Label("Discover", systemImage: "binoculars")
            }
            NavigationStack {
                PortfolioView(activeSheet: $activeSheet)
            }
            .tabItem {
                Label("Portolio", systemImage: "chart.pie.fill")
            }
        }
        .overlay(
            TabBarDivider()
            , alignment: .bottom
        )
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
    let userViewModel = UserViewModel(mockDataMode: false)
    LandingView()
        .environmentObject(userViewModel)
}

enum SheetType: Identifiable {
    case login, signup
    var id: String { String(describing: self) }
}


