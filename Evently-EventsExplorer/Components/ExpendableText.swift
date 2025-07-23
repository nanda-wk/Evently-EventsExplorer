//
//  ExpendableText.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-24.
//

import SwiftUI

struct ExpendableText: View {
    @State private var expanded = false

    let text: String
    let lineLimit: Int

    init(text: String, lineLimit: Int) {
        self.text = text
            .components(separatedBy: "\n\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .joined(separator: "\n\n")
        self.lineLimit = lineLimit
    }

    var body: some View {
        Text(text)
            .font(.callout)
            .lineLimit(expanded ? nil : lineLimit)
            .animation(.easeInOut, value: expanded)

        Button {
            expanded.toggle()
        } label: {
            Text(expanded ? "Read Less" : "Read More")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.appPrimary)
        }
    }
}
