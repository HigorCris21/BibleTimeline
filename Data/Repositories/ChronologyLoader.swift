//
//  ChronologyLoader.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 06/02/26.
//



import Foundation

struct ChronologyLoader: ChronologyLoading {

    enum LoaderError: LocalizedError {
        case fileNotFound
        case decodingFailed(String)

        var errorDescription: String? {
            switch self {
            case .fileNotFound:
                return "Arquivo gospel_harmony.json não encontrado no bundle."
            case .decodingFailed(let message):
                return "Falha ao decodificar a harmonia: \(message)"
            }
        }
    }

    func loadChronology() async throws -> [ChronologyItem] {
        guard let url = Bundle.main.url(forResource: "gospel_harmony", withExtension: "json") else {
            throw LoaderError.fileNotFound
        }

        do {
            let data = try Data(contentsOf: url)
            let dtos = try JSONDecoder().decode([ChronologyItemDTO].self, from: data)

            // Ordena pelo campo `order` para garantir a sequência cronológica
            return dtos
                .sorted { $0.order < $1.order }
                .map { $0.toDomain() }

        } catch let error as LoaderError {
            throw error
        } catch {
            throw LoaderError.decodingFailed(error.localizedDescription)
        }
    }
}
