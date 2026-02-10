//
//  ReadingPosition.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 06/02/26.
//

import Foundation

// MARK: - ReadingPosition
/// Ponto exato de leitura.
struct ReadingPosition: Codable, Hashable, Identifiable {

    // MARK: Domain IDs
    var book: String      // USFM: MAT/MRK/LUK/JHN (por enquanto)
    var chapter: Int
    var verse: Int?

    // MARK: Identifiable
    var id: String { "\(book)-\(chapter)-\(verse ?? 0)" }

    // MARK: Defaults
    static let mark1 = ReadingPosition(book: "MRK", chapter: 1, verse: nil)

    // MARK: UI
    var title: String {
        let bookName = BookNameResolver.displayName(for: book)
        if let verse { return "\(bookName) \(chapter):\(verse)" }
        return "\(bookName) \(chapter)"
    }
}

