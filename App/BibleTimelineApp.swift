//
//  BibleTimelineApp.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 05/02/26.
//

import SwiftUI

@main
struct BibleTimelineApp: App {

    // MARK: - Composition Root (SOLID: dependências vivem no topo)
//    private let bibleTextService: BibleTextService = MockBibleTextService()
    
    private let bibleTextService: BibleTextService = APIBibleTextService()

    // Se você tiver a implementação real pronta, troque aqui:
    // private let bibleTextService: BibleTextService = APIBibleTextService()

    var body: some Scene {
        WindowGroup {
            RootTabView(bibleTextService: bibleTextService)
        }
    }
}

