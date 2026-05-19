//
//  TeeTrackApp.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 11/04/2025.
//

import SwiftUI

@main
struct TeeTrackApp: App {
    @StateObject var authVM = AuthViewModel()
    @State private var isLoading = true

    init() {
        // Tint color for selected icon
        UITabBar.appearance().tintColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)

        // Background to match your opacity look
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(white: 0.85, alpha: 1) // Light gray, semi-transparent

        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
       // tabBarAppearance.shadowColor = UIColor.black.withAlphaComponent(0.05)

    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                if isLoading {
                    LaunchScreenView()
                        .transition(.opacity)
                } else {
                    ZStack {
                        if authVM.isLoggedIn {
                            MainTabView()
                                .transition(.opacity)
                        } else {
                            WelcomeView()
                                .transition(.opacity)
                        }
                    }
                    .id(authVM.isLoggedIn)
                    .animation(.easeInOut(duration: 0.6), value: authVM.isLoggedIn)
                }
            }
            .animation(.easeInOut(duration: 0.9), value: isLoading)
            .environmentObject(authVM)
            .onAppear {
                authVM.loadUser()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        isLoading = false
                    }
                }
            }
        }
    }
}
