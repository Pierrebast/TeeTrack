//
//  MainTabView.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 11/04/2025.
//

import SwiftUI

struct MainTabView: View {
    
    @State private var selectedTab = 0 // Home tab

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                        
                }

            CoursesView()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Courses")
                        .font(.custom("AvenirNext-DemiBold", size: 20))

                }

            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
    }
}
