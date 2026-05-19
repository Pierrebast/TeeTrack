//
//  CustomSecureField.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 11/04/2025.
//

import SwiftUI

struct CustomSecureField: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
            }

            SecureField("", text: $text)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .foregroundColor(.gray)
        }
        .padding(12)
        .background(Color.white.opacity(0.8))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.primaryGreen, lineWidth: 1.5)
        )
        .cornerRadius(10)
    }
}
