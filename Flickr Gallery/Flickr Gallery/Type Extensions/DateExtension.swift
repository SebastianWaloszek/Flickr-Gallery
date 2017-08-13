//
//  DateExtension.swift
//  Flickr Gallery
//
//  Created by Sebastian Waloszek on 12/08/2017.
//  Copyright © 2017 Sebastian Waloszek. All rights reserved.
//

import Foundation

extension Date{
    // Return the date as string in dd/MM/yyyy format
    func toFormattedString () -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        return dateFormatter.string(from: self)
    }
}
