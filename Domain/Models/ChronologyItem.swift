//
//  ChronologyItem.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 06/02/26.
//
import Foundation

struct ChronologyItem: Identifiable, Hashable {
    let id: UUID
    let title: String
    let references: [ReferenceRange]
}

extension ChronologyItem {

    var startPosition: ReadingPosition? {
        guard let first = references.first else { return nil }
        return ReadingPosition(
            book: first.book,
            chapter: first.chapter,
            verse: first.verseStart
        )
    }

    var displayReference: String {
        guard let first = references.first else { return "" }
        if let v1 = first.verseStart, let v2 = first.verseEnd { return "\(first.book) \(first.chapter):\(v1)–\(v2)" }
        if let v1 = first.verseStart { return "\(first.book) \(first.chapter):\(v1)" }
        return "\(first.book) \(first.chapter)"
    }
}
