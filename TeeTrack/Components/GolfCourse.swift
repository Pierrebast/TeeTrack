//
//  GolfCourse.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 14/04/2025.
//

import Foundation

struct GolfCourse: Identifiable, Codable {
    let id: UUID
    var name: String
    var location: String
    var holes: [Hole]

    struct Hole: Codable, Identifiable {
        let id: Int // Hole 1 to 18
        var distance: Int
        var par: Int
        var strokeIndex: Int
    }
}

