//
//  HoleScoreCard.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 15/04/2025.
//

import SwiftUI

struct HoleScoreCard: View {
    var holeNumber: Int
    var par: Int
    var distance: Int
    var strokeIndex: Int
    @Binding var score: HoleScore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Hole \(holeNumber)")
                    .font(.headline)
                    .foregroundColor(.primaryGreen)
                Spacer()
                Text("\(distance)m • Par \(par) • SI \(strokeIndex)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            // Required
            CustomTextField(placeholder: "Score", text: $score.strokes, keyboardType: .numberPad)

            Divider()
                .padding(.top, 4)

            Text("Optional Stats")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.top, -4)

            // Optional fields side by side
            HStack(spacing: 12) {
                CustomTextField(placeholder: "To Green", text: $score.hitsToGreen, keyboardType: .numberPad)
                CustomTextField(placeholder: "Putts", text: $score.putts, keyboardType: .numberPad)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
        .padding(.horizontal)

    }
}

