//
//  DefaultAPIBibleEndpointBuilder.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 10/02/26.
//

import Foundation

// MARK: - DefaultAPIBibleEndpointBuilder
/// Responsável por construir URLRequest para os endpoints da API.Bible.
/// SRP: apenas monta URL + query + headers (sem fazer requisição e sem decodificar).
struct DefaultAPIBibleEndpointBuilder: APIBibleEndpointBuilding {

    init() {}

    func makePassageRequest(
        position: ReadingPosition,
        config: APIBibleConfig
    ) throws -> URLRequest {

        // Como o config (ajustado) falha cedo quando está vazio,
        // aqui não é necessário trim/guards.
        // Mantemos somente a montagem do request.
        let passageId = makePassageId(for: position)

        // Monta: /v1/bibles/{bibleId}/passages/{passageId}
        var url = config.baseURL
        url.append(path: "bibles")
        url.append(path: config.bibleId)
        url.append(path: "passages")
        url.append(path: passageId)

        // URLComponents: adiciona query params com segurança.
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw APIBibleError.invalidURL
        }

        // Query params para controlar o texto retornado.
        // Observação: a API.Bible aceita content-type=text para obter texto simples.
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

        // Auth: API key no header esperado pela API.Bible
        request.setValue(config.apiKey, forHTTPHeaderField: "api-key")

        // Aceitamos JSON, mas o corpo vem dentro de um JSON com "content" em texto.
        request.setValue("application/json", forHTTPHeaderField: "accept")

        // GET normalmente não precisa de Content-Type (não há body).
        // Manter "content-type" em GET é desnecessário e pode causar estranheza em alguns proxies.
        // request.setValue("application/json", forHTTPHeaderField: "content-type")

        return request
    }

    // MARK: - Passage ID
    /// Forma padrão que a API.Bible aceita:
    /// - Capítulo: "MRK.1"
    /// - Verso: "MRK.1.1"
    ///
    /// Aqui assumimos que `position.book` já vem no código de livro usado pela API.
    private func makePassageId(for position: ReadingPosition) -> String {
        if let verse = position.verse {
            return "\(position.book).\(position.chapter).\(verse)"
        }
        return "\(position.book).\(position.chapter)"
    }
}

