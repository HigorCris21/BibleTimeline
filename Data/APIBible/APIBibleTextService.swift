//
//  APIBibleTextService.swift
//  BibleTimeline
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

        let request = try endpoints.makePassageRequest(position: position, config: config)
        let content = try await perform(request: request)

        return BibleTextResponse(reference: position.title, text: content)
    }

    func fetchPassage(passageId: String) async throws -> String {
        #if DEBUG
        debugPrint("📖 API Bible → passageId:", passageId)
        #endif

        let request = try endpoints.makePassageRequestById(passageId: passageId, config: config)
        return try await perform(request: request)
    }

    // MARK: - Privado

    private func perform(request: URLRequest) async throws -> String {
        do {
            let (data, response) = try await http.data(for: request)

            guard (200...299).contains(response.statusCode) else {
                let body = String(data: data.prefix(800), encoding: .utf8)
                throw APIBibleError.httpStatus(code: response.statusCode, body: body)
            }

            return try decoder.decodeContent(from: data)

        } catch let error as APIBibleError {
            throw error
        } catch {
            throw APIBibleError.underlying(error)
        }
    }
}
