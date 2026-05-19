//
//  ProfileView.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 11/04/2025.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var showMenu = false
    @EnvironmentObject var authVM: AuthViewModel
    @State private var showSettings = false

    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                Color.white.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    TopBarView(title: "Profile") {
                        withAnimation {
                            showMenu = true
                        }
                    }

                    if let user = authVM.currentUser {
                        // MARK: - Profile Header
                        HStack(alignment: .center, spacing: 16) {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .foregroundColor(.primaryGreen)
                                .frame(width: 60, height: 60)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(user.firstName) \(user.lastName)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primaryGreen)

                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }

                            Spacer()
                        }
                        .padding(.top,30)
                        .padding(.horizontal)

                        // MARK: - Personal Info
                        VStack(alignment: .leading, spacing: 16) {
                            Text("👤 Personal Info")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.primaryGreen)

                            InfoRow(title: "Email", value: user.email)
                            InfoRow(title: "Gender", value: user.gender.rawValue.capitalized)
                            // You can add password change logic below this line later
                        }
                        .padding(.horizontal)
                        .padding(.top,30)

                        Divider().padding(.horizontal)

                        // MARK: - Golf Info
                        Text("⛳️ Golf Info")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.primaryGreen)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)

                        VStack(spacing: 12) {
                            InfoRow(title: "Handicap", value: "\(user.handicap)")
                            
                            InfoRow(title: "Gender", value: user.gender.rawValue.capitalized)
                            
                            InfoRow(title: "Golf Club", value: user.golfClub?.isEmpty == false ? user.golfClub! : "Not set")


                            InfoRow(title: "Started Golf", value: user.yearStarted != nil ? "\(user.yearStarted!)" : "Not set")

                        }
                        .padding(.horizontal)


                        Divider().padding(.horizontal)
                    }
                    NavigationLink(destination: SettingsView(), isActive: $showSettings) {
                        EmptyView()
                    }

                    Spacer(minLength: 60)
                }

                // Slide Menu
                if showMenu {
                    SlideMenuView(
                        onClose:  { showMenu = false },
                        onProfile: { },
                        onSettings: {
                            showMenu = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                showSettings = true
                            }
                        },
                        onLogout: {
                            showMenu = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.26) {
                                authVM.logout()
                            }
                        }
                    )
                    .transition(.move(edge: .trailing))
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                if let savedUser = authVM.currentUser {
                    // This will cause view to redraw if the data changed
                    _ = savedUser.golfClub // touching values to make SwiftUI re-render
                }
            }

            
        }
    }

    // MARK: - Info Row View
    func InfoRow(title: String, value: String) -> some View {
        HStack {
            Text(title + ":")
                .foregroundColor(.primaryGreen)
            Spacer()
            Text(value)
                .foregroundColor(.gray)
        }
        .font(.headline)
    }
}
