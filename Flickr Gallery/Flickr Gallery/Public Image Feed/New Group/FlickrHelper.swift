//
//  FlickrHelper.swift
//  Flickr Gallery
//
//  Created by Sebastian Waloszek on 13/08/2017.
//  Copyright © 2017 Sebastian Waloszek. All rights reserved.
//

import Foundation

class FlickrHelper{
    
    // MARK: Sorting posts
    enum Sorting:Int{
        case byDatePublished
        case byDateTaken
    }
    
    //Sort the posts by date
    static func sortDateDescending(posts:[FlickrPost], by sorting:Sorting) -> [FlickrPost]{
        var sortedPosts = [FlickrPost]()
        
        switch sorting {
        // Sort the posts by newest publish date
        case Sorting.byDatePublished:
            sortedPosts = posts.sorted(by: {$0.publishedDate > $1.publishedDate })
            
        // Sort the posts by newest photo taken date
        case Sorting.byDateTaken:
            sortedPosts = posts.sorted(by: {$0.photoTakenDate > $1.photoTakenDate })
        }
        
        return sortedPosts
    }
    
}
