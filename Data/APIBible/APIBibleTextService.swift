//
//  APIBibleTextService.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 10/02/26.
//

import Foundation
import SwiftUI


struct APIBibleTextService: BibleTextService {

    private let config: APIBibleConfig
    private let endpoints: APIBibleEndpointBuilding
    private let http: HTTPClient
    private let decoder: PassageDecoding

    init(
        config: APIBibleConfig = .default,
        endpoints: APIBibleEndpointBuilding = DefaultAPIBibleEndpointBuilder(),
        http: HTTPClient = URLSessionHTTPClient(),
        decoder: PassageDecoding = DefaultPassageDecoder()
    ) {
        self.config = config
        self.endpoints = endpoints
        self.http = http
        self.decoder = decoder
    }

    func fetchText(position: ReadingPosition) async throws -> BibleTextResponse {

        debugPrint("📖 API Bible → fetchText:", position.book, position.chapter, position.verse as Any)

        let request = try endpoints.makePassageRequest(
            position: position,
            config: config
        )

        // ✅ Log seguro (não imprime api-key)
        if let url = request.url?.absoluteString {
            debugPrint("➡️ GET:", url)
        }
        if let headers = request.allHTTPHeaderFields {
            let safeHeaders = headers
                .mapValues { _ in "<redacted>" } // não vaza nada
                .merging(headers.filter { $0.key.lowercased() != "api-key" }) { _, new in new }
            debugPrint("➡️ Headers:", safeHeaders)
        }

        do {
            let (data, httpResponse) = try await http.data(for: request)

            let body = String(data: data, encoding: .utf8)

            debugPrint("⬅️ Status:", httpResponse.statusCode)
            if let body, !body.isEmpty {
                debugPrint("⬅️ Body:", body.prefix(800))
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIBibleError.httpStatus(code: httpResponse.statusCode, body: body)
            }

            let content: String
            do {
                content = try decoder.decodeContent(from: data)
            } catch {
                throw APIBibleError.decodingFailed(error.localizedDescription)
            }

            // opcional: tratar vazio como erro real
            // guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            //     throw APIBibleError.emptyContent
            // }

            return BibleTextResponse(
                reference: position.title,
                text: content.isEmpty ? "[Sem conteúdo]" : content
            )

        } catch {
            if let apiError = error as? APIBibleError {
                throw apiError
            }
            throw APIBibleError.underlying(error)
        }
    }
}
