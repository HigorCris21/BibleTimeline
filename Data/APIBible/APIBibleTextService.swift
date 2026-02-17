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

        #if DEBUG
        debugPrint("📖 API Bible →", position.book, position.chapter)
        #endif

        let request = try endpoints.makePassageRequest(
            position: position,
            config: config
        )

        do {
            let (data, response) = try await http.data(for: request)

            guard (200...299).contains(response.statusCode) else {
                let body = String(data: data.prefix(800), encoding: .utf8)
                throw APIBibleError.httpStatus(code: response.statusCode, body: body)
            }

            let content = try decoder.decodeContent(from: data)

            return BibleTextResponse(
                reference: position.title,
                text: content
            )

        } catch let error as APIBibleError {
            throw error
        } catch {
            throw APIBibleError.underlying(error)
        }
    }
}
