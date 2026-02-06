//
//  RootTabView.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 05/02/26.
//


import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }

            ExploreView()
                .tabItem { Label("Explorar", systemImage: "safari.fill") }

            SearchView()
                .tabItem { Label("Buscar", systemImage: "magnifyingglass") }
        }
        .tint(Theme.accent)
        .toolbarBackground(Theme.navBar, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}
