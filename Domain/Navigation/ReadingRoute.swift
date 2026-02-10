//
//  ReadingRoute.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 10/02/26.
//
import Foundation

// MARK: - ReadingRoute
/// Centraliza a criação de rotas de leitura.
enum ReadingRoute {

    // MARK: - From Chronology
    /// Cria uma posição de leitura a partir de um item da cronologia.
    static func fromChronologyItem(_ item: ChronologyItem) -> ReadingPosition? {
        item.startPosition
    }

    // MARK: - From Search
    /// Cria uma posição de leitura a partir de um resultado de busca.
    static func fromSearchResult(
        book: String,
        chapter: Int,
        verse: Int? = nil
    ) -> ReadingPosition {
        ReadingPosition(
            book: book,
            chapter: chapter,
            verse: verse
        )
    }

    // MARK: - Default Entry Point
    /// Ponto de entrada padrão para iniciar uma nova leitura.
    static func startDefault() -> ReadingPosition {
        ReadingPosition(
            book: "Mark",
            chapter: 1
        )
    }
}
