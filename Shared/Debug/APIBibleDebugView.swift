//
//  APIBibleDebugView.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 12/02/26.
//

import SwiftUI

struct APIBibleDebugView: View {

    private let healthCheck: APIBibleHealthChecking
    @State private var output: String = "Toque em “Testar”"

    init(healthCheck: APIBibleHealthChecking = APIBibleHealthCheck()) {
        self.healthCheck = healthCheck
    }

    var body: some View {
        VStack(spacing: 12) {
            Button("Testar /v1/bibles/{bibleId}/books/MAT/chapters") {
                Task { await runTest() }
            }

            ScrollView {
                Text(output)
                    .font(.system(.footnote, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
            }
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(16)
        .navigationTitle("API Debug")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func runTest() async {
        output = "Executando…"

        let result = await healthCheck.testChaptersEndpoint(bookUSFM: "MAT")
        switch result {
        case .success(let text):
            output = text
        case .failure(let error):
            output = "❌ Erro: \(error.localizedDescription)"
        }
    }
}
