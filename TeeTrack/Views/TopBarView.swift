//
//  TopBarView.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 11/04/2025.
//

import SwiftUI

struct TopBarView: View {
    var title: String
    var showMenuButton: Bool = true
    var onMenuTapped: (() -> Void)? = nil

    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.9)

            Spacer()

            if showMenuButton, let onMenuTapped = onMenuTapped {
                Button(action: onMenuTapped) {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .foregroundColor(.white)
                        .font(.title2)
                }
            }
        }
        .padding(.horizontal)
        .frame(height: 65)
        .background(Color.primaryGreen.opacity(0.8))
    }
}


