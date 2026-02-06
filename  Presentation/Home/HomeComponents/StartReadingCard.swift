//
//  StartReadingCard.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 06/02/26.
//



import SwiftUI

struct StartReadingCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let buttonTitle: String
    let onTap: () -> Void
    
    init(
        title: String = "Início da narrativa",
        subtitle: String = "Comece a leitura cronológica",
        icon: String = "book.fill",
        buttonTitle: String = "Começar agora",
        onTap: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.buttonTitle = buttonTitle
        self.onTap = onTap
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(Theme.primaryText)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(Theme.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
                
                Image(systemName: icon)
                    .foregroundStyle(Theme.accent)
            }
            
            Divider()
                .opacity(0.25)
            
            Button(action: onTap) {
                HStack {
                    Text(buttonTitle)
                        .font(.headline)
                    Spacer()
                    Image(systemName: "arrow.right")
                        .font(.footnote.weight(.semibold))
                }
                .foregroundStyle(Theme.primaryText)
                .padding(.vertical, 12)
                .padding(.horizontal, 14)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Theme.accent.opacity(0.10))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Theme.accent.opacity(0.18), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
        }
        .appCard()
    }
}
