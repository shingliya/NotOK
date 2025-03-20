//
//  UserViewModel.swift
//  NotOK
//
//  Created by Tan Xin Jie on 5/3/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct User: Codable {
    var uid: String
    var email: String
    var cashBalance: Double
    var coinBalance: [String: Double]
    var favouriteCoins: [String]
    
    var dictionary: [String: Any] {
        return [
            "uid": uid,
            "email": email,
            "cashBalance": cashBalance,
            "coinBalance": coinBalance,
            "favouriteCoins": favouriteCoins
        ]
    }
    
    var formattedCashBalance: String {
        return String(format: "$%.2f", cashBalance)
    }
}


class FirebaseViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var user: User? = nil
    @Published var errorMessage: String = ""
    
    // temp db object
    private let db = Firestore.firestore()
    
    init(mockDataMode: Bool = false) {

        if mockDataMode {
            self.isLoggedIn = true
            self.user = User(uid: "12345678", email: "example@email.com", cashBalance: 1000.0, coinBalance: ["BTC": 1.5, "ETH": 2.0], favouriteCoins: ["BTC"])
            return
        }
        
        // Check FirebaseAuth for any currentUser and fetch user document if available
        if let currentUser = Auth.auth().currentUser {
            Task {
                try await fetchUserDocument(currentUser: currentUser)
                await MainActor.run {
                    self.isLoggedIn = true
                }
            }
        } else {
            self.isLoggedIn = false
        }
    }
    
    private func createUserDocument(uid: String, email: String) async throws -> () {
        let userRef = db.collection("users").document(uid)
        let userData = User(uid: uid, email: email, cashBalance: 0.0, coinBalance: [:], favouriteCoins: [])
        
        try await userRef.setData(userData.dictionary)
    }
    
    func fetchUserDocument(currentUser: FirebaseAuth.User) async throws -> () {
        let uid = currentUser.uid
        
        let userRef = db.collection("users").document(uid)
        let snapshot = try await userRef.getDocument()
        
        if !snapshot.exists {
            guard let email = currentUser.email else {
                throw NSError(domain: "UserDocumentError", code: 400, userInfo: [NSLocalizedDescriptionKey: "No email found for current user"])
            }
            try await createUserDocument(uid: uid, email: email)
        }
        
        guard let userObj = try snapshot.data(as: User?.self) else {
            throw NSError(domain: "UserDocumentError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to decode user document"])
        }
        
        await MainActor.run {
            self.user = userObj
        }
    }
    
    // Signup function with success and failure callbacks
    func signUp(email: String, password: String, onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void) {
        Task {
            do {
                let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
                let uid = authResult.user.uid
                try await self.createUserDocument(uid: uid, email: email)
                await MainActor.run {
                    onSuccess()
                }
            } catch {
                await MainActor.run{
                    onFailure("Sign-up failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // Login function with success and failure callbacks
    func login(email: String, password: String, onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void) {
        Task {
            do {
                let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
                try await fetchUserDocument(currentUser: authResult.user)
                
                await MainActor.run{
                    onSuccess()
                }
            } catch {
                await MainActor.run{
                    onFailure("Login failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            self.isLoggedIn = false
        } catch {
            print("Error during logout: \(error.localizedDescription)")
        }
    }
}
