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
    @State private var isLoggedIn = true
    
    let manageAssetsItems = [
        ("plus.circle", "Buy"),
        ("minus.circle", "Sell"),
        ("bolt.horizontal.circle", "Convert"),
        ("arrow.down.circle", "Deposit"),
        ("arrow.up.circle", "Withdraw"),
    ]
    
    let moreItems = [
        ("questionmark.circle", "Support"),
        ("book.pages", "Transactions"),
        ("newspaper", "Account statement")
    ]
    
    var body: some View {
        if isLoggedIn {
            NavigationLink(destination: Color.red) {
                HStack(alignment: .top, spacing: 15) {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.gray)
                    VStack (alignment: .leading, spacing: 5) {
                        Text("ExampleUser")
                            .bold()
                            .foregroundColor(.white)
                        Text("Profile and settings")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("Badge")
                            .font(.caption)
                            .padding(.horizontal, 3)
                            .background(
                                RoundedRectangle(cornerRadius: 3)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .overlay(
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray),
                    alignment: .trailing
                )
                .padding(.top)
                .padding(.horizontal)
            }
            VStack(alignment: .leading) {
                Text("Manage Assets")
                    .font(.subheadline)
                    .bold()
                    .padding(.top)
                    .padding(.horizontal)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 20) {
                    ForEach(manageAssetsItems, id: \.1) { item in
                        SideMenuButton(iconName: item.0, text: item.1)
                    }
                }
                .padding()
                Divider()
                Text("More")
                    .font(.subheadline)
                    .bold()
                    .padding(.top)
                    .padding(.horizontal)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 20) {
                    ForEach(moreItems, id: \.1) { item in
                        SideMenuButton(iconName: item.0, text: item.1)
                    }
                }
                .padding()
            }
            Spacer()
            NavigationLink(destination: Color.red) {
                HStack {
                    Image(systemName: "info.circle")
                    Text("About NotOK")
                        .font(.footnote)
                    Spacer()
                    HStack {
                        Text("v0.00.0")
                            .font(.caption2)
                        Image(systemName: "chevron.right")
                            .resizable()
                            .frame(width: 5, height:5)
                    }
                }
                .padding()
                .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .navChevronBackbutton()
        } else {
            VStack(alignment: .leading, spacing: 25) {
                VStack(alignment: .leading) {
                    Text("Welcome to NotOK")
                        .font(
                            .title2
                                .weight(.bold)
                        )
                    Text("Not experience lightning-fast tading and low fees")
                        .font(.subheadline)
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
                        SideMenuButton(iconName: "questionmark.circle", text: "Support")
                        SideMenuButton(iconName: "gearshape", text: "Preferences")
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
}

#Preview {
    SideMenuView()
}

struct SideMenuButton: View {
    var iconName = ""
    var text = ""
    
    var body: some View {
        Button{
            
        } label: {
            VStack {
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .padding(.bottom, 3)
                Text(text)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                Spacer()
            }
            .foregroundColor(.white)
        }
        .frame(maxWidth: 80, maxHeight: 80)
    }
}
