//
//  Theme.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 05/02/26.
//


import SwiftUI

enum Theme {
    static let background = Color("AppBackground")
    static let surface = Color("AppSurface")
    static let primaryText = Color("AppPrimaryText")
    static let secondaryText = Color("AppSecondaryText")
    static let accent = Color("AppAccent")
    static let navBar = Color("AppNavBar")
}

extension View {
    func appScreenBackground() -> some View {
        self
            .background(Theme.background)
            .ignoresSafeArea()
    }

    func appCard() -> some View {
        self
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Theme.surface)
            )
    }
}
