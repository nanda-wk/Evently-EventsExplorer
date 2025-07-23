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

    init(event: Event) {
        self.event = event
        let date = event.date.localDate
        let time = event.date.localTime
        self.date = date.toFormatedDate(format: .dd_MMMM_yyyy)
        self.time = "\(date.toFormatedDate(format: .EEEE)) • \(time.toFormatedDate(format: .hmm_a))"
        address = "\(event.venue.address), \(event.venue.city)"
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                AsyncImage(url: event.images.first?.url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 244)

                } placeholder: {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .frame(height: 244, alignment: .center)
                }

                VStack(alignment: .leading, spacing: 20) {
                    Text(event.name)
                        .font(.largeTitle)
                        .fontWeight(.medium)

                    VStack(alignment: .leading, spacing: 16) {
                        customListTile(icon: "calendar", title: date, subtitle: time)
                        customListTile(icon: "mappin.and.ellipse", title: event.venue.name, subtitle: address)
                    }

                    aboutSection
                }
                .padding()
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.backward")

                        Text("Event Details")
                            .fontWeight(.medium)
                    }
                    .font(.title2)
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.8), radius: 4)
                }
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
