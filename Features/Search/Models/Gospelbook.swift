//
//  Gospelbook.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 10/02/26.
//

import Foundation


// MARK: - GospelBook
/// Usado pelo Search para selecionar livro/capítulo.
enum GospelBook: String, CaseIterable, Identifiable {
    case matthew = "MAT"
    case mark = "MRK"
    case luke = "LUK"
    case john = "JHN"

    var id: String { rawValue }

    // MARK: UI
    var displayName: String {
        BookNameResolver.displayName(for: rawValue)
    }

    // MARK: MVP
    var chapterCount: Int {
        switch self {
        case .matthew: return 28
        case .mark: return 16
        case .luke: return 24
        case .john: return 21
        }
    }
}
