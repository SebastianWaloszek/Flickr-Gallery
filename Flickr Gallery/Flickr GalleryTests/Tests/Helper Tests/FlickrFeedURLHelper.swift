//
//  FlickrURLHelperTests.swift
//  Flickr GalleryTests
//
//  Created by Sebastian Waloszek on 13/08/2017.
//  Copyright © 2017 Sebastian Waloszek. All rights reserved.
//

import XCTest
@testable import Flickr_Gallery

class FlickrFeedURLHelper: XCTestCase {
    
    // Check if call to Flickr API succedes for given URL
    func testAsynchronousURLConnectionToFlickrAPI() {
        let url = URL(string: "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1")!
        let urlExpectation = expectation(description: "Should get JSON data from URL")
        
        // Try to get data from given URL
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // Check the received data
            XCTAssertNotNil(data, "data should not be nil")
            
            // Check if an error occurred
            XCTAssertNil(error, "error should be nil")
            
            if let response = response as? HTTPURLResponse,
                let responseURL = response.url,
                let mimeType = response.mimeType
            {
                // Check the response URL
                XCTAssertEqual(responseURL.absoluteString, url.absoluteString, "HTTP response URL should be equal to original URL")
                
                // Check the response code
                XCTAssertEqual(response.statusCode, 200, "HTTP response status code should be 200")
                
                // Check if the content type is JSON
                XCTAssertEqual(mimeType, "application/json", "HTTP response content type should be application/json")
            } else {
                XCTFail("Response was not NSHTTPURLResponse")
            }
            urlExpectation.fulfill()
        }
        
        task.resume()
        
        // Wait for expectation and cancel task if timeout occurres
        waitForExpectations(timeout: task.originalRequest!.timeoutInterval) { error in
            if let error = error {
                print(error.localizedDescription)
            }
            task.cancel()
        }
    }
    
}
