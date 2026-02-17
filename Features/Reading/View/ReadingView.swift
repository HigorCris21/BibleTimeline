//
//  ReadingView.swift
//  BibleTimeline
//
//  Created by Higor Lo Castro on 06/02/26.
//

import SwiftUI

struct ReadingView: View {

    // Salva o ID do evento, nao a posicao biblica
    @AppStorage(AppStorageKeys.lastReadingEventId)
    private var lastReadingEventId: String = ""

    @StateObject private var vm: ReadingViewModel

    init(startIndex: Int, harmony: [ChronologyItem], bibleTextService: BibleTextService) {
        _vm = StateObject(
            wrappedValue: ReadingViewModel(
                startIndex: startIndex,
                harmony: harmony,
                bibleTextService: bibleTextService
            )
        )
    }

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

                    Button("Proximo") { vm.next() }
                        .disabled(!vm.hasNext)
                }
            }
            .task {
                if case .loading = vm.state { vm.load() }
                lastReadingEventId = vm.currentEvent.id
            }
            .onChange(of: vm.currentIndex) { _ in
                lastReadingEventId = vm.currentEvent.id
            }
    }

    @ViewBuilder
    private var content: some View {
        switch vm.state {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .loaded(let reference, let text):
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(vm.currentEvent.section.uppercased())
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.secondaryText)

                    Text(reference)
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(Theme.primaryText)

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
