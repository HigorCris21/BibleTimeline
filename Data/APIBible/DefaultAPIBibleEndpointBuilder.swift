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

        guard !config.apiKey.isEmpty else { throw APIBibleError.missingApiKey }
        guard !config.bibleId.isEmpty else { throw APIBibleError.missingBibleId }

        let passageId = makePassageId(for: position)

        var url = config.baseURL
        url.append(path: "bibles")
        url.append(path: config.bibleId)
        url.append(path: "passages")
        url.append(path: passageId)

        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            .init(name: "content-type", value: "text"),
            .init(name: "include-verse-numbers", value: "true"),
            .init(name: "include-titles", value: "false"),
            .init(name: "include-notes", value: "false")
        ]

        guard let finalURL = components?.url else {
            throw APIBibleError.invalidURL
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        request.setValue(config.apiKey, forHTTPHeaderField: "api-key")
        return request
    }

    private func makePassageId(for position: ReadingPosition) -> String {
        if let verse = position.verse {
            return "\(position.book).\(position.chapter).\(verse)"
        }
        return "\(position.book).\(position.chapter)"
    }
}
