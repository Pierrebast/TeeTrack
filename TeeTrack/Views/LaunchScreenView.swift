//
//  LaunchScreenView.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 11/04/2025.
//

import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        ZStack {
            Color.primaryGreen
                .ignoresSafeArea()

            VStack(spacing: 30) {
                SwingLoadingView()
                

                Text("TeeTrack")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    
                //GolfProgressView()
                    //.frame(height: 30)
            }
        }
    }
}

struct GolfProgressView: View {
    @State private var offset: CGFloat = -100

    var body: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .frame(height: 6)
                .foregroundColor(.white.opacity(0.3))
                .frame(width: 200)

            Circle()
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
                .overlay(Text("⛳️")) // Golf emoji or ball image
                .offset(x: offset)
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: false), value: offset)
        }
        .onAppear {
            offset = 180 // animate to the right end
        }
    }
}
struct SwingLoadingView: View {
    @State private var isSwinging = false

    var body: some View {
        Image("SWING")
            .resizable()
            .scaledToFit()
            .frame(width: 120, height: 120)
            .rotationEffect(.degrees(isSwinging ? 15 : -15))
            .animation(
                .easeInOut(duration: 1.3).repeatForever(autoreverses: true),
                value: isSwinging
            )
            .onAppear {
                isSwinging = true
            }
    }
}

