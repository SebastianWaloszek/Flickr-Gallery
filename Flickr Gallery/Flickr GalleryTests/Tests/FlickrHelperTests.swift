//
//  FlickrHelperTests.swift
//  Flickr GalleryTests
//
//  Created by Sebastian Waloszek on 13/08/2017.
//  Copyright © 2017 Sebastian Waloszek. All rights reserved.
//

import XCTest
@testable import Flickr_Gallery

class FlickrHelperTests: XCTestCase {
    
    // FlickrHelper tests
    //Check if the posts sorting is correct
    func testPostDateSorting() {
        
        // Create a yesterday's post
        let postWithYesterdayDates = FlickrPost(
            media: [String():URL(string: "https://dummyimage.com/600x400/000/fff")!],
            photoTakenDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            publishedDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            author: String(),
            tags: String()
        )
        
        // Create a today's post
        let postWithTodayDates = FlickrPost(
            media: [String():URL(string: "https://dummyimage.com/600x400/000/fff")!],
            photoTakenDate: Date(),
            publishedDate: Date(),
            author: String(),
            tags: String()
        )
        
        let posts = [postWithYesterdayDates,postWithTodayDates]
        
        // Sort the dates by date published
        var sortedPosts = FlickrHelper.sortDateDescending(posts: posts, by: FlickrHelper.Sorting.byDatePublished)
        
        XCTAssert(sortedPosts[0].publishedDate > sortedPosts[1].publishedDate, "Publish dates were not ordered descendingly")
        
        // Sort the dates by date photo was taken
        sortedPosts = FlickrHelper.sortDateDescending(posts: posts, by: FlickrHelper.Sorting.byDateTaken)
        
        XCTAssert(sortedPosts[0].photoTakenDate > sortedPosts[1].photoTakenDate, "Photo taken dates were not ordered descendingly")
        
    }
    
}
