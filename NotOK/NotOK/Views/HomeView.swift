//
//  HomeView.swift
//  NotOK
//
//  Created by Tan Xin Jie on 14/3/25.
//


import SwiftUI

struct HomeView: View {
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