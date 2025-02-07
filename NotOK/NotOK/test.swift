//
//  test.swift
//  NotOK
//
//  Created by Tan Xin Jie on 7/2/25.
//

import SwiftUI

enum SheetType: Identifiable {
    case login, signup
    
    var id: String { String(describing: self) }
}

struct test: View {
    @State private var activeSheet: SheetType? = nil // Track active sheet

       var body: some View {
           VStack {
               Button("Show Login") { activeSheet = .login }
               Button("Show Signup") { activeSheet = .signup }
           }
           .sheet(item: $activeSheet) { sheet in
               switch sheet {
               case .login:
                   Login2View(activeSheet: $activeSheet)
               case .signup:
                   Signup2View(activeSheet: $activeSheet)
               }
           }
       }
}

struct Login2View: View {
    @Binding var activeSheet: SheetType?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Text("Login Screen")
                .font(.title)

            Button("Switch to Sign Up") {
                dismiss()
                activeSheet = .signup // Show Signup
            }
            .padding()

            Button("Close") {
                dismiss()
            }
        }
    }
}

struct Signup2View: View {
    @Binding var activeSheet: SheetType?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Text("Sign Up Screen")
                .font(.title)

            Button("Switch to Login") {
                dismiss()
                activeSheet = .login // Show Login
            }
            .padding()

            Button("Close") {
                dismiss()
            }
        }
    }
}

#Preview {
    test()
}
