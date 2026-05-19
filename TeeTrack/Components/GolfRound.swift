//
//  GolfRound.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 12/04/2025.
//

import Foundation

struct GolfRound: Identifiable {
    let id = UUID()
    let courseName: String
    let date: String
    let score: Int
}
let sampleRounds: [GolfRound] = [
    GolfRound(courseName: "Pebble Beach", date: "Apr 8", score: 86),
    GolfRound(courseName: "Royal County Down", date: "Apr 3", score: 91),
    GolfRound(courseName: "St Andrews", date: "Mar 29", score: 89),
]
