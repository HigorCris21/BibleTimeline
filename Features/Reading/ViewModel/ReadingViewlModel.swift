//
//  ReadingViewModel.swift
//  BibleTimeline
//
//  Created by Higor Lo Castro on 06/02/26.
//

import Foundation

@MainActor
final class ReadingViewModel: ObservableObject {

    // MARK: - State
    enum State: Equatable {
        case loading
        case loaded(reference: String, text: String)
        case error(message: String)
    }

    // MARK: - Published
    @Published private(set) var state: State = .loading
    @Published private(set) var currentIndex: Int
    @Published private(set) var currentEvent: ChronologyItem

    // Exposto para a View salvar no AppStorage
    var position: ReadingPosition {
        currentEvent.startPosition ?? ReadingPosition.start
    }

    // MARK: - Navigation helpers
    var hasNext: Bool     { currentIndex < harmony.count - 1 }
    var hasPrevious: Bool { currentIndex > 0 }

    var eventTitle: String { currentEvent.title }
    var eventProgress: String { "\(currentIndex + 1) de \(harmony.count)" }

    // MARK: - Dependencies
    private let harmony: [ChronologyItem]
    private let bibleTextService: BibleTextService
    private var loadTask: Task<Void, Never>?

    // MARK: - Init
    init(
        startIndex: Int,
        harmony: [ChronologyItem],
        bibleTextService: BibleTextService
    ) {
        let safeIndex = max(0, min(startIndex, harmony.count - 1))
        self.currentIndex = safeIndex
        self.currentEvent = harmony[safeIndex]
        self.harmony = harmony
        self.bibleTextService = bibleTextService
    }

    deinit {
        loadTask?.cancel()
    }

    // MARK: - Load
    func load() {
        loadTask?.cancel()
        state = .loading

        let event = currentEvent

        loadTask = Task { [weak self] in
            guard let self else { return }

            do {
                // Busca o texto da primeira referência do evento
                guard let position = event.startPosition else {
                    self.state = .error(message: "Evento sem referência bíblica.")
                    return
                }

                let response = try await bibleTextService.fetchText(position: position)

                if Task.isCancelled { return }
                guard self.currentEvent.id == event.id else { return }

                self.state = .loaded(
                    reference: response.reference,
                    text: response.text
                )

            } catch {
                if Task.isCancelled { return }
                self.state = .error(message: error.localizedDescription)
            }
        }
    }

    // MARK: - Navigation
    func next() {
        guard hasNext else { return }
        currentIndex += 1
        currentEvent = harmony[currentIndex]
        load()
    }

    func previous() {
        guard hasPrevious else { return }
        currentIndex -= 1
        currentEvent = harmony[currentIndex]
        load()
    }
}
