//
//  MockBibleTextService.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 06/02/26.
//

import Foundation

struct MockBibleTextService: BibleTextService {

    enum MockError: Error { case failed }

    func fetchText(position: ReadingPosition) async throws -> BibleTextResponse {
        try await Task.sleep(nanoseconds: 400_000_000)

        return BibleTextResponse(
            reference: position.title,
            text: """
            [Mock] Texto bíblico aqui.

            Depois esta função será substituída por uma chamada real de API.
            A View não muda; só o Service muda.
            """
        )
    }
}
