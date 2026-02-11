//
//  ChronologyItemDTO+Mapping.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 10/02/26.
//

import Foundation

extension ChronologyItemDTO {
    func toDomain() -> ChronologyItem {
        ChronologyItem(
            id: UUID(), // simples e suficiente para Identifiable no app
            title: title,
            references: references.map { $0.toDomain() }
        )
    }
}

extension ReferenceRangeDTO {
    func toDomain() -> ReferenceRange {
        ReferenceRange(
            book: book,
            chapter: chapter,
            verseStart: verseStart,
            verseEnd: verseEnd
        )
    }
}
