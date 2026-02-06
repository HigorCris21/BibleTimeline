//
//  HomeView.swift
//  BibleTimelineApp
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var isReadingPresented = false

    var body: some View {
        NavigationStack {
            content
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(isPresented: $isReadingPresented) {
                    ReadingView(position: .mark1)
                }
        }
        .appScreenBackground()
        .task {
            // Garante que não recarrega se a View for recriada em algum cenário.
            if case .loading = viewModel.state {
                viewModel.load()
            }
        }
    }
}

// MARK: - State-driven UI
private extension HomeView {

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
}

// MARK: - Subviews
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
                Text("Não foi possível carregar a cronologia")
                    .font(.headline)
                    .foregroundStyle(Theme.primaryText)

                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(Theme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)

                Button("Tentar novamente") {
                    viewModel.load()
                }
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

    func loadedView(items: [ChronologyItem]) -> some View {
        let first = items.first

        return ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {

                HeroHeader(
                    title: "Bom dia, Higor",
                    subtitle: "Leia a Bíblia em ordem cronológica, sem perder o fio da narrativa.",
                    ctaTitle: first?.title ?? "Continuar leitura",
                    onTapCTA: {
                        isReadingPresented = true
                    }
                )

                SectionTitle("Hoje")

                VerseOfDayCard(
                    reference: "Marcos 1:15",
                    verse: "“O tempo está cumprido, e o reino de Deus está próximo; arrependei-vos e crede no evangelho.”",
                    onTap: {
                        print("Open verse context")
                    }
                )

                SectionTitle("Leitura")

                StartReadingCard(
                    onTap: {
                        isReadingPresented = true
                    }
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 32)
        }
    }
}
