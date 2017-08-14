//
//  ImageSavingHelperTests.swift
//  Flickr GalleryTests
//
//  Created by Sebastian Waloszek on 14/08/2017.
//  Copyright © 2017 Sebastian Waloszek. All rights reserved.
//

import XCTest
@testable import Flickr_Gallery

class ImageSavingHelperTests: XCTestCase {
    
    func testAlerts() {
        // Check the returned alert for successfull image saving
        XCTAssertNotNil(ImageSavingHelper.successfullSavingAlert,"Returned alert should not be nil")
        
        // Check the returned alert for unsuccessfull image saving
        XCTAssertNotNil(ImageSavingHelper.failedSavingAlert,"Returned alert should not be nil")
    }
    
}
