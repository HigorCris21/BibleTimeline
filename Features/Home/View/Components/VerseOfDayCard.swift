
//
//  VerseOfDayCard.swift
//  BibleTimeline
//

import SwiftUI

struct VerseOfDayCard: View {
    let title: String
    let icon: String
    let reference: String
    let verse: String

    init(
        title: String = "Verso do dia",
        icon: String = "sun.max.fill",
        reference: String,
        verse: String
    ) {
        self.title = title
        self.icon = icon
        self.reference = reference
        self.verse = verse
    }

    var body: some View {
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
        }
        .appCard()
    }
}
