//
//  FeatureCard.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 11/04/2025.
//
import SwiftUI

struct FeatureCard: View {
    var title: String
    var emoji: String
    var imageName: String // New property for the image
    var description: String // New property for the description
    var action: () -> Void = {}

    @State private var isPressed = false

    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.05)) {
                isPressed = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                isPressed = false
                action()
            }
        }) {
            VStack(spacing: 12) {
                // Image on top with resizing and filling the width of the card
                Image(imageName) // Replace this with your image
                    .resizable()
                    .scaledToFill() // Fills the card width while maintaining aspect ratio
                    .frame(height: 130) // Set fixed height
                    .clipped()  // Ensure no overflow

                // Title and emoji with smaller font size
                HStack {
                    Text(emoji)
                        .font(.system(size: 24)) // Smaller emoji size
                        .padding(.trailing, 5)

                    Text(title)
                        .font(.subheadline) // Smaller title font
                        .foregroundColor(.primaryGreen)
                }
                .padding(.top, 6)

                // Description for each card with smaller font size
                Text(description)
                    .font(.footnote) // Smaller description text
                    .foregroundColor(.gray)
                    .padding(.top, 3)
                    .padding(.bottom, 10)
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, minHeight: 175) // Ensure card height consistency
            .background(Color.white.opacity(0.9))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray.opacity(0.7), lineWidth: 0.8)
            )
            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
            .scaleEffect(isPressed ? 0.96 : 1.0)
        }
    }
}
