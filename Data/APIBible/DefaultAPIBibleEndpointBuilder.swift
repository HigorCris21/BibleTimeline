//
//  DefaultAPIBibleEndpointBuilder.swift
//  BibleTimeline
//

import Foundation

struct DefaultAPIBibleEndpointBuilder: APIBibleEndpointBuilding {

    init() {}

    func makePassageRequest(
        position: ReadingPosition,
        config: APIBibleConfig
    ) throws -> URLRequest {
        let rawPassageId = makePassageId(for: position)
        return try buildRequest(passageId: rawPassageId, config: config)
    }

    func makePassageRequestById(
        passageId: String,
        config: APIBibleConfig
    ) throws -> URLRequest {
        return try buildRequest(passageId: passageId, config: config)
    }

    // MARK: - Privados

    private func buildRequest(passageId: String, config: APIBibleConfig) throws -> URLRequest {
        guard let encodedId = passageId.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw APIBibleError.invalidURL
        }

        var url = config.baseURL
        url.append(path: "v1/bibles")
        url.append(path: config.bibleId)
        url.append(path: "passages")
        url.append(path: encodedId)

        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw APIBibleError.invalidURL
        }

        components.queryItems = [
            .init(name: "content-type", value: "text"),
            .init(name: "include-verse-numbers", value: "true"),
            .init(name: "include-chapter-numbers", value: "false"),
            .init(name: "include-titles", value: "false"),
            .init(name: "include-notes", value: "false")
        ]

        guard let finalURL = components.url else {
            throw APIBibleError.invalidURL
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        request.setValue(config.apiKey, forHTTPHeaderField: "api-key")
        request.setValue("application/json", forHTTPHeaderField: "accept")

        return request
    }

    private func makePassageId(for position: ReadingPosition) -> String {
        if let verse = position.verse {
            return "\(position.book).\(position.chapter).\(verse)"
        }
        return "\(position.book).\(position.chapter)"
    }
}
