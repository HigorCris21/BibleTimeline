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
    private let service: BibleTextService

    // MARK: - Task control
    private var loadTask: Task<Void, Never>?

    // MARK: - Init
    init(
        position: ReadingPosition,
        service: BibleTextService = MockBibleTextService()
    ) {
        self.position = position
        self.service = service
    }

    deinit {
        loadTask?.cancel()
    }

    // MARK: - Load
    func load() {
        loadTask?.cancel()

        loadTask = Task { [weak self] in
            guard let self else { return }

            self.state = .loading

            do {
                let response = try await self.service.fetchText(position: self.position)
                if Task.isCancelled { return }

                self.state = .loaded(
                    reference: response.reference,
                    text: response.text
                )
            } catch {
                if Task.isCancelled { return }
                self.state = .error(message: "Não foi possível carregar o texto.")
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
