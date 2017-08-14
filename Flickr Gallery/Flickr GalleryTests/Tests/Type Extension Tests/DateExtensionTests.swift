//
//  DateExtensionTests.swift
//  Flickr GalleryTests
//
//  Created by Sebastian Waloszek on 14/08/2017.
//  Copyright © 2017 Sebastian Waloszek. All rights reserved.
//

import XCTest
@testable import Flickr_Gallery

class DateExtensionTests: XCTestCase {
    
    // Check if date is correctly formated into a string
    func testFormattedString(){
        
        let minute:TimeInterval = 60.0
        let hour:TimeInterval = 60.0 * minute
        let day:TimeInterval = 24 * hour
        
        let date = Date(timeIntervalSince1970: day)
        
        let dateFormattedString = date.toFormattedString()
        
        XCTAssertEqual(dateFormattedString, "02/01/1970", "Date was incorrectly formated to String")
    }
    
}
