//
//  DefaultAPIBibleEndpointBuilder.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 10/02/26.
//

import Foundation

struct DefaultAPIBibleEndpointBuilder: APIBibleEndpointBuilding {

    init() {}

    func makePassageRequest(
        position: ReadingPosition,
        config: APIBibleConfig
    ) throws -> URLRequest {

        let apiKey = config.apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        let bibleId = config.bibleId.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !apiKey.isEmpty else { throw APIBibleError.missingApiKey }
        guard !bibleId.isEmpty else { throw APIBibleError.missingBibleId }

        let passageId = makePassageId(for: position)

        var url = config.baseURL
        url.append(path: "bibles")
        url.append(path: bibleId)
        url.append(path: "passages")
        url.append(path: passageId)

        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw APIBibleError.invalidURL
        }

        components.queryItems = [
            .init(name: "content-type", value: "text"),
            .init(name: "include-verse-numbers", value: "true"),
            .init(name: "include-titles", value: "false"),
            .init(name: "include-notes", value: "false")
        ]

        guard let finalURL = components.url else {
            throw APIBibleError.invalidURL
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"

        // ✅ Auth (API.Bible)
        request.setValue(apiKey, forHTTPHeaderField: "api-key")

        // ✅ Headers úteis (diagnóstico + consistência)
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("application/json", forHTTPHeaderField: "content-type")

        return request
    }

    private func makePassageId(for position: ReadingPosition) -> String {
        // API.Bible geralmente usa "MRK.1" ou "MRK.1.1"
        if let verse = position.verse {
            return "\(position.book).\(position.chapter).\(verse)"
        }
        return "\(position.book).\(position.chapter)"
    }
}
