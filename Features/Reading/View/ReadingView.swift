//
//  ReadingView.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 06/02/26.
//

import SwiftUI

struct ReadingView: View {

    // MARK: - State
    @StateObject private var vm: ReadingViewModel

    // MARK: - Init
    init(position: ReadingPosition) {
        _vm = StateObject(
            wrappedValue: ReadingViewModel(position: position)
        )
    }

    // MARK: - Body
    var body: some View {
        content
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button("Anterior") {
                        vm.previousChapter()
                    }
                    Spacer()
                    Button("Próximo") {
                        vm.nextChapter()
                    }
                }
            }
            .task {
                vm.load()
            }
    }

    // MARK: - Title
    private var title: String {
        "\(vm.position.book) \(vm.position.chapter)"
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
                    Text(reference)
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text(text)
                        .font(.body)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }

        case .error(let message):
            VStack(spacing: 12) {
                Text("Erro")
                    .font(.title3)
                    .fontWeight(.semibold)

                Text(message)
                    .multilineTextAlignment(.center)

                Button("Tentar novamente") {
                    vm.load()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
    }
}
