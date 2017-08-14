//
//  StringExtensionTests.swift
//  Flickr GalleryTests
//
//  Created by Sebastian Waloszek on 14/08/2017.
//  Copyright © 2017 Sebastian Waloszek. All rights reserved.
//

import XCTest
@testable import Flickr_Gallery

class StringExtensionTests: XCTestCase {
    
    // Check if function returns the first word from string
    func testfirstWordFromString(){
        
        let firstWord = "first"
        let words = "\(firstWord) second third"
        
        XCTAssertEqual(words.firstWord, firstWord, "Function didn't return first word from string")
    }
    
}
