//
//  LandingView.swift
//  NotOK
//
//  Created by Tan Xin Jie on 7/2/25.
//

import SwiftUI

struct LandingView: View {
    @State private var isShowLogin = false
    @State private var isShowSignup = false
    
    @State private var activeSheet: SheetType? = nil
    
    var body: some View {
        NavigationStack {
            TabView {
                LandingHomeView(activeSheet: $activeSheet)
                VStack {
                    ContentUnavailableView("No Content Available",
                                           systemImage: "tray.fill",
                                           description: Text("Check back later or try again."))
                    Divider()
                }
                .tabItem {
                    Label("Discover", systemImage: "binoculars")
                }
                VStack {
                    ContentUnavailableView("No Content Available",
                                           systemImage: "tray.fill",
                                           description: Text("Check back later or try again."))
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
            .toolbar {
                ToolbarItem(placement: .topBarLeading){
                    NavigationLink(destination: EmptyView()) {
                        Image(systemName: "circle.grid.3x3")
                            .foregroundColor(.primary)
                    }
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
                Button {
                    activeSheet = .login
                }  label : {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                }
                .buttonBorderShape(.capsule)
                .buttonStyle(.bordered)
                .controlSize(.extraLarge)
                
                Button {
                    activeSheet = .signup
                } label: {
                    Text("Sign up")
                        .frame(maxWidth: .infinity)
                }
                .buttonBorderShape(.capsule)
                .buttonStyle(.borderedProminent)
                .controlSize(.extraLarge)
            }
            .padding()
            Divider()
        }
        .tabItem {
            Label("Home", systemImage: "star")
        }
    }
}

enum LandingSheetType: Identifiable {
    case login, signup
    
    var id: String { String(describing: self) }
}
