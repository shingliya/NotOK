//
//  UserViewModel.swift
//  NotOK
//
//  Created by Tan Xin Jie on 5/3/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class UserViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var user: User? = nil
    @Published var errorMessage: String = ""
    
    // temp db object
    private let db = Firestore.firestore()
    
    // flag to use mock data
    private var useMockData: Bool
    
    init(mockDataMode: Bool = false) {
        self.useMockData = mockDataMode
        
        if let currentUser = Auth.auth().currentUser {
            self.isLoggedIn = true
            fetchUserData(currentUser: currentUser)
        } else {
            self.isLoggedIn = false
        }
    }
    
    func fetchUserData(currentUser: FirebaseAuth.User) {
        if useMockData {
            self.user = User(uid: currentUser.uid, email: currentUser.email ?? "example@email.com", cashBalance: 1000.0, coinBalance: ["BTC": 1.5, "ETH": 2.0])
            return
        }
        
        let userRef = db.collection("users").document(currentUser.uid)
        
        userRef.getDocument { [weak self] doc, err in
            guard let self = self else { return }
            
            guard err == nil else {
                self.errorMessage = "Error getting 'users' document from Firestore: \(err!.localizedDescription)"
                return
            }
            
            // User's doc not found, handle new user document creation first
            guard let doc = doc, doc.exists else {
                self.createNewUser(currentUser: currentUser)
                return
            }
            
            do {
                let userData = try doc.data(as: User.self)
                self.user = userData
            } catch {
                self.errorMessage = "Error parsing 'users' document from Firestore: \(error.localizedDescription)"
            }
        }
    }
    
    private func createNewUser(currentUser: FirebaseAuth.User) {
        let userRef = db.collection("users").document(currentUser.uid)
        
        let defaultUserData: [String: Any] = [
            "uid": currentUser.uid,
            "email": currentUser.email ?? "No email",
            "cashBalance": 0.0,
            "coinBalance": [:],
            "transactionHistory": [],
            "favoriteCoins": [],
            "lastLogin": Date()
        ]
        
        userRef.setData(defaultUserData) { [weak self] err in
            if let err = err {
                self?.errorMessage = "Error creating new 'users' in Firestore: \(err.localizedDescription)"
            } else {
                self?.user = User(
                    uid: currentUser.uid,
                    email: currentUser.email ?? "No email",
                    cashBalance: 0.0,
                    coinBalance: [:]
                )
            }
        }
    }
    
    func logoutUser() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
            user = nil
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

struct User: Codable {
    var uid: String
    var email: String
    var cashBalance: Double
    var coinBalance: [String: Double]
}
