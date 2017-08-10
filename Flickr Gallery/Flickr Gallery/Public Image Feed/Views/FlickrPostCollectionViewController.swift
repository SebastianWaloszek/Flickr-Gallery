//
//  FlickrPostCollectionViewController.swift
//  Flickr Gallery
//
//  Created by Sebastian Waloszek on 10/08/2017.
//  Copyright © 2017 Sebastian Waloszek. All rights reserved.
//

import UIKit

class FlickrPostCollectionViewController: UICollectionViewController {

// MARK: Constants
    private struct Constants {
        // Identifier for the reusable cell in the collection view
        static let cellReuseIdentifier = "FlickrPostCell"
        
        // The number of sections in the collection view
        static let numberOfSections = 1
        
        // The number of sections in the collection view for testing purposes.
        static let numberOfItemsInSection = 3
    }
    
    
// MARK: UICollectionViewDataSource
    
    //Return the number of sections in the collection view
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Constants.numberOfSections
    }

    //Return the number of items in the collection view
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.numberOfItemsInSection
    }

    //Return the cell for a given index
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Get the cell from the collectionView using the specified identifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellReuseIdentifier, for: indexPath)
    
        //Check if the cell can be casted to custom class
        if let flickrPostCell = cell as? FlickerPostCollectionViewCell{
            // Configure the cell
            
            //Change the cell's image backgroundColor for testing purposes
            flickrPostCell.photoImageView.backgroundColor = UIColor.red
            //Change the post's author label for testing purposes
            flickrPostCell.postAuthorLabel.text = "Author #\(indexPath.item)"
        }

        return cell
    }
}
