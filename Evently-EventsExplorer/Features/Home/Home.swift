//
//  Home.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-22.
//

import SwiftUI

struct Home: View {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Discover Events")
                .task {
                    await viewModel.loadEvents()
                }
        }
    }
}

extension Home {
    @ViewBuilder
    private var content: some View {
        switch viewModel.events {
        case .isLoading:
            ProgressView()
                .scaleEffect(2)
        case let .loaded(events):
            loadedView(events: events.events)
        case let .failed(error):
            Text("Failed to fetch data \(error)")
        }
    }

    private func loadedView(events: [Event]) -> some View {
        List(events, id: \.id) { event in
            Text(event.name)
        }
    }
}

#Preview {
    Home(viewModel: .init(container: .preview))
}
