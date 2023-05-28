//
//  TweetModel.swift
//  TweetAppWizeline
//
//  Created by Lina on 28/05/23.
//

import Foundation

struct TweetModel: Decodable {
    let tweets: [Tweet]
}

struct Tweet: Decodable {
    let createdAt: String
    let idStr: String
    let text: String
    let user: User
    let favoriteCount: Int
    let retweetCount: Int
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case idStr = "id_str"
        case text
        case user
        case favoriteCount = "favorite_count"
        case retweetCount = "retweet_count"
    }
}

struct User: Decodable {
    let name: String
    let screenName: String
    let description: String
    let location: String
    let followersCount: Int
    let createdAt: String
    let profileBackgroundColor: String
    let profileImageUrl: String
    let profileBackgroundImageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case screenName = "screen_name"
        case description
        case location
        case followersCount = "followers_count"
        case createdAt = "created_at"
        case profileBackgroundColor = "profile_background_color"
        case profileImageUrl = "profile_image_url"
        case profileBackgroundImageUrl = "profile_background_image_url"
    }
}

