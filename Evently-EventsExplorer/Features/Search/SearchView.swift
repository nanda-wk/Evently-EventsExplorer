//
//  SearchView.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-24.
//

import SwiftUI

struct SearchView: View {
    let container: DIContainer
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        SearchViewControllerWrapper(container: container)
            .ignoresSafeArea(edges: .bottom)
            .navigationTitle("Search Events")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                    }
                    .tint(.appPrimary)
                }
            }
    }
}

struct SearchViewControllerWrapper: UIViewControllerRepresentable {
    let container: DIContainer

    func makeUIViewController(context _: Context) -> SearchViewController {
        SearchViewController(container: container)
    }

    func updateUIViewController(_: SearchViewController, context _: Context) {
        // Nothing to update dynamically for now
    }
}

#Preview {
    SearchView(container: .preview)
}
