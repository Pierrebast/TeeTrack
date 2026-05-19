//
//  SlideMenuView.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 11/04/2025.
//
import SwiftUI


struct SlideMenuView: View {
    
    var onClose: () -> Void
    var onProfile: () -> Void
    var onSettings: () -> Void
    var onLogout: () -> Void

    @State private var showContent = false

    var body: some View {
        ZStack(alignment: .trailing) {
            if showContent {
                Color.black.opacity(0.15)
                    .ignoresSafeArea()
                    .background(.ultraThinMaterial)
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation (.easeInOut(duration: 0.3)){
                            showContent = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            onClose()
                        }
                    }
            }

            if showContent {
                VStack(alignment: .leading, spacing: 0) {
                    Spacer().frame(height: 60)

                   // menuButton(title: "👤 Profile", action: onProfile)
                   // dividerLine()

                    menuButton(title: "⚙️ Account", action: onSettings)
                    dividerLine()

                    menuButton(title: "⏻ Log Out", action: onLogout, isLogout: true)

                    Spacer()
                }
                .frame(width: 260)
                .frame(maxHeight: .infinity)
                .background(Color.white.opacity(0.8))
                //.background(Color.primaryGreen.opacity(0.8))
                .cornerRadius(12, corners: [.topLeft, .bottomLeft])
                .shadow(radius: 10)
                .ignoresSafeArea()
                .transition(.move(edge: .trailing))
            }
        }
        .zIndex(2)
        .onAppear {
            withAnimation {
                showContent = true
            }
        }
    }

    func menuButton(title: String, action: @escaping () -> Void, isLogout: Bool = false) -> some View {
        Button(action: {
            withAnimation (.easeInOut(duration: 0.2)){
                showContent = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                action()
                onClose()
            }
        }) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .lineLimit(1)
                .minimumScaleFactor(0.9)

                .foregroundColor(isLogout ? .red : .gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 18)
                .padding(.horizontal, 20)
        }
    }

    func dividerLine() -> some View {
        Rectangle()
            .fill(Color.gray.opacity(0.35))
            .frame(height: 1)
            //.padding(.horizontal, 20)
    }
}
