//
//  ReferenceRange.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 06/02/26.
//

import Foundation


/// IDs seguem o padrão API.Bible: chapterId "MAT.1" e verseId "MAT.1.1".
struct ReferenceRange: Hashable, Codable {

    let book: String              // USFM: "MAT", "MRK", "LUK", "JHN"
    let chapterNumber: Int        // 1, 2, 3...
    let verseStart: Int?
    let verseEnd: Int?

    init(
        book: String,
        chapterNumber: Int,
        verseStart: Int? = nil,
        verseEnd: Int? = nil
    ) {
        self.book = book
        self.chapterNumber = chapterNumber
        self.verseStart = verseStart
        self.verseEnd = verseEnd
    }
}

// MARK: - API.Bible Helpers
extension ReferenceRange {

    /// API.Bible chapter id (ex: "MAT.1")
    var chapterId: String {
        "\(book).\(chapterNumber)"
    }

    /// API.Bible verse id do início (se tiver verso) (ex: "MAT.1.1")
    var startVerseId: String? {
        guard let verseStart else { return nil }
        return "\(chapterId).\(verseStart)"
    }

    /// API.Bible verse id do fim (se tiver verso)
    var endVerseId: String? {
        guard let verseEnd else { return nil }
        return "\(chapterId).\(verseEnd)"
    }
}
