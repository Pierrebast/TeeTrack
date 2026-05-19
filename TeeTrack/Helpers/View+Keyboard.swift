//
//  View+Keyboard.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 15/04/2025.
//

import SwiftUI

extension View {
    func hideKeyboardOnTap() -> some View {
        self.gesture(
            TapGesture()
                .onEnded {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
        )
    }
    
    func dismissKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                            to: nil, from: nil, for: nil)
        }
}
