//
//  HoleScore.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 15/04/2025.
//

import Foundation

struct HoleScore: Identifiable, Codable {
    let id: Int  // Hole number (1-based)
    var strokes: String = ""
    var hitsToGreen: String = ""
    var putts: String = ""
}
