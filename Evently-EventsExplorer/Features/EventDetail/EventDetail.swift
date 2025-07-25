//
//  EventDetail.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-24.
//

import SwiftUI

struct EventDetail: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        content
            .navigationTitle("Event Details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .task {
                await viewModel.loadEventDetails()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                    }
                    .tint(.appPrimary)
                }
            }
    }
}

extension EventDetail {
    @ViewBuilder
    private var content: some View {
        switch viewModel.details {
        case .isLoading:
            ProgressView()
                .padding()
                .scaleEffect(2)
        case let .loaded(event):
            loadedView(event: event)
        case let .failed(error):
            Text("Failed to fetch event detail: \(error)")
        }
    }

    private func loadedView(event: Event) -> some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                AsyncImage(url: event.images.first?.url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 244)
                        .clipped()

                } placeholder: {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .frame(height: 244, alignment: .center)
                }

                VStack(alignment: .leading, spacing: 20) {
                    Text(event.name.orEmpty)
                        .font(.largeTitle)
                        .fontWeight(.medium)

                    VStack(alignment: .leading, spacing: 16) {
                        if !viewModel.time.isEmpty, !viewModel.date.isEmpty {
                            customListTile(icon: "calendar", title: viewModel.date, subtitle: viewModel.time)
                        }
                        if !viewModel.address.isEmpty {
                            customListTile(icon: "mappin.and.ellipse", title: viewModel.venue.name.orEmpty, subtitle: viewModel.address)
                        }
                    }

                    aboutSection(info: event.info)
                }
                .padding()
            }
        }
    }
}

extension EventDetail {
    private func customListTile(icon: String, title: String, subtitle: String) -> some View {
        HStack(alignment: .top, spacing: 20) {
            Image(systemName: icon)
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundStyle(.appPrimary)
                .padding(10)
                .background(.appPrimary.opacity(0.1))
                .clipShape(.rect(cornerRadius: 12))

            VStack(alignment: .leading) {
                Text(title)
                    .fontWeight(.medium)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    @ViewBuilder
    private func aboutSection(info: String?) -> some View {
        if let info {
            VStack(alignment: .leading, spacing: 8) {
                Text("Important Event Info")
                    .fontWeight(.medium)

                ExpendableText(text: info, lineLimit: 4)
            }
        } else {
            EmptyView()
        }
    }
}

#Preview {
    NavigationStack {
        EventDetail(viewModel: .init(container: .preview, event: .mockData))
    }
}
