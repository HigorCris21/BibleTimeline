//
//  HomeView.swift
//  BibleTimeline
//

import SwiftUI

struct HomeView: View {

    let bibleTextService: BibleTextService

    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedIndex: Int?

    @AppStorage(AppStorageKeys.lastReadingEventId)
    private var lastReadingEventId: String = ""
    private var hasStarted: Bool { !lastReadingEventId.isEmpty }

    init(bibleTextService: BibleTextService) {
        self.bibleTextService = bibleTextService
    }

    var body: some View {
        NavigationStack {
            content
                .navigationBarTitleDisplayMode(.inline)
        }
        .appScreenBackground()
        .task {
            if case .loading = viewModel.state { viewModel.load() }
        }
    }
}

// MARK: - State Routing
private extension HomeView {

    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .loading:
            loadingView

        case .error(let message):
            errorView(message: message)

        case .loaded(let harmony):
            loadedView(harmony: harmony)
        }
    }
}

// MARK: - State Views
private extension HomeView {

    var loadingView: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Theme.surface.opacity(0.6))
                    .frame(height: 150)
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Theme.surface.opacity(0.6))
                    .frame(height: 140)
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Theme.surface.opacity(0.6))
                    .frame(height: 170)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 32)
        }
    }

    func errorView(message: String) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Nao foi possivel carregar a tela inicial")
                    .font(.headline)
                    .foregroundStyle(Theme.primaryText)

                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(Theme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)

                Button("Tentar novamente") { viewModel.load() }
                    .buttonStyle(.plain)
                    .padding(.top, 8)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Theme.surface)
            )
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 32)
        }
    }

    func loadedView(harmony: [ChronologyItem]) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {

                HeroHeader(
                    title: "Bom dia, Higor",
                    subtitle: "Leia a Biblia em ordem cronologica, sem perder o fio da narrativa.",
                    ctaTitle: hasStarted ? "Continuar Leitura" : "Iniciar Leitura",
                    ctaIcon: hasStarted ? "play.circle.fill" : "book.circle.fill",
                    onTapCTA: {
                        selectedIndex = lastReadingIndex(in: harmony)
                    }
                )

                SectionTitle("Hoje")

                VerseOfDayCard(
                    reference: "Marcos 1:15",
                    verse: "O tempo esta cumprido, e o reino de Deus esta proximo; arrependei-vos e crede no evangelho."
                )

                if hasStarted {
                    SectionTitle("Leitura")

                    StartReadingCard(
                        title: "Recomeçar Leitura",
                        subtitle: "Volte ao primeiro evento.",
                        icon: "arrow.counterclockwise",
                        buttonTitle: "Recomeçar Agora",
                        onTap: { selectedIndex = 0 }
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 32)
        }
        .navigationDestination(item: $selectedIndex) { index in
            ReadingView(
                startIndex: index,
                harmony: harmony,
                bibleTextService: bibleTextService
            )
        }
    }
}

// MARK: - Helpers
private extension HomeView {

    func lastReadingIndex(in harmony: [ChronologyItem]) -> Int {
        guard hasStarted else { return 0 }
        return harmony.firstIndex { $0.id == lastReadingEventId } ?? 0
    }
}

