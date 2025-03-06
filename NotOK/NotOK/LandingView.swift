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
                Label("Home", systemImage: "notequal")
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
    let userViewModel = UserViewModel(mockDataMode: true)
    LandingView()
        .environmentObject(userViewModel)
}

struct LandingHomeView: View {
    @Binding var activeSheet: SheetType?
    
    @State private var blackHeight: CGFloat = 0
    @State private var textColor: Color = .black
    
    var body: some View {
        ZStack {
            Color.white
            
            GeometryReader { geo in
                ZStack {
                    Circle()
                        .trim(from: 0.5, to: 1)
                        .frame(width: geo.size.width * 1.5)
                        .foregroundColor(.black)
                        .offset(y: -blackHeight * 0.5 + 200)
                    Color.black
                        .frame(height: blackHeight)
                }
                .position(x: geo.size.width / 2, y: geo.size.height - blackHeight / 2)
            }
            .ignoresSafeArea()
            
            VStack {
                VStack {
                    Text("A New \n Alternative")
                        .font(.system(size: 40, weight: .bold))
                        .multilineTextAlignment(.center)
                    Text("To your Crypto Journey")
                        .font(.subheadline)
                }
                .foregroundColor(textColor)
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
        .onAppear {
            blackHeight = 0
            textColor = .black
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                withAnimation(.smooth(duration: 0.2)) {
                    textColor = .white
                }
            }
            withAnimation(.easeOut(duration: 1.5)) {
                blackHeight = UIScreen.main.bounds.height
            }
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
