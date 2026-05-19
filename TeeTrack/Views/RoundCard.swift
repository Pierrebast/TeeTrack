//
//  RoundCard.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 12/04/2025.
//

import SwiftUI

struct RoundCard: View {
    var round: StoredGolfRound
    var imageName: String = "roundPreview"
    var action: () -> Void = {}

    var body: some View {
        Button(action: {
            // action() if you want to handle tap
        }) {
            VStack(spacing: 8) {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 90)
                    .clipped()

                Text(round.courseName)
                    .font(.footnote)
                    .foregroundColor(.primaryGreen)

                Text("Score: \(round.totalScore)")
                    .font(.caption)
                    .foregroundColor(.gray)

                Text(formattedDate(round.date))
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(.bottom, 8)
            }
            .frame(width: 140)
            .background(Color.white.opacity(0.9))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray.opacity(0.7), lineWidth: 0.8)
            )
            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
            .padding(.bottom, 12)
        }
    }

    // MARK: - Helpers

    var totalScore: Int {
        round.holeScores.compactMap { Int($0.strokes) }.reduce(0, +)
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}
