//
//  User.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 11/04/2025.
//

import Foundation

enum Gender: String, Codable {
    case male
    case female
}

struct User: Codable {
    var firstName: String
    var lastName: String
    var email: String
    var password: String
    var handicap: Int
    var gender: Gender // ✅ NEW
    var golfClub: String?
    var yearStarted: String?
}
