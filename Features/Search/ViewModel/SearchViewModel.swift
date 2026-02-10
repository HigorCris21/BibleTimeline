//
//  SearchViewModel.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 10/02/26.
//


import Foundation

// MARK: - SearchViewModel
@MainActor
final class SearchViewModel: ObservableObject {

    // MARK: UI State
    @Published var selectedBook: GospelBook = .mark
    @Published var selectedChapter: Int = 1

    // MARK: Derived
    var availableChapters: [Int] {
        Array(1...selectedBook.chapterCount)
    }

    // MARK: Actions
    func onChangeBook(_ newBook: GospelBook) {
        selectedBook = newBook

        // Mantém capítulo válido ao trocar de livro
        if selectedChapter > newBook.chapterCount {
            selectedChapter = newBook.chapterCount
        }
        if selectedChapter < 1 {
            selectedChapter = 1
        }
    }
}
