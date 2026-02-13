//
//  ChronologyItemDTO+Mapping.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 10/02/26.
//

import Foundation

// MARK: - ChronologyItemDTO -> Domain
extension ChronologyItemDTO {

    /// `order` é definido pelo Loader (ordem cronológica)
    func toDomain(order: Int) -> ChronologyItem {
        ChronologyItem(
            id: String(id), // 🔴 Int -> String (resolvido)
            title: title,
            order: order,
            references: references.map { $0.toDomain() }
        )
    }
}

// MARK: - ReferenceRangeDTO -> Domain
extension ReferenceRangeDTO {

    func toDomain() -> ReferenceRange {
        ReferenceRange(
            book: book,
            chapterNumber: chapter,
            verseStart: verseStart,
            verseEnd: verseEnd
        )
    }
}

