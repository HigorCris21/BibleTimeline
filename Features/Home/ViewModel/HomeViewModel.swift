//
//  HomeViewModel.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 06/02/26.
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

    private let loader: ChronologyLoading
    private var task: Task<Void, Never>?

    init(loader: ChronologyLoading = ChronologyLoader()) {
        self.loader = loader
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
                self.state = .error("Não foi possível carregar a cronologia.")
            }
        }
    }
    
    func startPosition(for item: ChronologyItem) -> ReadingPosition? {
        item.startPosition
    }


    deinit {
        task?.cancel()
    }
}
