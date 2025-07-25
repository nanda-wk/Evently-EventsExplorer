//
//  EventDetailViewModel.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-25.
//

import Foundation

extension EventDetail {
    @MainActor
    class ViewModel: ObservableObject {
        @Published var details: Loadable<Event> = .isLoading
        @Published var date = ""
        @Published var time = ""
        @Published var address = ""
        @Published var venue: Venue = .init()

        let event: Event
        let container: DIContainer

        init(container: DIContainer, event: Event) {
            self.container = container
            self.event = event
        }

        func loadEventDetails() async {
            do {
                let eventDetails = try await container.services.eventDiscoveryService.load(eventDetails: event)
                (date, time) = formatEventDateTime(date: eventDetails.dates)
                venue = eventDetails.embedded?.venues.first ?? .init()
                address = venue.address?.line1.orEmpty ?? ""
                details = .loaded(eventDetails)
            } catch {
                details = .failed(error)
            }
        }

        private func formatEventDateTime(date: EventDate?) -> (String, String) {
            let startDate = date?.start?.localDate
            let startTime = date?.start?.localDate
            var result = ("", "")
            if let startDate, let startTime {
                result = (startDate.toFormatedDate(format: .dd_MMMM_yyyy), "\(startDate.toFormatedDate(format: .EEEE)) • \(startTime.toFormatedDate(format: .hmm_a))")
            }
            return result
        }
    }
}
