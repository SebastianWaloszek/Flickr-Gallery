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

    // Name of the post's author
    let author: String?

}

