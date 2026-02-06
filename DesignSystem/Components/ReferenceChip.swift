//
//  ReferenceChip.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 06/02/26.
//


import SwiftUI

struct ReferenceChip: View {
    private let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .foregroundStyle(Theme.primaryText)
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(
                Capsule(style: .continuous)
                    .fill(Theme.accent.opacity(0.12))
            )
            .overlay(
                Capsule(style: .continuous)
                    .stroke(Theme.accent.opacity(0.18), lineWidth: 1)
            )
            .accessibilityLabel("Referência bíblica \(text)")
    }
}
