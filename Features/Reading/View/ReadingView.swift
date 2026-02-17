//
//  ReadingView.swift
//  BibleTimeline
//
//  Created by Higor Lo Castro on 06/02/26.
//

import SwiftUI

struct ReadingView: View {

    @AppStorage(AppStorageKeys.lastReadingEventId)
    private var lastReadingEventId: String = ""

    @Environment(\.dismiss) private var dismiss

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
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .fontWeight(.semibold)
                    }
                }

                ToolbarItemGroup(placement: .bottomBar) {
                    Button("Anterior") { vm.previous() }
                        .disabled(!vm.hasPrevious)

                    Spacer()

                    Button("Proximo") { vm.next() }
                        .disabled(!vm.hasNext)
                }
            }
            .task {
                if case .loading = vm.state { vm.load() }
                lastReadingEventId = vm.currentEvent.id
            }
            .onChange(of: vm.pageIndex) { _ in
                lastReadingEventId = vm.currentEvent.id
            }
    }

    @ViewBuilder
    private var content: some View {
        switch vm.state {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .loaded(let texts):
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(texts.indices, id: \.self) { index in
                        Text(stripVerseNumbers(texts[index]))
                            .font(.body)
                            .foregroundStyle(Theme.primaryText)
                            .lineSpacing(6)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 22)
                .padding(.vertical, 28)
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

    private func stripVerseNumbers(_ text: String) -> String {
        let pattern = #"\[\d+\]\s*"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return text }
        let range = NSRange(text.startIndex..., in: text)
        return regex.stringByReplacingMatches(in: text, range: range, withTemplate: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
