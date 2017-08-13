//
//  UIViewControllerExtension.swift
//  Flickr Gallery
//
//  Created by Sebastian Waloszek on 12/08/2017.
//  Copyright © 2017 Sebastian Waloszek. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    // Add a gesture recognizer for keyboard dismissing
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.resignFirstResponder))
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
}
