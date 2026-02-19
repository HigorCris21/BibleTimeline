//
//  ChronologyLoaderTests.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 19/02/26.
//

import XCTest
@testable import BibleTimeline

final class ChronologyLoaderTests: XCTestCase {

    // Testa se o JSON do bundle carrega corretamente e retorna 169 eventos
    // Se esse número mudar, o teste vai falhar e te avisar
    func test_load_retorna169Eventos() async throws {
        let loader = ChronologyLoader()
        let items = try await loader.loadChronology()
        XCTAssertEqual(items.count, 169)
    }

    // Testa se o primeiro evento tem um ID válido (não vazio)
    // Garante que o mapeamento do JSON para o modelo está funcionando
    func test_load_primeiroeventoTemId() async throws {
        let loader = ChronologyLoader()
        let items = try await loader.loadChronology()
        XCTAssertFalse(items.first?.id.isEmpty ?? true)
    }
}


