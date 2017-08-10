//
//  FlickrPost.swift
//  Flickr Gallery
//
//  Created by Sebastian Waloszek on 10/08/2017.
//  Copyright © 2017 Sebastian Waloszek. All rights reserved.
//

import Foundation

struct FlickrWebsiteDescription: Codable {
    
    // Array of posts from the flickr public feed
    let posts: [FlickrPost]
    
    private enum CodingKeys: String, CodingKey{
        case posts = "items"
    }
    
}
