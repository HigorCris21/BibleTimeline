//
//  DefaultAPIBibleEndpointBuilder.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 10/02/26.
//

import Foundation

// MARK: - DefaultAPIBibleEndpointBuilder
/// Responsável por construir URLRequest para os endpoints da API.Bible.
struct DefaultAPIBibleEndpointBuilder: APIBibleEndpointBuilding {

    init() {}

    func makePassageRequest(
        position: ReadingPosition,
        config: APIBibleConfig
    ) throws -> URLRequest {

        //Cria o passageId e faz percent-encoding para evitar problemas com "." no path
        let rawPassageId = makePassageId(for: position)
        guard let passageId = rawPassageId.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw APIBibleError.invalidURL
        }

//Monta URL /v1/bibles/{bibleId}/passages/{passageId}
        var url = config.baseURL
        url.append(path: "v1/bibles")
        url.append(path: config.bibleId)
        url.append(path: "passages")
        url.append(path: passageId)

        // Usa URLComponents para query parameters
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

        // Monta o request
        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"

        // Header de autenticação
        request.setValue(config.apiKey, forHTTPHeaderField: "api-key")

        //  Header Accept
        request.setValue("application/json", forHTTPHeaderField: "accept")

        return request
    }

    // MARK: - Passage ID
    /// API.Bible espera:
    /// - Capítulo: "MRK.1"
    /// - Verso: "MRK.1.1"
    private func makePassageId(for position: ReadingPosition) -> String {
        if let verse = position.verse {
            return "\(position.book).\(position.chapter).\(verse)"
        }
        return "\(position.book).\(position.chapter)"
    }
}

