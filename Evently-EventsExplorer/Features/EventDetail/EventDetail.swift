//
//  EventDetail.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-24.
//

import SwiftUI

struct EventDetail: View {
    @Environment(\.dismiss) private var dismiss

    let event: Event

    private var date = ""
    private var time = ""
    private var address = ""
    private var venue: Venue = .init()

    init(event: Event) {
        self.event = event
        let date = event.dates?.start?.localDate
        let time = event.dates?.start?.localTime
        if let date, let time {
            self.date = date.toFormatedDate(format: .dd_MMMM_yyyy)
            self.time = "\(date.toFormatedDate(format: .EEEE)) • \(time.toFormatedDate(format: .hmm_a))"
        }
        if let embedded = event.embedded, let venue = embedded.venues.first, let address = venue.address, let city = venue.city {
            self.venue = venue
            self.address = "\(address.line1.orEmpty) • \(city.name.orEmpty)"
        }
    }

    var body: some View {
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
                        customListTile(icon: "calendar", title: date, subtitle: time)
                        if !address.isEmpty {
                            customListTile(icon: "mappin.and.ellipse", title: venue.name.orEmpty, subtitle: address)
                        }
                    }

                    aboutSection
                }
                .padding()
            }
        }
        .navigationTitle("Event Details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
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
    private var aboutSection: some View {
        if let info = event.info {
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
        EventDetail(event: .mockData)
    }
}
