//
//  RoundDetailView.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 15/04/2025.
//

import SwiftUI

struct RoundDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let round: StoredGolfRound
    let course: GolfCourse

    // Define fixed widths per column to align everything
    let columnWidths: [CGFloat] = [50, 60, 40, 40, 50, 60, 50]

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                // ✅ Top Bar
                BackTopBarView(title: "Round Details") {
                    presentationMode.wrappedValue.dismiss()
                }

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // ✅ Header Info
                        VStack(alignment: .leading, spacing: 8) {
                            Text(round.courseName)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.primaryGreen)

                            Text(formattedDate(round.date))
                                .font(.subheadline)
                                .foregroundColor(.gray)

                            Text("Total Score: \(round.totalScore)")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        .padding(.horizontal)

                        Divider().padding(.horizontal)

                        let holeMap = Dictionary(uniqueKeysWithValues: course.holes.map { ($0.id, $0) })

                        // ✅ Table Header + Rows
                        ScrollView(.horizontal, showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 12) {
                                // Header
                                HStack(spacing: 0) {
                                    headerCell("Hole", width: columnWidths[0])
                                    headerCell("Dist.", width: columnWidths[1])
                                    headerCell("Par", width: columnWidths[2])
                                    headerCell("SI", width: columnWidths[3])
                                    headerCell("Score", width: columnWidths[4])
                                    headerCell("Green", width: columnWidths[5])
                                    headerCell("Putts", width: columnWidths[6])
                                }

                                Divider()

                                // Rows
                                ForEach(round.holeScores, id: \.id) { score in
                                    let hole = holeMap[score.id]

                                    HStack(spacing: 0) {
                                        dataCell("\(score.id)", width: columnWidths[0])
                                        dataCell("\(hole?.distance ?? 0)m", width: columnWidths[1])
                                        dataCell("\(hole?.par ?? 0)", width: columnWidths[2])
                                        dataCell("\(hole?.strokeIndex ?? 0)", width: columnWidths[3])
                                        dataCell(score.strokes, width: columnWidths[4])
                                        dataCell(score.hitsToGreen.isEmpty ? "-" : score.hitsToGreen, width: columnWidths[5])
                                        dataCell(score.putts.isEmpty ? "-" : score.putts, width: columnWidths[6])
                                    }
                                    .frame(height: 32)
                                    .background(Color.gray.opacity(0.05))
                                    .cornerRadius(6)
                                    //.foregroundColor(.primaryGreen)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 12)
                        }

                        Divider().padding(.horizontal)

                        // ✅ Final Score Summary
                        HStack {
                            Spacer()
                            Text("Total Points: \(round.totalScore) ⛳️")
                                .font(.title2)
                                .foregroundColor(.primaryGreen)
                            Spacer()
                        }
                        .padding(.top, 16)
                        .padding(.bottom, 40)

                        Spacer(minLength: 60)
                    }
                    .padding(.top)
                }
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Helpers

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }

    func headerCell(_ text: String, width: CGFloat) -> some View {
        Text(text)
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(.primaryGreen)
            .frame(width: width, alignment: .leading)
    }

    func dataCell(_ text: String, width: CGFloat) -> some View {
        Text(text)
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.primaryGreen)
            .frame(width: width, alignment: .leading)
    }
}
