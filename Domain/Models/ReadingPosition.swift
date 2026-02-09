//
//  ReadingPosition.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 06/02/26.
//

import Foundation

struct ReadingPosition: Codable, Hashable, Identifiable {
    var book: String
    var chapter: Int
    var verse: Int?

    var id: String { "\(book)-\(chapter)-\(verse ?? 0)" }

    static let mark1 = ReadingPosition(book: "Marcos", chapter: 1, verse: nil)

    var title: String {
        if let verse { return "\(book) \(chapter):\(verse)" }
        return "\(book) \(chapter)"
    }
}

