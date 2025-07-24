//
//  Venue.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-24.
//

struct Venue: Codable {
    let id: String
    let name: String?
    let city: City?
    let state: VenueState?
    let country: Country?
    let address: Address?
    let location: VenueLocation?

    init(
        id: String = "1",
        name: String? = nil,
        city: City? = nil,
        state: VenueState? = nil,
        country: Country? = nil,
        address: Address? = nil,
        location: VenueLocation? = nil
    ) {
        self.id = id
        self.name = name
        self.city = city
        self.state = state
        self.country = country
        self.address = address
        self.location = location
    }
}

struct City: Codable {
    let name: String?
}

struct VenueState: Codable {
    let name: String?
    let stateCode: String?
}

struct Country: Codable {
    let name: String?
    let countryCode: String?
}

struct Address: Codable {
    let line1: String?
    let line2: String?
    let line3: String?
}

struct VenueLocation: Codable {
    let longitude: String?
    let latitude: String?
}
