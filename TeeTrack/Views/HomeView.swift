//
//  HomeView.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 11/04/2025.
//

import SwiftUI

struct HomeView: View {

    @State private var showMenu = false
    @State private var showWeather = false
    @State private var showStartRound = false
    @State private var showStats = false
    @State private var showSettings = false

    @EnvironmentObject var authVM: AuthViewModel

    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]

    @State private var currentQuote: (quote: String, author: String)? = nil
    @State private var quoteOpacity: Double = 0.0
    @State private var recentRounds: [StoredGolfRound] = []


    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                Color.white.ignoresSafeArea().opacity(0.95)
                //Color.black.opacity(0.05)
                    //.frame(maxHeight: .infinity)
                   // .ignoresSafeArea()

                
                VStack(spacing: 0) {
                    // ✅ Top bar stays fixed
                    TopBarView(title: "Hello, \(authVM.currentUser?.firstName ?? "")👋") {
                        showMenu = true
                    }
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 24) {
                            
                            
                            // Quote
                            if let quote = currentQuote {
                                VStack(spacing: 6) {
                                    ShimmerText(text: "“\(quote.quote)”")
                                        .multilineTextAlignment(.center)
                                    
                                    Text("- \(quote.author)")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                                .opacity(quoteOpacity)
                                .padding(.horizontal, 28)
                            }
                            
                            // Feature Grid
                            LazyVGrid(columns: columns, spacing: 20) {
                                FeatureCard(title: "Start Round", emoji: "⛳️", imageName: "startR", description: "Begin your golf round and track your score.") {showStartRound = true}
                                
                                FeatureCard(title: "Stats", emoji: "📊", imageName: "finalstats", description: "Analyze your golf performance.") {showStats = true}
                                
                                FeatureCard(title: "Training", emoji: "🎯", imageName: "trainingLogo", description: "Improve your skills with drills.") {}
                                
                                FeatureCard(title: "Weather", emoji: "🌦️", imageName: "ww", description: "Check golf course conditions.") {
                                    showWeather = true
                                }
                            }
                            .padding(.horizontal)
                            
                            // Recent Rounds Title
                            Text("Your Most Recent Rounds")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            
                            // Horizontal Scroll of Recent Rounds
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(recentRounds.prefix(3)) { round in
                                        RoundCard(round: round)
                                    }
                                }
                                .padding(.horizontal)
                            }

                            
                            Spacer(minLength: 60)
                                //.padding(.bottom, 30) // ensure it doesn’t bump against bottom
                            NavigationLink(destination: WeatherView(), isActive: $showWeather) {
                                EmptyView()
                            }.hidden()
                           
                            NavigationLink(destination: StartRoundView(), isActive: $showStartRound) {
                                EmptyView()
                            }
                            NavigationLink(destination: StatsView(), isActive: $showStats) {
                                EmptyView()
                            }
                            NavigationLink(destination: SettingsView(), isActive: $showSettings) {
                                EmptyView()
                            }

                            .hidden()

                            

                        }
                        .padding(.top, 12)
                        //.background(Color.black.opacity(0.05)) // ⬅️ local background
                        //.frame(maxHeight: .infinity)
                        //.cornerRadius(0)
                        //.padding(.bottom) // prevents cutoff
                        //.padding(.bottom, 40) // gives room for the shadow to breathe

                    }
                }
                // Slide Menu
                if showMenu {
                    SlideMenuView(
                        onClose: { showMenu = false },
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
                loadRecentRounds()

                let newQuote = GolfQuotes.all.randomElement()
                currentQuote = newQuote
                quoteOpacity = 0.0

                withAnimation(.easeInOut(duration: 1.0)) {
                    quoteOpacity = 1.0
                }
            }
        }
    }
    
    func loadRecentRounds() {
        guard let email = authVM.currentUser?.email else { return }
        let key = "rounds_\(email)"

        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([StoredGolfRound].self, from: data) {
            let sorted = decoded.sorted(by: { $0.date > $1.date })
            recentRounds = sorted
        }
    }

}
