//
//  RootTabView.swift
//  BibleTimeline
//

import SwiftUI

struct RootTabView: View {

    let bibleTextService: BibleTextService

    @State private var showSplash = true

    init(bibleTextService: BibleTextService) {
        self.bibleTextService = bibleTextService
    }

    var body: some View {
        ZStack {
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

            if showSplash {
                SplashView {
                    showSplash = false
                }
                .transition(.opacity)
                .zIndex(1)
            }
        }
    }
}
