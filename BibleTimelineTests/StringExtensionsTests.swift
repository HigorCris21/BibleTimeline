//
//  StringExtensionsTests.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 19/02/26.
//

import XCTest
@testable import BibleTimeline // permite acessar código interno do app

final class StringExtensionsTests: XCTestCase {

    // Testa o caso principal: remove os números [1], [2] do texto
    func test_strippingVerseNumbers_removesNumbers() {
        let input = "[1] No princípio era o Verbo, [2] e o Verbo estava com Deus."
        let result = input.strippingVerseNumbers()
        // Verifica se o resultado é igual ao esperado (sem números)
        XCTAssertEqual(result, "No princípio era o Verbo, e o Verbo estava com Deus.")
    }

    // Testa com string vazia — não pode crashar nem retornar lixo
    func test_strippingVerseNumbers_emptyString() {
        XCTAssertEqual("".strippingVerseNumbers(), "")
    }

    // Testa texto sem números — deve retornar o mesmo texto sem alterar nada
    func test_strippingVerseNumbers_semNumeros_naoAltera() {
        let input = "No princípio era o Verbo."
        XCTAssertEqual(input.strippingVerseNumbers(), input)
    }
}



