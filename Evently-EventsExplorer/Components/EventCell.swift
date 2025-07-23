//
//  EventCell.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-23.
//

import SwiftUI

struct EventCell: View {
    let event: Event

    private var dateAndTime = ""
    private var address = ""

    init(event: Event) {
        self.event = event
        let date = event.date.localDate
        let time = event.date.localTime
        dateAndTime = "\(date.toFormatedDate(format: .EEE)), \(date.toFormatedDate(format: .MMM_d)) • \(time.toFormatedDate(format: .hmm_a))"
        address = "\(event.venue.address) • \(event.venue.city)"
    }

    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            AsyncImage(url: event.images.first?.url) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 90)
                    .cornerRadius(16)
                    .clipped()

            } placeholder: {
                ProgressView()
                    .frame(width: 120, height: 90)
            }

            VStack(alignment: .leading) {
                Text(dateAndTime)
                    .font(.footnote)
                    .foregroundStyle(.appPrimary)

                Text(event.name)
                    .lineLimit(2)
                    .font(.headline)

                HStack {
                    Image(systemName: "mappin.and.ellipse")

                    Text(address)
                        .lineLimit(1)
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    EventCell(event: .mockData)
}
