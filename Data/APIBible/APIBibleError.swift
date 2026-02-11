//
//  APIBibleError.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 10/02/26.
//
import Foundation

enum APIBibleError: LocalizedError, Equatable {

    // Config
    case missingApiKey
    case missingBibleId
    case invalidURL

    // Transport/HTTP
    case invalidResponse
    case httpStatus(code: Int, body: String?)

    // Decode/Content
    case decodingFailed(String)
    case emptyContent

    // Fallback
    case underlying(Error)

    // MARK: - LocalizedError
    var errorDescription: String? {
        switch self {
        case .missingApiKey:
            return "API key não configurada."

        case .missingBibleId:
            return "Bible ID não configurado."

        case .invalidURL:
            return "URL inválida para a requisição."

        case .invalidResponse:
            return "Resposta inválida do servidor."

        case .httpStatus(let code, _):
            return "Falha ao carregar o texto (HTTP \(code))."

        case .decodingFailed:
            return "Falha ao interpretar o conteúdo retornado pela API."

        case .emptyContent:
            return "A API retornou um capítulo sem conteúdo."

        case .underlying(let error):
            return error.localizedDescription
        }
    }

    var failureReason: String? {
        switch self {
        case .httpStatus(_, let body):
            guard let body, !body.isEmpty else { return nil }
            return Self.sanitizeBody(body, limit: 800)

        case .decodingFailed(let message):
            return message

        case .underlying(let error):
            return error.localizedDescription

        default:
            return nil
        }
    }

    // MARK: - Helpers
    private static func sanitizeBody(_ body: String, limit: Int) -> String {
        // remove quebras/indentação excessiva e limita tamanho
        let compact = body
            .replacingOccurrences(of: "\r\n", with: "\n")
            .replacingOccurrences(of: "\r", with: "\n")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        if compact.count <= limit { return compact }
        return String(compact.prefix(limit)) + "…"
    }

    // MARK: - Equatable
    static func == (lhs: APIBibleError, rhs: APIBibleError) -> Bool {
        switch (lhs, rhs) {
        case (.missingApiKey, .missingApiKey): return true
        case (.missingBibleId, .missingBibleId): return true
        case (.invalidURL, .invalidURL): return true
        case (.invalidResponse, .invalidResponse): return true

        // ⚠️ Compara só o status code (não compara body)
        case (.httpStatus(let a, _), .httpStatus(let b, _)): return a == b

        case (.decodingFailed(let a), .decodingFailed(let b)): return a == b
        case (.emptyContent, .emptyContent): return true

        // não compara Error interno
        case (.underlying, .underlying): return true

        default: return false
        }
    }
}
