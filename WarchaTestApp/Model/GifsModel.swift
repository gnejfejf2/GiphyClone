// UsableRecordsModel.swift

import Foundation

// MARK: - UsableRecordsModel
struct GifsModel: Hashable , Codable {
    var data: [Gif]?
    var pagination: Pagination?
    var meta: Meta?
}


// MARK: - Datum
struct Gif: Hashable , Codable {
    var type, id: String?
    var url: String?
    var slug: String?
    var bitlyGIFURL, bitlyURL: String?
    var embedURL: String?
    var username: String?
    var source: String?
    var title, rating, contentURL, sourceTLD: String?
    var sourcePostURL: String?
    var isSticker: Int?
    var importDatetime, trendingDatetime: String?
    var images: Images?
    var user: User?
    var analyticsResponsePayload: String?
    var analytics: Analytics?
}


// MARK: - Analytics
struct Analytics: Hashable , Codable {
    var onload, onclick, onsent: Onclick?
}

// MARK: - Onclick
struct Onclick: Hashable , Codable {
    var url: String?
}


// MARK: - Images
struct Images: Hashable  , Codable{
    var original: Original?
    var fixedHeightSmallStill : Downsized?
    var the480WStill: The480WStill?
    
    enum CodingKeys: String, CodingKey {
        case original
        case fixedHeightSmallStill = "fixed_width_small_still"
        case the480WStill = "480w_still"
    }
    
    
}

struct Downsized: Hashable  , Codable {
    var height, width, size: String?
    var url: String?
}



struct Original: Hashable , Codable {
    var height, width, size: String
    var url: String
    var mp4Size: String?
    var mp4: String?
    var webpSize: String?
    var webp: String?
    var frames, hash: String?
}


struct The480WStill: Hashable , Codable {
    var height, width, size: String
    var url: String
}

struct User: Hashable , Codable {
    var avatarURL, bannerImage, bannerURL: String?
    var profileURL: String?
    var username, displayName, userDescription, instagramURL: String?
    var websiteURL: String?
    var isVerified: Bool?
}

struct Meta: Hashable , Codable{
    var status: Int?
    var msg, responseID: String?
}

struct Pagination: Hashable , Codable{
    var totalCount, count, offset: Int?
}
