//
//  ScorecardView.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 15/04/2025.
//

import SwiftUI

struct ScorecardView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var showSuccessPopup = false
    @State private var showValidationError = false
    
    @State private var showScoreModal = false
    @State private var isCalculating = true
    @State private var calculatedScore: Int = 0

   

    var course: GolfCourse
    @State private var scores: [HoleScore]

    init(course: GolfCourse) {
        self.course = course
        _scores = State(initialValue: course.holes.map { hole in
            HoleScore(id: hole.id)
        })
    }

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                BackTopBarView(title: "Scorecard") {
                    presentationMode.wrappedValue.dismiss()
                }

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(course.name)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.primaryGreen)
                            .padding(.horizontal)

                        ForEach(scores.indices, id: \.self) { i in
                            let hole = course.holes[i]
                            HoleScoreCard(
                                holeNumber: hole.id,
                                par: hole.par,
                                distance: hole.distance,
                                strokeIndex: hole.strokeIndex,
                                score: $scores[i]
                            )
                        }

                        // Save Button + Validation Message
                        VStack(spacing: 8) {
                            if showValidationError {
                                Text("Please complete all fields before saving your scorecard.")
                                    .foregroundColor(.red)
                                    .font(.footnote)
                                    .padding(.top, 8)
                                    .padding(.horizontal)
                            }

                            Button(action: {
                                dismissKeyboard()
                                if scores.contains(where: { $0.strokes.trimmingCharacters(in: .whitespaces).isEmpty }) {
                                    showValidationError = true
                                } else {
                                    saveRound()
                                    showValidationError = false
                                    calculatedScore = calculateTotalScore()
                                    showScoreModal = true
                                    isCalculating = true

                                    // Simulate 2-second calculation
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                        isCalculating = false
                                    }

                                }
                            }) {
                                Text("Save Round")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.primaryGreen)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.top, 24)
                        .padding(.bottom, 60) // enough space to avoid keyboard/tab bar
                    }
                    .padding(.top)
                }

            }
        }
       // .ignoresSafeArea(.keyboard)
        .hideKeyboardOnTap()
        .navigationBarHidden(true)
        .overlay(
            Group {
                if showScoreModal {
                    ZStack {
                        Color.white.opacity(0.65).ignoresSafeArea()

                        VStack(spacing: 28) {
                            if isCalculating {
                                ProgressView("Calculating your score...")
                                    .progressViewStyle(CircularProgressViewStyle(tint: .primaryGreen))
                                    .foregroundColor(.primaryGreen)
                                    .padding()
                            } else {
                                VStack(spacing: 12) {
                                    Text("Your Total Score:")
                                        .font(.title3)
                                        .foregroundColor(.primaryGreen)

                                    Text("⛳️ \(calculatedScore)")
                                        .font(.system(size: 40, weight: .bold))
                                        .foregroundColor(.primaryGreen)

                                    let result = emojiForScore(calculatedScore)

                                    Text(result.emoji)
                                        .font(.system(size: 36))

                                    Text(result.message)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)


                                    Button(action: {
                                        showScoreModal = false

                                        // Dismiss this view → go back to StartRoundView
                                        presentationMode.wrappedValue.dismiss()
                                    }) {
                                        Text("Save to Stats")
                                            .fontWeight(.semibold)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(Color.primaryGreen)
                                            .foregroundColor(.white)
                                            .cornerRadius(12)
                                            .padding(.horizontal)
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(20)
                                .shadow(radius: 10)
                                
                                .padding(.horizontal, 30)
                            }
                        }
                    }
                }
            }
        )

    }

    func saveRound() {
        guard let email = authVM.currentUser?.email else { return }

        let totalNetScore = calculateTotalScore()

        let newRound = StoredGolfRound(
            id: UUID(),
            courseID: course.id,
            courseName: course.name,
            date: Date(),
            holeScores: scores,
            totalScore: totalNetScore // 👈 store the actual net score!
        )

        let key = "rounds_\(email)"
        var existing: [StoredGolfRound] = []

        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([StoredGolfRound].self, from: data) {
            existing = decoded
        }

        existing.append(newRound)

        if let updated = try? JSONEncoder().encode(existing) {
            UserDefaults.standard.set(updated, forKey: key)
        }
    }

    
    
    func emojiForScore(_ score: Int) -> (emoji: String, message: String) {
        switch score {
        case ..<16:
            return ("😅", "Keep practicing, you’ll get there!")
        case 16...19:
            return ("👏", "Nice round, solid game!")
        default:
            return ("🏆", "Amazing performance!")
        }
    }


    
    func calculateTotalScore() -> Int {
        guard let gender = authVM.currentUser?.gender else { return 0 }

        let totalStrokes = gender == .female ? 12 : 11
        let holeCount = course.holes.count
        
        // First give 1 to each hole
        var strokesPerHole = Array(repeating: 1, count: holeCount)
        
        // Then distribute the remaining strokes to hardest holes
        let remaining = totalStrokes - holeCount
        if remaining > 0 {
            // Sort stroke indexes (lower = harder), keep indices
            let sortedBySI = course.holes.enumerated()
                .sorted(by: { $0.element.strokeIndex < $1.element.strokeIndex })
            
            for i in 0..<remaining {
                let holeIndex = sortedBySI[i].offset
                strokesPerHole[holeIndex] += 1
            }
        }

        // Calculate total points
        var totalPoints = 0

        for i in 0..<holeCount {
            guard let playerStrokes = Int(scores[i].strokes) else { continue }
            let hole = course.holes[i]
            let handicapStrokes = strokesPerHole[i]
            let netPar = hole.par + handicapStrokes
            let diff = netPar - playerStrokes
            let points = max(2 + diff, 0)
            totalPoints += points
        }

        return totalPoints
    }


}
