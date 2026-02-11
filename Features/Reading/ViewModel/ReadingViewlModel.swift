//
//  ReadingViewlModel.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 06/02/26.
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
    @Published private(set) var position: ReadingPosition

    // MARK: - Dependencies
    private let bibleTextService: BibleTextService

    // MARK: - Task control
    private var loadTask: Task<Void, Never>?

    // MARK: - Init (SOLID: service obrigatório)
    init(position: ReadingPosition, bibleTextService: BibleTextService) {
        self.position = position
        self.bibleTextService = bibleTextService
    }

    deinit {
        loadTask?.cancel()
    }

    // MARK: - Load
    func load() {
        loadTask?.cancel()
        state = .loading

        let positionSnapshot = position

        loadTask = Task { [weak self] in
            guard let self else { return }

            do {
                let response = try await bibleTextService.fetchText(
                    position: positionSnapshot
                )

                if Task.isCancelled { return }

                // Se o usuário já mudou de capítulo enquanto carregava, ignora retorno antigo
                guard self.position == positionSnapshot else { return }

                self.state = .loaded(
                    reference: response.reference,
                    text: response.text
                )

            } catch {
                if Task.isCancelled { return }

                self.state = .error(
                    message: error.localizedDescription
                )
            }
        }
    }

    // MARK: - Navigation
    func nextChapter() {
        position.chapter += 1
        load()
    }

    func previousChapter() {
        position.chapter = max(1, position.chapter - 1)
        load()
    }
}
