//
//  APIBibleConfig.swift
//  BibleTimeline
//

import Foundation

// MARK: - APIBibleConfig
struct APIBibleConfig: Sendable {
    let apiKey: String
    let bibleId: String
    let baseURL: URL

    static let `default` = APIBibleConfig(
        apiKey: Bundle.main.infoPlistString("API_BIBLE_KEY"),
        bibleId: Bundle.main.infoPlistString("API_BIBLE_ID"),
        baseURL: URL(string: "https://rest.api.bible")!
    )
}





// MARK: - Bundle keys
private extension Bundle {

    /// Leitura direta do Info.plist sem validações
    func infoPlistString(_ key: String) -> String {
        object(forInfoDictionaryKey: key) as? String ?? ""
    }
}
