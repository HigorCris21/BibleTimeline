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
        guard let value = object(forInfoDictionaryKey: "API_BIBLE_KEY") as? String,
              !value.isEmpty
        else {
            return "" // vazio => você ainda não configurou
        }
        return value
    }

    /// Info.plist key: API_BIBLE_ID
    var apiBibleId: String {
        guard let value = object(forInfoDictionaryKey: "API_BIBLE_ID") as? String,
              !value.isEmpty
        else {
            return "" // vazio => você ainda não configurou
        }
        return value
    }
}
