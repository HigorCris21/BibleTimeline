//
//  BookNameResolver.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 10/02/26.
//

import Foundation

// MARK: - BookNameResolver
/// Converte IDs USFM da API.Bible em nomes para exibição.
enum BookNameResolver {

    static func displayName(for usfm: String) -> String {
        switch usfm.uppercased() {
        case "MAT": return "Mateus"
        case "MRK": return "Marcos"
        case "LUK": return "Lucas"
        case "JHN": return "João"
        default: return usfm
        }
    }
}
