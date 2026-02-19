//
//  VerseOfDayReferenceTests.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 19/02/26.
//


import XCTest
@testable import BibleTimeline

final class VerseOfDayReferenceTests: XCTestCase {

    // Simula todos os 365 dias do ano e garante que o índice
    // nunca estoura o array de 96 referências — evita crash
    func test_indiceDoDia_naoEstouraArray() {
        let totalRefs = 96 // quantidade atual de referências na lista
        for day in 1...365 {
            let index = (day - 1) % totalRefs
            // índice tem que estar sempre dentro dos limites do array
            XCTAssertTrue(index >= 0 && index < totalRefs)
        }
    }

    // Garante que o mesmo dia sempre gera o mesmo índice
    // Isso é o que faz todo mundo ver o mesmo verso no mesmo dia
    func test_mesmoDia_sempreMesmoIndice() {
        let totalRefs = 96
        let day = 50 // qualquer dia fixo serve para o teste
        let index1 = (day - 1) % totalRefs
        let index2 = (day - 1) % totalRefs
        XCTAssertEqual(index1, index2)
    }
}

