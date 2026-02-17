//
//  SearchView.swift
//  BibleTimeline
//
//  Created by Higor Lo Castro on 10/02/26.
//

import SwiftUI

// MARK: - SearchView
struct SearchView: View {

    let bibleTextService: BibleTextService

    @StateObject private var viewModel = SearchViewModel()
    @State private var selectedIndex: Int?

    init(bibleTextService: BibleTextService) {
        self.bibleTextService = bibleTextService
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                bookCard
                chapterCard
                readButton
                Spacer()
            }
            .padding(16)
            .navigationTitle("Buscar")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: $selectedIndex) { index in
                ReadingView(
                    startIndex: index,
                    harmony: viewModel.harmony,
                    bibleTextService: bibleTextService
                )
            }
        }
        .appScreenBackground()
        .task {
            await viewModel.loadHarmony()
        }
    }
}

// MARK: - UI
private extension SearchView {

    var bookCard: some View {
        HStack(spacing: 12) {
            Image(systemName: "book.closed.fill")
                .font(.title3)
                .foregroundStyle(Theme.accent)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text("Livro")
                    .font(.headline)
                    .foregroundStyle(Theme.primaryText)

                Text("Evangelhos")
                    .font(.footnote)
                    .foregroundStyle(Theme.secondaryText)
            }

            Spacer()

            Picker(
                "Livro",
                selection: Binding(
                    get: { viewModel.selectedBook },
                    set: { viewModel.onChangeBook($0) }
                )
            ) {
                ForEach(GospelBook.allCases) { book in
                    Text(book.displayName).tag(book)
                }
            }
            .labelsHidden()
            .pickerStyle(.menu)
        }
        .appCard()
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Livro")
        .accessibilityValue(viewModel.selectedBook.displayName)
    }

    var chapterCard: some View {
        HStack(spacing: 12) {
            Image(systemName: "number.circle.fill")
                .font(.title3)
                .foregroundStyle(Theme.accent)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text("Capítulo")
                    .font(.headline)
                    .foregroundStyle(Theme.primaryText)

                Text("Selecione o capítulo")
                    .font(.footnote)
                    .foregroundStyle(Theme.secondaryText)
            }

            Spacer()

            Picker("Capítulo", selection: $viewModel.selectedChapter) {
                ForEach(viewModel.availableChapters, id: \.self) { chapter in
                    Text("\(chapter)").tag(chapter)
                }
            }
            .labelsHidden()
            .pickerStyle(.menu)
        }
        .appCard()
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Capítulo")
        .accessibilityValue("\(viewModel.selectedChapter)")
    }

    var readButton: some View {
        Button {
            selectedIndex = viewModel.indexForSelection()
        } label: {
            HStack {
                Spacer()
                Text("Ler")
                    .font(.headline)
                Spacer()
            }
            .padding(.vertical, 12)
        }
        .buttonStyle(.borderedProminent)
        .tint(Theme.accent)
        .disabled(viewModel.availableChapters.isEmpty || viewModel.harmony.isEmpty)
        .accessibilityHint("Abrir a leitura no livro e capítulo selecionados")
    }
}
