//
//  AuthViewModel.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 11/04/2025.
//

import Foundation
import SwiftUI

class AuthViewModel: ObservableObject {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @Published var currentUser: User?

    func signup(user: User) -> Bool {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(user) {
            // Save user by email
            UserDefaults.standard.set(data, forKey: user.email)

            // Save current user's email
            UserDefaults.standard.set(user.email, forKey: "currentUserEmail")

            self.currentUser = user
            // DO NOT set isLoggedIn here anymore
            return true
        }
        return false
    }

    func login(email: String, password: String) -> Bool {
        if let data = UserDefaults.standard.data(forKey: email),
           let savedUser = try? JSONDecoder().decode(User.self, from: data),
           savedUser.password == password {
            self.currentUser = savedUser
            UserDefaults.standard.set(email, forKey: "currentUserEmail")
            isLoggedIn = true
            return true
        }
        return false
    }

    func loadUser() {
        if let email = UserDefaults.standard.string(forKey: "currentUserEmail"),
           let data = UserDefaults.standard.data(forKey: email),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            self.currentUser = user
        }
    }

    func logout() {
        isLoggedIn = false
        currentUser = nil
        UserDefaults.standard.removeObject(forKey: "currentUserEmail")
    }
    
    func updateUser(user: User) {
        self.currentUser = user
        saveUser(user) // ✅ This persists the changes
    }

    private func saveUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: user.email) // ✅ Use email key
        }
    }




}


