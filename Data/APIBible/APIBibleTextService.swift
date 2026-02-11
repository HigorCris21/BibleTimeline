//
//  APIBibleTextService.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 10/02/26.
//

import Foundation

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
        
        let request = try endpoints.makePassageRequest(
            position: position,
            config: config
        )

        let (data, httpResponse) = try await http.data(for: request)

        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIBibleError.httpStatus(httpResponse.statusCode)
        }

        let content = try decoder.decodeContent(from: data)

        return BibleTextResponse(
            reference: position.title,
            text: content.isEmpty ? "[Sem conteúdo]" : content
        )
        
        print("API Bible → fetchText:", position.book, position.chapter, position.verse ?? 0)
    }
}
