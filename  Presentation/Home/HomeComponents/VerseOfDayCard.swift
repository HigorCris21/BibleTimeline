//
//  VerseOfDayCard.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 06/02/26.
//

//
// MARK: - Verse of the Day

import SwiftUI

struct VerseOfDayCard: View {
    let title: String
    let icon: String
    let reference: String
    let verse: String
    let hint: String
    let onTap: () -> Void

    init(
        title: String = "Verso do dia",
        icon: String = "sun.max.fill",
        reference: String,
        verse: String,
        hint: String = "Toque para abrir no contexto",
        onTap: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.reference = reference
        self.verse = verse
        self.hint = hint
        self.onTap = onTap
    }

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: icon)
                        .foregroundStyle(Theme.accent)

                    Text(title)
                        .font(.headline)
                        .foregroundStyle(Theme.primaryText)

                    Spacer()

                    ReferenceChip(reference)
                }

                Text(verse)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Theme.primaryText)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 2)

                Text(hint)
                    .font(.footnote)
                    .foregroundStyle(Theme.secondaryText)
            }
        }
        .buttonStyle(.plain)
        .appCard()
    }
}
