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
        apiKey: Bundle.main.apiBibleKey,
        bibleId: Bundle.main.apiBibleId,
        baseURL: URL(string: "https://api.scripture.api.bible/v1")!
    )
}

// MARK: - Bundle keys
private extension Bundle {

    /// Info.plist key: API_BIBLE_KEY
    var apiBibleKey: String {
        readInfoPlistString(key: "API_BIBLE_KEY")
    }

    /// Info.plist key: API_BIBLE_ID
    var apiBibleId: String {
        readInfoPlistString(key: "API_BIBLE_ID")
    }

    func readInfoPlistString(key: String) -> String {
        guard let raw = object(forInfoDictionaryKey: key) as? String else {
            return ""
        }

        // ✅ remove espaços/linhas que quebram autenticação (muito comum)
        let value = raw.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !value.isEmpty else { return "" }
        return value
    }
}
