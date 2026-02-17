//
//  ExploreView.swift
//  BibleTimeline
//

import SwiftUI

// MARK: - ExploreView
struct ExploreView: View {

    let bibleTextService: BibleTextService

    @StateObject private var viewModel = ExploreViewModel()
    @State private var readingPosition: ReadingPosition?

    init(bibleTextService: BibleTextService) {
        self.bibleTextService = bibleTextService
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Explorar")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(item: $readingPosition) { position in
                    ReadingView(
                        position: position,
                        bibleTextService: bibleTextService
                    )
                }
        }
        .appScreenBackground()
        .task {
            if case .loading = viewModel.state {
                viewModel.load()
            }
        }
    }
}

// MARK: - State-driven UI
private extension ExploreView {

    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .loading:
            loadingView

        case .error(let message):
            errorView(message: message)

        case .loaded(let items):
            loadedView(items: items)
        }
    }

    var loadingView: some View {
        VStack(spacing: 10) {
            ProgressView()
            Text("Carregando…")
                .font(.footnote)
                .foregroundStyle(Theme.secondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Carregando conteúdo")
    }

    func errorView(message: String) -> some View {
        VStack(spacing: 12) {
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundStyle(Theme.primaryText)

            Button("Tentar novamente") {
                viewModel.load()
            }
            .buttonStyle(.borderedProminent)
            .tint(Theme.accent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(16)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Erro ao carregar")
        .accessibilityValue(message)
    }

    func loadedView(items: [ChronologyItem]) -> some View {
        // Agrupa por seção mantendo a ordem cronológica
        let sections = groupedSections(from: items)

        return ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) {
                ForEach(sections, id: \.title) { section in
                    Section {
                        ForEach(section.items) { item in
                            chronologyCard(item: item)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 10)
                        }
                    } header: {
                        sectionHeader(title: section.title)
                    }
                }
            }
            .padding(.bottom, 32)
        }
    }

    // MARK: - Section Header
    func sectionHeader(title: String) -> some View {
        Text(title.uppercased())
            .font(.footnote.weight(.semibold))
            .foregroundStyle(Theme.secondaryText)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.background)
            .accessibilityAddTraits(.isHeader)
    }

    // MARK: - Card
    func chronologyCard(item: ChronologyItem) -> some View {
        Button {
            guard let position = item.startPosition else { return }
            readingPosition = position
        } label: {
            HStack(spacing: 12) {
                // Número de ordem cronológica
                Text("\(item.order)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.secondaryText)
                    .frame(minWidth: 28, alignment: .trailing)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title)
                        .font(.headline)
                        .foregroundStyle(Theme.primaryText)

                    Text(item.displayReference)
                        .font(.footnote)
                        .foregroundStyle(Theme.secondaryText)
                }

                Spacer(minLength: 0)

                Image(systemName: "chevron.right")
                    .foregroundStyle(Theme.secondaryText)
                    .accessibilityHidden(true)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .appCard()
        .accessibilityLabel(item.title)
        .accessibilityValue(item.displayReference)
        .accessibilityHint(item.startPosition == nil ? "Indisponível" : "Abrir leitura")
        .disabled(item.startPosition == nil)
        .opacity(item.startPosition == nil ? 0.55 : 1.0)
    }
}

// MARK: - Grouping Helper
private extension ExploreView {

    struct SectionGroup {
        let title: String
        let items: [ChronologyItem]
    }

    /// Agrupa os itens por `section` mantendo a ordem cronológica do primeiro item de cada seção.
    func groupedSections(from items: [ChronologyItem]) -> [SectionGroup] {
        var seen = [String: Int]()       // section title → index em `result`
        var result = [SectionGroup]()

        for item in items {
            if let index = seen[item.section] {
                let existing = result[index]
                result[index] = SectionGroup(title: existing.title, items: existing.items + [item])
            } else {
                seen[item.section] = result.count
                result.append(SectionGroup(title: item.section, items: [item]))
            }
        }

        return result
    }
}
