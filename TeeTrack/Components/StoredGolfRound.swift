//
//  StoredGolfRound.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 15/04/2025.
//

import Foundation
struct StoredGolfRound: Identifiable, Codable {
    let id: UUID
    let courseID: UUID
    let courseName: String
    let date: Date
    let holeScores: [HoleScore]

    let totalScore: Int 
}
