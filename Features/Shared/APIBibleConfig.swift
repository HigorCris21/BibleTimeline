//
//  APIBibleConfig.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 10/02/26.
//

import Foundation

// MARK: - APIBibleConfig
struct APIBibleConfig: Sendable {
    let apiKey: String
    let bibleId: String
    let baseURL: URL

    static let `default` = APIBibleConfig(
        apiKey: Bundle.main.requiredInfoPlistString("API_BIBLE_KEY"),
        bibleId: Bundle.main.requiredInfoPlistString("API_BIBLE_ID"),
        baseURL: URL(string: "https://rest.api.bible")!
    )
}

// MARK: - Bundle keys
private extension Bundle {

    /// Lê uma String do Info.plist e falha cedo com mensagem clara se estiver ausente/vazia.
    func requiredInfoPlistString(_ key: String) -> String {
        guard let raw = object(forInfoDictionaryKey: key) as? String else {
            fatalError("Missing Info.plist key: \(key)")
        }

        let value = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !value.isEmpty else {
            fatalError("Info.plist key is empty: \(key)")
        }

        return value
    }
}
