//
//  ShimmerTextCard.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 12/04/2025.
//

import SwiftUI

struct ShimmerTextCard: View {
    let text: String
    var font: Font = .title3
    var italic: Bool = true

    @State private var shimmerX: CGFloat = -1.0

    var body: some View {
        ZStack {
            // Base gray text (always visible)
            Text(text)
                .font(.headline)
                //.italic(italic)
                .foregroundColor(.gray)

            // Green shimmer overlay
            Text(text)
                .font(.headline)
                //.italic(italic)
                .foregroundColor(.primaryGreen)
                .opacity(1) // ⬅️ make the green shimmer fully visible
                .mask(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .clear, location: 0.0),
                            .init(color: .white.opacity(0.9), location: 0.4),
                            .init(color: .white, location: 0.5),
                            .init(color: .white.opacity(0.9), location: 0.6),
                            .init(color: .clear, location: 1.0),
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: 180) // ⬅️ wider beam
                    .offset(x: shimmerX * 350)
                )
        }
        .onAppear {
            shimmerX = -1.0
            withAnimation(.linear(duration: 3.2).repeatForever(autoreverses: false)) {
                shimmerX = 1.0
            }
        }
    }
}
