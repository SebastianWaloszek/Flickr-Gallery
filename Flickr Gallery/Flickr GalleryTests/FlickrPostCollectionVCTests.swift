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
    var collectionViewController: FlickrPostCollectionViewController!
    var collectionView: UICollectionView!
    
    override func setUp() {
        super.setUp()
        
        //Get the tested viewController from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        collectionViewController = storyboard.instantiateViewController(withIdentifier: "FlickrPostsVC") as! FlickrPostCollectionViewController
        
        // Trigger view load 
        _ = collectionViewController.view
        
        collectionView = collectionViewController.collectionView
        
    }
    
    //Check if the viewController was initialized
    func testCanInstantiateViewController(){
        XCTAssertNotNil(collectionViewController,"The controllerViewController wasn not initialized")
    }
    
    // MARK: CollectionView tests
    //Check if the collectionView was initialized
    func testCanInstantiateCollectionView(){
        XCTAssertNotNil(collectionView,"The collectionView wasn not initialized")
    }
    
    //Check if the collectionView has a dataSource
    func testHasCollectionDataSource() {
        XCTAssertNotNil(collectionView.dataSource,"The collectionView has no dataSource")
    }
    
    //Check if the collectionView has a delegate
    func testHasCollectionDelegate() {
        XCTAssertNotNil(collectionView.delegate,"The collectionView has no delegate")
    }
    
}
