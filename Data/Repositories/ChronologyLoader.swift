//
//  ChronologyLoader.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 06/02/26.
//

import Foundation

struct ChronologyLoader: ChronologyLoading {

    enum LoaderError: Error { case empty }

    func loadChronology() async throws -> [ChronologyItem] {

        // Mock: a ordem cronológica aqui é a ordem do array.
        // Depois você substitui por JSON (Harmony of the Gospels) sem mexer no Domain.
        let dtos: [ChronologyItemDTO] = [
            ChronologyItemDTO(
                id: 1,
                title: "Início do Evangelho",
                references: [
                    ReferenceRangeDTO(
                        book: "MRK",
                        chapter: 1,
                        verseStart: nil,
                        verseEnd: nil
                    )
                ]
            ),
            ChronologyItemDTO(
                id: 2,
                title: "Chamado dos discípulos",
                references: [
                    ReferenceRangeDTO(
                        book: "MRK",
                        chapter: 1,
                        verseStart: 16,
                        verseEnd: 20
                    )
                ]
            ),
            ChronologyItemDTO(
                id: 3,
                title: "Autoridade de Jesus",
                references: [
                    ReferenceRangeDTO(
                        book: "MRK",
                        chapter: 1,
                        verseStart: 21,
                        verseEnd: 28
                    )
                ]
            )
        ]

        guard !dtos.isEmpty else { throw LoaderError.empty }

    
        return dtos.enumerated().map { index, dto in
            dto.toDomain(order: index + 1) // começa em 1
        }
    }
}

