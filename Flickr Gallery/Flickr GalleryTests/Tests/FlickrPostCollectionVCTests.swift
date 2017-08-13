//
//  Flickr_GalleryTests.swift
//  Flickr GalleryTests
//
//  Created by Sebastian Waloszek on 10/08/2017.
//  Copyright © 2017 Sebastian Waloszek. All rights reserved.
//

import XCTest
@testable import Flickr_Gallery

class FlickrPostCollectionVCTests: XCTestCase {
    
    // MARK: Variables
    var viewController: FlickrPostCollectionViewController!
    var collectionView: UICollectionView!
    
    override func setUp() {
        super.setUp()
        
        //Get the tested viewController from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "FlickrPostsVC") as! FlickrPostCollectionViewController
        
        // Trigger view load 
        _ = viewController.view
        
        collectionView = viewController.collectionView
        
    }
    // MARK: ViewController tests
    //Check if the viewController was initialized
    func testCanInstantiateViewController(){
        XCTAssertNotNil(viewController,"The controllerViewController wasn't initialized")
    }
    
    //Check the searchbar's delagate
    func testHasSearchBarDelegate() {
        XCTAssertNotNil(viewController.searchBar.delegate,"The searchBar has no delegate")
        XCTAssertTrue(viewController === viewController.searchBar.delegate, "The viewController isn't searchbar's delegate")
    }
    
    // MARK: CollectionView tests
    //Check if the collectionView was initialized
    func testCanInstantiateCollectionView(){
        XCTAssertNotNil(collectionView,"The collectionView wasn't initialized")
    }
    
    //Check the collectionView's dataSource
    func testHasCollectionDataSource() {
        XCTAssertNotNil(collectionView.dataSource,"The collectionView has no dataSource")
        XCTAssertTrue(viewController === collectionView.dataSource, "The viewController isn't collectionView's dataSource")
    }
    
    //Check the collectionView's delegate
    func testHasCollectionDelegate() {
        XCTAssertNotNil(collectionView.delegate,"The collectionView has no delegate")
        XCTAssertTrue(viewController === collectionView.delegate, "The viewController isn't collectionView's delegate")
    }
    
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
