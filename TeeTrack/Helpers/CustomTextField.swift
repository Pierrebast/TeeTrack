//
//  CustomTextField.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 11/04/2025.
//

import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
            }

            TextField("", text: $text)
                .keyboardType(keyboardType)
                .autocapitalization(.words)
                .disableAutocorrection(true)
                .foregroundColor(.gray)
        }
        .padding(12) // Apply padding here to the whole ZStack
        .background(Color.white.opacity(0.8))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.primaryGreen, lineWidth: 1.5)
        )
        .cornerRadius(10)
    }
}


