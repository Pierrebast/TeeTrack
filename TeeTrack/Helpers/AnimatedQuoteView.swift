//
//  AnimatedQuoteView.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 12/04/2025.
//

import SwiftUI

struct AnimatedQuoteView: View {
    let quote: String
    var font: Font = .title3
    var italic: Bool = true

    @State private var visibleWords: Set<Int> = []
    @State private var currentIndex = 0
    @State private var timer: Timer? = nil

    var body: some View {
        let words = quote.components(separatedBy: " ")

        Text(attributedQuote(words: words))
            .multilineTextAlignment(.center)
            .onAppear {
                startLoopingAnimation(words: words)
            }
            .onDisappear {
                timer?.invalidate()
            }
    }

    func startLoopingAnimation(words: [String]) {
        visibleWords = []
        currentIndex = 0
        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { t in
            if currentIndex < words.count {
                withAnimation(.easeOut(duration: 0.3)) {
                    visibleWords.insert(currentIndex)
                }
                currentIndex += 1
            } else {
                // Restart after a short pause
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    visibleWords = []
                    currentIndex = 0
                }
            }
        }
    }

    func attributedQuote(words: [String]) -> AttributedString {
        var result = AttributedString("")
        for (index, word) in words.enumerated() {
            var attrWord = AttributedString(word)
            attrWord.font = .system(size: 18, weight: .regular, design: .default)
            attrWord.foregroundColor = visibleWords.contains(index) ? .primaryGreen : .clear
            attrWord += AttributedString(" ")
            result += attrWord
        }

        if italic {
            result.inlinePresentationIntent = .emphasized
        }

        return result
    }
}
