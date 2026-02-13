//
//  Untitled.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 12/02/26.
//


import Foundation

// MARK: - APIBibleHealthChecking
protocol APIBibleHealthChecking: Sendable {
    func testChaptersEndpoint(bookUSFM: String) async -> Result<String, Error>
}

// MARK: - APIBibleHealthCheck
struct APIBibleHealthCheck: APIBibleHealthChecking {

    private let config: APIBibleConfig

    init(config: APIBibleConfig = .default) {
        self.config = config
    }

    func testChaptersEndpoint(bookUSFM: String = "MAT") async -> Result<String, Error> {
        let url = config.baseURL
            .appendingPathComponent("v1")
            .appendingPathComponent("bibles")
            .appendingPathComponent(config.bibleId)
            .appendingPathComponent("books")
            .appendingPathComponent(bookUSFM)
            .appendingPathComponent("chapters")

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(config.apiKey, forHTTPHeaderField: "api-key")
        request.setValue("application/json", forHTTPHeaderField: "accept")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            let status = (response as? HTTPURLResponse)?.statusCode ?? -1
            let body = String(data: data, encoding: .utf8) ?? "<no utf8 body>"

            // Retorna texto já pronto pra você ver no console.
            let debug = """
            ✅ API.Bible test
            URL: \(url.absoluteString)
            Status: \(status)
            Body (first 1200 chars):
            \(String(body.prefix(1200)))
            """

            return .success(debug)
        } catch {
            return .failure(error)
        }
    }
}
