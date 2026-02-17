//
//  HomeView.swift
//  BibleTimeline
//

import SwiftUI

struct HomeView: View {

    let bibleTextService: BibleTextService

    @StateObject private var viewModel = HomeViewModel()
    @State private var isShowingAPIDebug = false
    @State private var selectedIndex: Int?

    // Agora lemos o ID do evento, nao a posicao biblica
    @AppStorage(AppStorageKeys.lastReadingEventId)
    private var lastReadingEventId: String = ""

    init(bibleTextService: BibleTextService) {
        self.bibleTextService = bibleTextService
    }

    var body: some View {
        NavigationStack {
            content
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $isShowingAPIDebug) {
                    NavigationStack { APIBibleDebugView() }
                }
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
                    ctaTitle: "Continuar leitura",
                    onTapCTA: {
                        // Busca pelo ID exato do evento — sempre preciso
                        selectedIndex = lastReadingIndex(in: harmony)
                    }
                )

                Button {
                    isShowingAPIDebug = true
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "stethoscope")
                        Text("Debug API")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.footnote)
                            .opacity(0.7)
                    }
                    .foregroundStyle(Theme.primaryText)
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Theme.surface)
                    )
                }
                .buttonStyle(.plain)

                SectionTitle("Hoje")

                VerseOfDayCard(
                    reference: "Marcos 1:15",
                    verse: "O tempo esta cumprido, e o reino de Deus esta proximo; arrependei-vos e crede no evangelho.",
                    onTap: { }
                )

                SectionTitle("Leitura")

                StartReadingCard(
                    onTap: { selectedIndex = 0 }
                )
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

    /// Busca o indice pelo ID do evento — exato e sem ambiguidade.
    /// Se o usuario nunca leu nada, retorna 0 (primeiro evento).
    func lastReadingIndex(in harmony: [ChronologyItem]) -> Int {
        guard !lastReadingEventId.isEmpty else { return 0 }
        return harmony.firstIndex { $0.id == lastReadingEventId } ?? 0
    }
}
