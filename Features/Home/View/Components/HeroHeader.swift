//
//  HeroHeader.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 06/02/26.
//




import SwiftUI

struct HeroHeader: View {
    let title: String
    let subtitle: String
    let ctaTitle: String
    let ctaIcon: String
    let onTapCTA: () -> Void

    init(
        title: String,
        subtitle: String,
        ctaTitle: String,
        ctaIcon: String = "play.circle.fill",
        onTapCTA: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.ctaTitle = ctaTitle
        self.ctaIcon = ctaIcon
        self.onTapCTA = onTapCTA
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.title.weight(.semibold))
                    .foregroundStyle(Theme.primaryText)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(Theme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }

            PrimaryCTAButton(
                title: ctaTitle,
                icon: ctaIcon,
                onTap: onTapCTA
            )
        }
        .appCard()
    }
}



