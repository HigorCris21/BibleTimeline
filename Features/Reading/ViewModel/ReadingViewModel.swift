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
        case loaded([String])
        case error(String)
    }

    // MARK: - Published
    @Published private(set) var state: State = .loading
    @Published private(set) var pageIndex: Int

    // MARK: - Navigation helpers
    var hasNext: Bool     { pageIndex < totalPages - 1 }
    var hasPrevious: Bool { pageIndex > 0 }

    var currentEvent: ChronologyItem { eventsForPage(pageIndex).first ?? harmony[0] }

    // MARK: - Constants
    private let pageSize = 5

    // MARK: - Dependencies
    private let harmony: [ChronologyItem]
    private let bibleTextService: BibleTextService
    private var loadTask: Task<Void, Never>?

    // MARK: - Init
    init(startIndex: Int, harmony: [ChronologyItem], bibleTextService: BibleTextService) {
        self.harmony = harmony
        self.bibleTextService = bibleTextService
        self.pageIndex = startIndex / pageSize
    }

    deinit { loadTask?.cancel() }

    // MARK: - Computed
    var totalPages: Int {
        Int(ceil(Double(harmony.count) / Double(pageSize)))
    }

    private func eventsForPage(_ page: Int) -> [ChronologyItem] {
        let start = page * pageSize
        let end = min(start + pageSize, harmony.count)
        guard start < harmony.count else { return [] }
        return Array(harmony[start..<end])
    }

    // MARK: - Load
    func load() {
        loadTask?.cancel()
        state = .loading

        let events = eventsForPage(pageIndex)
        let currentPage = pageIndex

        loadTask = Task { [weak self] in
            guard let self else { return }

            do {
                try await withThrowingTaskGroup(of: (Int, String).self) { group in
                    for (index, event) in events.enumerated() {
                        guard let position = event.startPosition else { continue }
                        group.addTask {
                            let response = try await self.bibleTextService.fetchText(position: position)
                            return (index, response.text)
                        }
                    }

                    var results = [(Int, String)]()
                    for try await result in group {
                        results.append(result)
                    }
                    results.sort { $0.0 < $1.0 }

                    if Task.isCancelled { return }
                    guard self.pageIndex == currentPage else { return }

                    self.state = .loaded(results.map { $0.1 })
                }

            } catch {
                if Task.isCancelled { return }
                self.state = .error(error.localizedDescription)
            }
        }
    }

    // MARK: - Navigation
    func next() {
        guard hasNext else { return }
        pageIndex += 1
        load()
    }

    func previous() {
        guard hasPrevious else { return }
        pageIndex -= 1
        load()
    }
}
