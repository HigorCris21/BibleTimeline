//
//  ReadingView.swift
//  BibleTimeline
//
//  Created by Higor Lo Castro on 06/02/26.
//

import SwiftUI

struct ReadingView: View {

    // MARK: - Persistence
    @AppStorage(AppStorageKeys.lastReadingPosition)
    private var lastReadingPositionData: Data = Data()

    // MARK: - State
    @StateObject private var vm: ReadingViewModel

    // MARK: - Init
    init(startIndex: Int, harmony: [ChronologyItem], bibleTextService: BibleTextService) {
        _vm = StateObject(
            wrappedValue: ReadingViewModel(
                startIndex: startIndex,
                harmony: harmony,
                bibleTextService: bibleTextService
            )
        )
    }

    // MARK: - Body
    var body: some View {
        content
            .navigationTitle(vm.eventTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button("Anterior") { vm.previous() }
                        .disabled(!vm.hasPrevious)

                    Spacer()

                    Text(vm.eventProgress)
                        .font(.footnote)
                        .foregroundStyle(Theme.secondaryText)

                    Spacer()

                    Button("Próximo") { vm.next() }
                        .disabled(!vm.hasNext)
                }
            }
            .task {
                if case .loading = vm.state { vm.load() }
                persistPosition(vm.position)
            }
            .onChange(of: vm.currentIndex) { _ in
                persistPosition(vm.position)
            }
    }

    // MARK: - Persist
    private func persistPosition(_ position: ReadingPosition) {
        guard let data = try? JSONEncoder().encode(position) else { return }
        lastReadingPositionData = data
    }

    // MARK: - Content
    @ViewBuilder
    private var content: some View {
        switch vm.state {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .loaded(let reference, let text):
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Seção do evento
                    Text(vm.currentEvent.section.uppercased())
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.secondaryText)

                    // Referência bíblica
                    Text(reference)
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(Theme.primaryText)

                    // Texto bíblico
                    Text(text)
                        .font(.body)
                        .foregroundStyle(Theme.primaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }

        case .error(let message):
            VStack(spacing: 12) {
                Text("Erro ao carregar")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Theme.primaryText)

                Text(message)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Theme.secondaryText)

                Button("Tentar novamente") { vm.load() }
                    .buttonStyle(.borderedProminent)
                    .tint(Theme.accent)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
    }
}
