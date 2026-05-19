//
//  SuccessIcon.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 11/04/2025.
//

import SwiftUI

struct SuccessIcon: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.primaryGreen)
                .frame(width: 36, height: 36)

            Image(systemName: "checkmark")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
        }
    }
}

