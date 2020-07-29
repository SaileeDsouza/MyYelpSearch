//
//  BusinessModel.swift
//  YelpSearch
//
//  Created by Sailee Pereira on 2020-07-27.
//  Copyright © 2020 SaileePereira. All rights reserved.
//

import Foundation

// MARK: - BusinessSearch
struct BusinessSearch: Codable {
    let businesses: [BusinessElement]?
    let total: Int?
    let region: Region?
}

// MARK: - Business
struct BusinessElement: Codable {
    let id, name: String
    let imageURL: String?
    let reviewCount: Int?
    let location: Location?
    let displayPhone: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case imageURL = "image_url"
        case reviewCount = "review_count"
        case location
        case displayPhone = "display_phone"
        
    }
}

// MARK: - Location
struct Location: Codable {
    let address1: String?
    let address2, address3: String?
    let city: String?
    let zipCode: String?
    let country: String?
    let state: String?
    let displayAddress: [String]?
    
    enum CodingKeys: String, CodingKey {
        case address1, address2, address3, city
        case zipCode = "zip_code"
        case country, state
        case displayAddress = "display_address"
    }
}

// MARK: - Region
struct Region: Codable {
    let center: Center?
}

// MARK: - Center
struct Center: Codable {
    let latitude, longitude: Double?
}


// MARK: - ErrorModel
struct ErrorModel: Codable {
    let errorCode:Int
    let message: String
    
    enum codingKeys: String, CodingKey  {
        case message
        case errorCode = "error"
    }
}

// MARK: - RestaurantModel
struct RestaurantModel {
    let id, name: String
    let imageURL: String?
    let displayAddress: [String]?
}


// MARK: - ReviewModel
struct ReviewModel: Codable {
    let reviews: [Review]?
    let total: Int?
    let possibleLanguages: [String]?
    
    enum CodingKeys: String, CodingKey {
        case reviews, total
        case possibleLanguages = "possible_languages"
    }
}

// MARK: - Review
struct Review: Codable {
    let id: String?
    let rating: Int?
    let user: User?
    let text, timeCreated: String
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case id, rating, user, text
        case timeCreated = "time_created"
        case url
    }
}

struct User : Codable {
    let id: String?
    let image_url: String?
    let name: String?
}
