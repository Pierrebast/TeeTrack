//
//  WelcomeView.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 11/04/2025.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var authVM: AuthViewModel

    @State private var email = ""
    @State private var password = ""
    @State private var showLoginError = false
    @State private var showSignup = false
    
    @State private var isLoggingIn = false
    @State private var isAnimatingLogin = false
    @State private var isAnimatingSignup = false


    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()

                VStack(spacing: 24) {
                    //Spacer()

                    // Title
                    Text("Welcome to TeeTrack")
                        .font(.custom("AvenirNext-DemiBold", size: 28))

                        .foregroundColor(.primaryGreen)
                        .multilineTextAlignment(.center)
                        .padding(.top,30)

                    // Subtitle
                    Text("Track your golf progress, scores and stats.")
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Spacer()
                    // Login Fields
                    VStack(spacing: 16) {
                        CustomTextField(placeholder: "Email", text: $email, keyboardType: .emailAddress)
                        CustomSecureField(placeholder: "Password", text: $password)
                    }
                    .padding(.horizontal)

                    // Error Message
                    if showLoginError {
                        Text("Invalid email or password.")
                            .foregroundColor(.red)
                            .font(.footnote)
                    }

                    Button(action: {
                        // Tap scale animation
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isAnimatingLogin = true
                        }
                        
                        // Dismiss keyboard
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

                        // Wait a little so the button tap effect plays before transition triggers
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            let success = authVM.login(email: email, password: password)
                            
                            if success {
                                // ✅ THIS animation triggers the view transition in TeeTrackApp
                                withAnimation(.easeInOut(duration: 0.6)) {
                                    authVM.isLoggedIn = true
                                }
                            } else {
                                showLoginError = true
                            }
                            
                            // Reset tap animation
                            isAnimatingLogin = false
                        }
                    }) {
                        Text("Log In")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.primaryGreen)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .scaleEffect(isAnimatingLogin ? 0.95 : 1.0)
                            .animation(.easeInOut(duration: 0.2), value: isAnimatingLogin)
                    }
                    .padding(.horizontal)


                    // Create Account Button
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isAnimatingSignup = true
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            showSignup = true
                            isAnimatingSignup = false
                        }
                    }) {
                        Text("Create Account")
                            .fontWeight(.semibold)
                            .foregroundColor(.primaryGreen)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.primaryGreen, lineWidth: 2)
                            )
                            .cornerRadius(12)
                            .scaleEffect(isAnimatingSignup ? 0.95 : 1.0)
                            .animation(.easeInOut(duration: 0.2), value: isAnimatingSignup)
                    }
                    .padding(.horizontal)


                    Spacer(minLength: 40)

                    // Navigation
                    NavigationLink(destination: SignupView(), isActive: $showSignup) { EmptyView() }
                }
                .padding()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

