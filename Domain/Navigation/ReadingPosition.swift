//
//  ReadingPosition.swift
//  BibleTimeline
//
//  Created by Higor Lo Castro on 06/02/26.
//

import Foundation

struct ReadingPosition: Codable, Hashable, Identifiable {

    var book: String
    var chapter: Int
    var verse: Int?

    var id: String { "\(book)-\(chapter)-\(verse ?? 0)" }

    // Primeiro evento da harmonia — João 1:1 (Prólogo)
    static let start = ReadingPosition(book: "JHN", chapter: 1, verse: nil)

    var title: String {
        let bookName = BookNameResolver.displayName(for: book)
        if let verse { return "\(bookName) \(chapter):\(verse)" }
        return "\(bookName) \(chapter)"
    }
}
