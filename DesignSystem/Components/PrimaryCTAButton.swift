//
//  PrimaryCTAButton.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 06/02/26.
//


import SwiftUI

struct PrimaryCTAButton: View {
    let title: String
    let icon: String
    let onTap: () -> Void

    init(
        title: String,
        icon: String = "play.circle.fill",
        onTap: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.onTap = onTap
    }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.title3)

                Text(title)
                    .font(.headline)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .opacity(0.9)
            }
            // tinta clara no CTA, sem neon.
            .foregroundStyle(Theme.background)
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Theme.accent)
            )
        }
        .buttonStyle(.plain)
    }
}
