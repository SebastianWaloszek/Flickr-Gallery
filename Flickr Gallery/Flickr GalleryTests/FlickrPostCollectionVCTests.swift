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
    
    //Check if the viewController was instantiated
    func testCanInstantiateViewController(){
        XCTAssertNotNil(collectionViewController)
    }
    
    //Check if the collectionView was instantiated
    func testCanInstantiateCollectionView(){
        XCTAssertNotNil(collectionView)
    }
    
    //Check if the collectionView has a dataSource
    func testHasDataSource() {
        XCTAssertNotNil(collectionView.dataSource)
    }
}
