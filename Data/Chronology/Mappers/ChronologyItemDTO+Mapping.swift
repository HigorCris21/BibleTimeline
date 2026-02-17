//
//  ChronologyItemDTO+Mapping.swift
//  BibleTimeline
//
//  Created by Higor Lo Castro on 10/02/26.
//

import Foundation

// MARK: - ChronologyItemDTO -> Domain
extension ChronologyItemDTO {

    func toDomain() -> ChronologyItem {
        ChronologyItem(
            id: id,
            section: section,
            order: order,
            title: title,
            references: references.map { $0.toDomain() }
        )
    }
}

// MARK: - ReferenceRangeDTO -> Domain
extension ReferenceRangeDTO {

    func toDomain() -> ReferenceRange {
        ReferenceRange(
            book: book,
            chapterNumber: chapterStart,
            verseStart: verseStart,
            verseEnd: verseEnd
        )
    }
}
