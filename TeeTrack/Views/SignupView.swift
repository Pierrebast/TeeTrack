//
//  SignupView.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 11/04/2025.
//

import SwiftUI

struct SignupView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authVM: AuthViewModel
    @State private var showError = false
    
    @State private var showSuccessPopup = false

    @State private var gender: Gender = .male // Default selection



    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            VStack(spacing: 20) {
                

                Text("Create Your Account")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryGreen)
                    .padding(.top,30)
                Spacer()
                // MARK: - Text Fields
                VStack(spacing: 16) {
                    CustomTextField(placeholder: "First Name", text: $firstName)
                    CustomTextField(placeholder: "Last Name", text: $lastName)
                    
                    // ✅ Gender toggle
                        HStack(spacing: 20) {
                            Button(action: { gender = .male }) {
                                HStack {
                                    Image(systemName: gender == .male ? "checkmark.circle.fill" : "circle")
                                    Text("Male")
                                }
                                .foregroundColor(gender == .male ? .primaryGreen : .gray)
                            }

                            Button(action: { gender = .female }) {
                                HStack {
                                    Image(systemName: gender == .female ? "checkmark.circle.fill" : "circle")
                                    Text("Female")
                                }
                                .foregroundColor(gender == .female ? .primaryGreen : .gray)
                            }
                        }
                        .padding(.top, 4)
                    
                    
                    CustomTextField(placeholder: "Email", text: $email, keyboardType: .emailAddress)
                    CustomSecureField(placeholder: "Password", text: $password)
                }
                .padding(.horizontal)
                
                if showError {
                    Text("Please fill in all fields.")
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.top, -10)
                }


                // MARK: - Create Button
                Button(action: {
                    if firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty {
                        showError = true
                    } else {
                        let user = User(
                            firstName: firstName,
                            lastName: lastName,
                            email: email,
                            password: password,
                            handicap: 54,
                            gender:gender
                        )

                        let success = authVM.signup(user: user)

                        if success {
                            showError = false
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) // hide keyboard
                            showSuccessPopup = true

                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                showSuccessPopup = false
                                authVM.isLoggedIn = true // ⬅️ now switch to MainTabView
                            }
                         } else {
                            showError = true
                        }
                    }
                }) {
                    Text("Create Account")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primaryGreen)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.top)



                Spacer()
            }
            .padding()
        }
        .overlay(
            Group {
                if showSuccessPopup {
                    VStack {
                        Spacer() // Top Spacer

                        HStack {
                            Spacer() // Left Spacer

                            VStack(spacing: 12) {
                                SuccessIcon()
                                    .frame(width: 44, height: 44)

                                Text("Account created successfully!")
                                    .font(.headline)
                                    .foregroundColor(.primaryGreen)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                            .frame(maxWidth: 340)
                            .padding(.vertical, 24)
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(radius: 8)

                            Spacer() // Right Spacer
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // Centering HStack in full screen
                        .transition(.opacity)

                        Spacer() // Bottom Spacer
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // Centering VStack in full screen
                    .padding(.bottom, 85) // Adjust the bottom padding as needed
                }


            }
        )

        .navigationBarTitleDisplayMode(.inline)
    }

}

