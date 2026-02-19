//
//  HomeViewModel.swift
//  BibleTimeline
//

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {

    enum State: Equatable {
        case loading
        case loaded([ChronologyItem])
        case error(String)
    }

    @Published private(set) var state: State = .loading
    @Published private(set) var verseOfDay: DailyVerse? = nil

    private let loader: ChronologyLoading
    private let verseService: VerseOfDayService
    private var task: Task<Void, Never>?

    init(
        loader: ChronologyLoading = ChronologyLoader(),
        verseService: VerseOfDayService
    ) {
        self.loader = loader
        self.verseService = verseService
    }

    func load() {
        task?.cancel()
        state = .loading

        task = Task { [weak self] in
            guard let self else { return }
            do {
                let items = try await loader.loadChronology()
                if Task.isCancelled { return }
                self.state = .loaded(items)
            } catch {
                if Task.isCancelled { return }
                self.state = .error("Não foi possível carregar o conteúdo.")
            }

            // Verso falha silenciosamente — não bloqueia a tela
            do {
                let dailyVerse = try await verseService.fetchVerseOfDay()
                if !Task.isCancelled { self.verseOfDay = dailyVerse }
            } catch {
                #if DEBUG
                debugPrint("⚠️ Verso do dia falhou:", error)
                #endif
            }
        }
    }

    deinit { task?.cancel() }
}
