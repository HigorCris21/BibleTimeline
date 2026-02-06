//
//  BibleTextService.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 06/02/26.
//

import Foundation

struct BibleTextResponse: Equatable {
    let reference: String
    let text: String
}

protocol BibleTextService {
    func fetchText(position: ReadingPosition) async throws -> BibleTextResponse
}
