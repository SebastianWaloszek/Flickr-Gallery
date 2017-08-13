//
//  StringExtension.swift
//  Flickr Gallery
//
//  Created by Sebastian Waloszek on 13/08/2017.
//  Copyright © 2017 Sebastian Waloszek. All rights reserved.
//

import Foundation

extension String{
    // Return the first word of a string
    var firstWord:String?{
        get{
            return self.components(separatedBy: " ").first
        }
    }
}
