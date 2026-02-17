//
//  SearchViewModel.swift
//  BibleTimeline
//
//  Created by Higor Lo Castro on 10/02/26.
//

import Foundation

@MainActor
final class SearchViewModel: ObservableObject {

    @Published var selectedBook: GospelBook = .mark
    @Published var selectedChapter: Int = 1
    @Published private(set) var harmony: [ChronologyItem] = []

    private let loader: ChronologyLoading

    init(loader: ChronologyLoading = ChronologyLoader()) {
        self.loader = loader
    }

    var availableChapters: [Int] {
        Array(1...selectedBook.chapterCount)
    }

    func onChangeBook(_ newBook: GospelBook) {
        selectedBook = newBook
        selectedChapter = min(selectedChapter, newBook.chapterCount)
        if selectedChapter < 1 { selectedChapter = 1 }
    }

    func loadHarmony() async {
        guard harmony.isEmpty else { return }
        harmony = (try? await loader.loadChronology()) ?? []
    }

    /// Retorna o índice na harmonia que corresponde ao livro e capítulo selecionados.
    /// Se não encontrar uma correspondência exata, retorna o índice 0.
    func indexForSelection() -> Int {
        let book = selectedBook.rawValue
        let chapter = selectedChapter

        return harmony.firstIndex { item in
            item.startPosition?.book == book &&
            item.startPosition?.chapter == chapter
        } ?? 0
    }
}
