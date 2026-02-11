//
//  RootTabView.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 05/02/26.
//

import SwiftUI

struct RootTabView: View {

    // MARK: Dependencies
    let bibleTextService: BibleTextService

    // MARK: Init
    init(bibleTextService: BibleTextService) {
        self.bibleTextService = bibleTextService
    }

    var body: some View {
        TabView {
            HomeView(bibleTextService: bibleTextService)
                .tabItem { Label("Home", systemImage: "house.fill") }

            ExploreView(bibleTextService: bibleTextService)
                .tabItem { Label("Explorar", systemImage: "safari.fill") }

            SearchView(bibleTextService: bibleTextService)
                .tabItem { Label("Buscar", systemImage: "magnifyingglass") }
        }
        .tint(Theme.accent)
        .toolbarBackground(Theme.navBar, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}
