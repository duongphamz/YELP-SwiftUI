//
//  Business.swift
//  HomeTest
//
//  Created by Duong Pham on 13/02/2022.
//

import Foundation

struct SearchBusinessResponse: Decodable {
    let businesses: [Business]
    let total: Int?
}

struct Business: Decodable, Identifiable {
    var id: String {
        return objectID
    }
    let objectID: String
    let imageUrl: String?
    let name: String?
    let location: Location?
    let categories: [Category]?
    let hours: [OpenTime]?
    let rating: Double?
    let phone: String?
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
        case objectID = "id"
        case name, location, categories, hours, rating, phone
    }
}
extension Business {
    struct Location: Decodable {
        let city: String?
        let country: String?
        let address1: String?
        let address2: String?
        let address3: String?
        let state: String?
        let zipCode: String?
        let displayAddress: [String]?
        enum CodingKeys: String, CodingKey {
            case zipCode = "zip_code"
            case displayAddress = "display_address"
            case city, country, address1, address2, address3, state
        }
    }

    struct Category: Decodable {
        let alias: String?
        let title: String?
    }

    struct OperationTime: Decodable {
        let isOverNight: Bool?
        let start: String?
        let end: String?
        let day: Int?
        
        enum CodingKeys: String, CodingKey {
            case isOverNight = "is_overnight"
            case start, end, day
        }
    }

    struct OpenTime: Decodable {
        let open: [OperationTime]?
        let hoursType: String?
        let isOpenNow: Bool?
        enum CodingKeys: String, CodingKey {
            case hoursType = "hours_type"
            case isOpenNow = "is_open_now"
            case open
        }
    }
}

