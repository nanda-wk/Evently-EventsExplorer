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
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            SearchView(container: viewModel.container)
                        } label: {
                            Image(systemName: "magnifyingglass")
                        }
                        .tint(.appPrimary)
                    }
                }
        }
        .task {
            await viewModel.loadEvents()
        }
    }
}

extension Home {
    @ViewBuilder
    private var content: some View {
        switch viewModel.events {
        case .isLoading:
            ProgressView()
                .padding()
                .scaleEffect(2)
        case let .loaded(events):
            loadedView(events: events)
        case let .failed(error):
            Text("Failed to fetch data \(error)")
        }
    }

    private func loadedView(events: [Event]) -> some View {
        List {
            ForEach(events, id: \.id) { event in
                NavigationLink {
                    EventDetail(viewModel: .init(container: viewModel.container, event: event))
                } label: {
                    EventCell(event: event)
                }
            }

            if viewModel.shouldLoadMore {
                ProgressView()
                    .scaleEffect(1.5)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
                    .task {
                        await viewModel.loadEvents()
                    }
            }
        }
        .listStyle(.plain)
        .refreshable {
            await viewModel.loadEvents(reset: true)
        }
    }
}

#if DEBUG
    #Preview {
        Home(viewModel: .init(container: .preview))
    }
#endif
