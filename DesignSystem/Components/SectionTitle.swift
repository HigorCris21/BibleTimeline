
//  SectionTitle.swift
//  BibleTimelineApp
//

import SwiftUI

struct SectionTitle: View {
    private let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text.uppercased())
            .font(.footnote.weight(.semibold))
            .foregroundStyle(Theme.secondaryText)
            .padding(.top, 4)
            .accessibilityAddTraits(.isHeader)
    }
}
