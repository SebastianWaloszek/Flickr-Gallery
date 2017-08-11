//
//  FlickerPostCollectionViewCell.swift
//  Flickr Gallery
//
//  Created by Sebastian Waloszek on 10/08/2017.
//  Copyright © 2017 Sebastian Waloszek. All rights reserved.
//

import UIKit

class FlickerPostCollectionViewCell: UICollectionViewCell {
    
    // Displays photo in flickr post
    @IBOutlet weak var photoImageView: UIImageView!

    // Displays the name of the author of the flickr post
    @IBOutlet weak var postAuthorLabel: UILabel!
    
    // Displays the date the photo was taken
    @IBOutlet weak var dateTakenLabel: UILabel!
    
    // Displays the date the photo was published
    @IBOutlet weak var datePublishedLabel: UILabel!
    
    // Displays the post's tags
    @IBOutlet weak var tagsLabel: UILabel!
    
    // Button for sharing post's contents
    @IBOutlet weak var shareButton: UIButton!
}
