//
//  ScoreLineChart.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 15/04/2025.
//

import SwiftUI

struct ScoreLineChart: View {
    let rounds: [StoredGolfRound]
    @State private var selectedRound: StoredGolfRound? = nil
    @State private var selectedPoint: CGPoint? = nil

    var body: some View {
        GeometryReader { geometry in
            let padding: CGFloat = 24
            let width = geometry.size.width - padding * 2
            let height: CGFloat = 200
            let xOffset: CGFloat = padding

            let scores = rounds.map { $0.totalScore }
            let maxScore = scores.max() ?? 100
            let minScore = scores.min() ?? 0
            let scoreRange = CGFloat(maxScore - minScore + 1)
            let pointSpacing = width / CGFloat(max(rounds.count - 1, 1))

            let points: [CGPoint] = rounds.enumerated().map { index, round in
                let x = CGFloat(index) * pointSpacing + xOffset
                let y = height - ((CGFloat(round.totalScore - minScore) / scoreRange) * height)
                return CGPoint(x: x, y: y)
            }

            ZStack {
                // Tap outside to dismiss
            

                // Axis
                Path { path in
                    path.move(to: CGPoint(x: xOffset, y: 0))
                    path.addLine(to: CGPoint(x: xOffset, y: height))
                    path.move(to: CGPoint(x: xOffset, y: height))
                    path.addLine(to: CGPoint(x: width + xOffset, y: height))
                }
                .stroke(Color.clear.opacity(0.2), lineWidth: 1)

                // Area fill
                if points.count > 1 {
                    Path { path in
                        path.move(to: CGPoint(x: points.first!.x, y: height))
                        for point in points {
                            path.addLine(to: point)
                        }
                        path.addLine(to: CGPoint(x: points.last!.x, y: height))
                        path.closeSubpath()
                    }
                    .fill(Color.primaryGreen.opacity(0.2))
                }

                // Main line
                Path { path in
                    guard points.count > 1 else { return }
                    path.move(to: points.first!)
                    for point in points.dropFirst() {
                        path.addLine(to: point)
                    }
                }
                .stroke(Color.primaryGreen, lineWidth: 2)

                // Dots & Labels
                ForEach(Array(rounds.enumerated()), id: \.1.id) { index, round in
                    let point = points[index]

                    Circle()
                        .fill(Color.primaryGreen)
                        .frame(width: 10, height: 10)
                        .position(point)
                        .onTapGesture {
                            selectedRound = round
                            selectedPoint = point
                        }

                    Text("\(round.totalScore)")
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .position(x: point.x, y: point.y - 14)

                    let spacing = max(rounds.count / 4, 1)

                    ForEach(Array(rounds.enumerated()), id: \.1.id) { index, round in
                        let point = points[index]

                        // Always show first
                        if index == 0 {
                            xLabel(for: round, at: point, height: height)

                        }
                        // Show spaced mid-points
                        else if index % spacing == 0 && index != rounds.count - 1 {
                            xLabel(for: round, at: point, height: height)

                        }
                        // Only show last if far enough
                        else if index == rounds.count - 1 {
                            let prev = points[safe: index - 1]
                            if prev == nil || abs(point.x - prev!.x) > 40 {
                                xLabel(for: round, at: point, height: height)

                            }
                        }
                    }



                }

                // Tooltip
                if let round = selectedRound, let point = selectedPoint {
                    VStack(spacing: 6) {
                        Text(round.courseName)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.primaryGreen)

                        Text("\(round.holeScores.count) holes")
                            .font(.caption2)
                            .foregroundColor(.gray)

                        Text(fullDate(round.date))
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.primaryGreen.opacity(0.4), lineWidth: 1)
                    )
                    .position(x: point.x, y: point.y - 60)
                    .transition(.scale)
                }
            }
            .frame(height: height + 24)
            .background(Color.white.opacity(0.001)) // invisible but clickable
            .onTapGesture {
                selectedRound = nil
                selectedPoint = nil
            }
        }
        .frame(height: 260)
        .padding(.horizontal, 24) // apply global padding
    }

    func shortDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }

    func fullDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    @ViewBuilder
    func xLabel(for round: StoredGolfRound, at point: CGPoint, height: CGFloat) -> some View {
        Text(shortDate(round.date))
            .font(.caption2)
            .foregroundColor(.gray)
            .position(x: point.x, y: height + 10)
    }
    


}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
