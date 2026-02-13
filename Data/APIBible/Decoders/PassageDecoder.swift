//
//  PassageDecoder.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 10/02/26.
//

import Foundation

protocol PassageDecoding {
    func decodeContent(from data: Data) throws -> String
}

struct DefaultPassageDecoder: PassageDecoding {
    private let decoder: JSONDecoder

    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }

    func decodeContent(from data: Data) throws -> String {
        let decoded = try decoder.decode(PassageResponse.self, from: data)
        return decoded.data.content.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

private struct PassageResponse: Decodable {
    let data: PassageData

    struct PassageData: Decodable {
        let content: String
    }
}
