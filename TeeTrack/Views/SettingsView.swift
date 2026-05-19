//
//  SettingsView.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 16/04/2025.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authVM: AuthViewModel

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var golfClub: String = ""
    @State private var handicap: String = ""
    @State private var yearStarted: String = ""

    @State private var showSuccess = false
    @State private var showError = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                BackTopBarView(title: "Account settings") {
                    presentationMode.wrappedValue.dismiss()
                }

                ScrollView {
                    VStack(spacing: 20) {
                        Text("Modify your informations")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.primaryGreen)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 25)

                        Group {
                            CustomTextField(placeholder: "Email", text: $email, keyboardType: .emailAddress)
                            CustomSecureField(placeholder: "New Password", text: $password)
                            CustomTextField(placeholder: "Golf Club", text: $golfClub)
                            CustomTextField(placeholder: "Handicap", text: $handicap, keyboardType: .numberPad)
                            CustomTextField(placeholder: "Year Started Golf", text: $yearStarted, keyboardType: .numberPad)
                        }

                        if showError {
                            Text("Please fill all fields correctly.")
                                .foregroundColor(.red)
                                .font(.footnote)
                        }

                        Button(action: saveChanges) {
                            Text("Save Changes")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.primaryGreen)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .padding(.top)
                    }
                    .padding()
                }
            }

            // ✅ Success Popup Overlay
            if showSuccess {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(spacing: 12) {
                            SuccessIcon()
                                .frame(width: 44, height: 44)

                            Text("Profile updated successfully!")
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
                        Spacer()
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.bottom, 85)
                .transition(.opacity)
            }
        }
        .hideKeyboardOnTap()
        .navigationBarHidden(true)
        .onAppear(perform: loadUserData)

    }

    func loadUserData() {
        guard let user = authVM.currentUser else { return }
        email = user.email
        golfClub = user.golfClub ?? ""
        handicap = "\(user.handicap)"
        yearStarted = user.yearStarted ?? ""
    }

    func saveChanges() {
        dismissKeyboard()

        guard var user = authVM.currentUser else { return }
        guard !email.isEmpty, let handicapInt = Int(handicap) else {
            showError = true
            return
        }

        user.email = email
        if !password.isEmpty {
            user.password = password
        }
        user.golfClub = golfClub
        user.handicap = handicapInt
        user.yearStarted = yearStarted

        authVM.updateUser(user: user)
        showError = false
        showSuccess = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showSuccess = false
            presentationMode.wrappedValue.dismiss()
        }
    }

}
