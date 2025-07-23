//
//  Venue.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-24.
//

struct Venue: Decodable {
    let name: String
    let city: String
    let state: String?
    let country: String
    let address: String
    let latitude: String
    let longitude: String

    enum CodingKeys: String, CodingKey {
        case name
        case city
        case state
        case country
        case address
        case location
    }

    enum CityKeys: String, CodingKey {
        case name
    }

    enum StateKeys: String, CodingKey {
        case name
    }

    enum CountryKeys: String, CodingKey {
        case name
    }

    enum AddressKeys: String, CodingKey {
        case line1
    }

    enum LocationKeys: String, CodingKey {
        case latitude
        case longitude
    }

    init(
        name: String = "Sample Venue",
        city: String = "Sample City",
        state: String = "Sample State",
        country: String = "Sample Country",
        address: String = "123 Sample St",
        latitude: String = "0.0",
        longitude: String = "0.0"
    ) {
        self.name = name
        self.city = city
        self.state = state
        self.country = country
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decode(String.self, forKey: .name)

        let cityContainer = try container.nestedContainer(keyedBy: CityKeys.self, forKey: .city)
        city = try cityContainer.decode(String.self, forKey: .name)

        if let stateContainer = try? container.nestedContainer(keyedBy: StateKeys.self, forKey: .state) {
            state = try stateContainer.decode(String.self, forKey: .name)
        } else {
            state = nil
        }

        let countryContainer = try container.nestedContainer(keyedBy: CountryKeys.self, forKey: .country)
        country = try countryContainer.decode(String.self, forKey: .name)

        let addressContainer = try container.nestedContainer(keyedBy: AddressKeys.self, forKey: .address)
        address = try addressContainer.decode(String.self, forKey: .line1)

        let locationContainer = try container.nestedContainer(keyedBy: LocationKeys.self, forKey: .location)
        latitude = try locationContainer.decode(String.self, forKey: .latitude)
        longitude = try locationContainer.decode(String.self, forKey: .longitude)
    }
}
