
//
//  VerseOfDayService.swift
//  BibleTimeline
//

import Foundation

struct DailyVerse: Codable {
    let reference: String
    let text: String
    let date: String // "yyyy-MM-dd"
}

@MainActor
final class VerseOfDayService {

    private let bibleTextService: BibleTextService
    private let storageKey = "verse_of_day_v1"

    private static let references: [String] = {
        guard let url = Bundle.main.url(forResource: "verse_references", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let refs = try? JSONDecoder().decode([String].self, from: data)
        else { return ["JHN.3.16"] } // fallback
        return refs
    }()

    init(bibleTextService: BibleTextService) {
        self.bibleTextService = bibleTextService
    }

    func fetchVerseOfDay() async throws -> DailyVerse {
        let today = todayString()

        if let cached = loadCached(), cached.date == today {
            return cached
        }

        let reference = referenceForToday()
        let rawText = try await bibleTextService.fetchPassage(passageId: reference)

        let verse = DailyVerse(
            reference: formatReference(reference),
            text: rawText.strippingVerseNumbers(),
            date: today
        )

        saveCached(verse)
        return verse
    }

    // MARK: - Privados

    private func referenceForToday() -> String {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = (dayOfYear - 1) % Self.references.count
        return Self.references[index]
    }

    private func todayString() -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        return fmt.string(from: Date())
    }

    private func loadCached() -> DailyVerse? {
        guard let raw = UserDefaults.standard.string(forKey: storageKey),
              let data = raw.data(using: .utf8),
              let verse = try? JSONDecoder().decode(DailyVerse.self, from: data)
        else { return nil }
        return verse
    }

    private func saveCached(_ verse: DailyVerse) {
        guard let data = try? JSONEncoder().encode(verse),
              let raw = String(data: data, encoding: .utf8)
        else { return }
        UserDefaults.standard.set(raw, forKey: storageKey)
    }

    private func formatReference(_ passageId: String) -> String {
        let bookNames: [String: String] = [
            "JHN": "João", "MRK": "Marcos", "MAT": "Mateus", "LUK": "Lucas"
        ]
        let parts = passageId.split(separator: ".")
        guard parts.count >= 3,
              let bookName = bookNames[String(parts[0])]
        else { return passageId }
        return "\(bookName) \(parts[1]):\(parts[2])"
    }
}
