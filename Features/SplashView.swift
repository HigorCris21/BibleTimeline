//
//  SplashView.swift
//  BibleTimeline
//

import SwiftUI

struct SplashView: View {

    @State private var opacity: Double = 0
    @State private var scale: Double = 0.85
    @State private var isFinished = false

    let onFinish: () -> Void

    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: "book.pages.fill")
                    .font(.system(size: 64, weight: .light))
                    .foregroundStyle(Theme.accent)

                VStack(spacing: 4) {
                    Text("Bible Timeline")
                        .font(.title.weight(.bold))
                        .foregroundStyle(Theme.primaryText)

                    Text("Bíblia em ordem cronológica")
                        .font(.subheadline)
                        .foregroundStyle(Theme.secondaryText)
                }
            }
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                // Fade in
                withAnimation(.easeOut(duration: 0.6)) {
                    opacity = 1
                    scale = 1
                }

                // Fade out e chama onFinish
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeIn(duration: 0.4)) {
                        opacity = 0
                        scale = 1.05
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        onFinish()
                    }
                }
            }
        }
    }
}
