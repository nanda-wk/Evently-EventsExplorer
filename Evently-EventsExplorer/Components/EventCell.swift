//
//  EventCell.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-23.
//

import SwiftUI

struct EventCell: View {
    let event: Event
    var body: some View {
        HStack(spacing: 20) {
            AsyncImage(url: event.images.first?.url) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(16)

            } placeholder: {
                ProgressView()
            }
            .frame(width: 150)

            VStack(alignment: .leading) {
                Text(event.name)
                    .lineLimit(2)
                    .font(.headline)

                Text(event.venue.name)
                    .font(.callout)

                Text(event.date.localDate)
                    .font(.footnote)
                    .fontWeight(.medium)
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    EventCell(event: .mockData)
}
