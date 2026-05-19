//
//  CourseCard.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 14/04/2025.
//

import SwiftUI

struct CourseCard: View {
    var course: GolfCourse
    var imageName: String = "coursePreview" // Use your generated image

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 160)
                .clipped()
                .cornerRadius(12)

            VStack(alignment: .leading, spacing: 4) {
                Text(course.name)
                    .font(.headline)
                    .foregroundColor(.primaryGreen)

                Text(course.location)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text("\(course.holes.count) Holes")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 12)
        }
        .background(Color.white.opacity(0.95))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.2), lineWidth: 0.8)
        )
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 4)
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}
