//
//  ChronologyLoader.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 06/02/26.
//
import Foundation

struct ChronologyLoader: ChronologyLoading {

    enum LoaderError: Error { case empty }

    func loadGospelsChronology() throws -> [ChronologyItem] {
        let items: [ChronologyItem] = [
            .init(
                id: 1,
                title: "Início do Evangelho",
                references: [
                    .init(book: "MRK", chapter: 1, verseStart: nil, verseEnd: nil)
                ]
            ),
            .init(
                id: 2,
                title: "Chamado dos discípulos",
                references: [
                    .init(book: "MRK", chapter: 1, verseStart: 16, verseEnd: 20)
                ]
            ),
            .init(
                id: 3,
                title: "Autoridade de Jesus",
                references: [
                    .init(book: "MRK", chapter: 1, verseStart: 21, verseEnd: 28)
                ]
            )
        ]

        guard !items.isEmpty else { throw LoaderError.empty }
        return items
    }
}
