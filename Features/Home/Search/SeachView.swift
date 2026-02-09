//
//  SeachView.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 05/02/26.
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        NavigationStack {
            Text("Busca bíblica (em breve)")
                .foregroundStyle(Theme.secondaryText)
                .navigationTitle("Buscar")
        }
        .appScreenBackground()
    }
}
