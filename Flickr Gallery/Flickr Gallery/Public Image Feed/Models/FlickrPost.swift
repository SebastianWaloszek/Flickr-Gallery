//
//  FlickrPost.swift
//  Flickr Gallery
//
//  Created by Sebastian Waloszek on 10/08/2017.
//  Copyright © 2017 Sebastian Waloszek. All rights reserved.
//

import Foundation

struct FlickrPost: Codable {

    // URL to the post's image
    let media: [String:URL]
    
    // Date when the photo was taken
    let photoTakenDate: Date

    // Date when the photo was published
    let publishedDate: Date

    // Name of the post's author
    let author: String?
    
    // Post's tags
    let tags: String
    
    private enum CodingKeys: String, CodingKey {
        case media
        case photoTakenDate = "date_taken"
        case publishedDate = "published"
        case author
        case tags
    }

}

