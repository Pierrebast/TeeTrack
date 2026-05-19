//
//  Background.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 11/04/2025.
//

import SwiftUI

struct Background: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                    .ignoresSafeArea()

                Image("TeeTrackLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 1.05)
                    .opacity(0.15)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
        }
    }
}

extension View {
    func fadedBackground() -> some View {
        self.background(Background())
    }
}
