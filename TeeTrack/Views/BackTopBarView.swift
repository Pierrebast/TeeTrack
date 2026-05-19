//
//  BackTopBarView.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 12/04/2025.
//
import SwiftUI

struct BackTopBarView: View {
    var title: String
    var onBackTapped: () -> Void

    var body: some View {
        HStack {
            // ⬅️ Back button
            Button(action: onBackTapped) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            .frame(width: 44) // Fixed width for symmetry

            Spacer()

            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)

            Spacer()

            // ➡️ Ghost button to center the title
            Color.clear
                .frame(width: 44) // Match the back button's width
        }
        .padding(.horizontal)
        .frame(height: 65)
        .background(Color.primaryGreen.opacity(0.8))
    }
}
