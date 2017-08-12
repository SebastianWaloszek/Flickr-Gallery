//
//  FlickerPostCollectionViewCell.swift
//  Flickr Gallery
//
//  Created by Sebastian Waloszek on 10/08/2017.
//  Copyright © 2017 Sebastian Waloszek. All rights reserved.
//

import UIKit

class FlickerPostCollectionViewCell: UICollectionViewCell {
    
    // MARK: IBOutlets
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
    
    
    // MARK: Set-up
    // Make the cell display flickr post contents
    func setUpCell(asFLickrPost post:FlickrPost){
        
        // Set the flickr post's image
        photoImageView.sd_setImage(with: post.media["m"], completed: nil)
        
        // Remove the unnessery parts of the author string
        let authorString = post.author!.replacingOccurrences(
            of: "nobody@flickr.com (\"",
            with: ""
            ).replacingOccurrences(
                of: "\")",
                with: ""
        )
        
        // Set the post's author
        postAuthorLabel.text = "\(authorString)"
        
        // Set the post's published date
        datePublishedLabel.text = "Published: \(post.publishedDate.toFormattedString())"
        
        // Set the date on which the photo was taken
        dateTakenLabel.text = "Taken: \(post.photoTakenDate.toFormattedString())"
        
        // Set the post's tags
        tagsLabel.text = "\(post.tags)"
    }
}

