//
//  Flickr_GalleryTests.swift
//  Flickr GalleryTests
//
//  Created by Sebastian Waloszek on 10/08/2017.
//  Copyright © 2017 Sebastian Waloszek. All rights reserved.
//

import XCTest
@testable import Flickr_Gallery

class PublicFeedCollectionViewControllerTests: XCTestCase {
    
    // MARK: Variables
    var viewController: PublicFeedCollectionViewController!
    var collectionView: UICollectionView!
    
    override func setUp() {
        super.setUp()
        
        //Get the tested viewController from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "FlickrPostsVC") as! PublicFeedCollectionViewController
        
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
    
    
}
