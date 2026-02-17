//
//  ChronologyItem.swift
//  BibleTimeline
//
//  Created by Higor Lo Castro on 06/02/26.
//

import Foundation

struct ChronologyItem: Identifiable, Hashable, Codable {
    let id: String
    let section: String
    let order: Int
    let title: String
    let references: [ReferenceRange]
}

extension ChronologyItem {

    var startPosition: ReadingPosition? {
        guard let first = references.first else { return nil }
        return ReadingPosition(
            book: first.book,
            chapter: first.chapterNumber,
            verse: first.verseStart
        )
    }

    var displayReference: String {
        guard let first = references.first else { return "" }

        if let v1 = first.verseStart, let v2 = first.verseEnd {
            return "\(BookNameResolver.displayName(for: first.book)) \(first.chapterNumber):\(v1)–\(v2)"
        }
        if let v1 = first.verseStart {
            return "\(BookNameResolver.displayName(for: first.book)) \(first.chapterNumber):\(v1)"
        }
        return "\(BookNameResolver.displayName(for: first.book)) \(first.chapterNumber)"
    }
}
