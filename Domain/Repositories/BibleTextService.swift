//
//  BibleTextService.swift
//  BibleTimeline
//

import Foundation

struct BibleTextResponse: Equatable {
    let reference: String
    let text: String
}

protocol BibleTextService {
    func fetchText(position: ReadingPosition) async throws -> BibleTextResponse
    func fetchPassage(passageId: String) async throws -> String
}
