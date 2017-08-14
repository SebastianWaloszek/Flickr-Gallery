//
//  UIViewControllerTests.swift
//  Flickr GalleryTests
//
//  Created by Sebastian Waloszek on 14/08/2017.
//  Copyright © 2017 Sebastian Waloszek. All rights reserved.
//

import XCTest
@testable import Flickr_Gallery

class UIViewControllerExtensionTests: XCTestCase {
    
    // Check if gesture recognizer for keyboard dismiss was added to view
    func testGestureRecognizerAdded(){
        
        let viewController = UIViewController()
        viewController.hideKeyboardWhenTappedAround()
        
        XCTAssertNotNil(viewController.view.gestureRecognizers, "Gesture recognized was not added to view")
        
    }
    
}
