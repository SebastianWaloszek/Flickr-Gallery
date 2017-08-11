//
//  FlickrPostCollectionViewController.swift
//  Flickr Gallery
//
//  Created by Sebastian Waloszek on 10/08/2017.
//  Copyright © 2017 Sebastian Waloszek. All rights reserved.
//

import UIKit

class FlickrPostCollectionViewController: UICollectionViewController {

// MARK: Model
    var flickrPosts = [FlickrPost](){
        //Reload the collectionView when new posts where set
        didSet{
            self.collectionView?.reloadData()
        }
    }
    
// MARK: Constants
    private struct Constants {
        // Identifier for the reusable cell in the collection view
        static let cellReuseIdentifier = "FlickrPostCell"
        
        // The number of sections in the collection view
        static let numberOfSections = 1
        
        // The url of the public feed flickr posts in json format
        static let flickrPublicFeedString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"
    }
    
// MARK: Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get and set the flickr posts from the public feed
        setPublicFeedPosts(forURLString: Constants.flickrPublicFeedString)
    }

// MARK: UICollectionViewDataSource
    
    //Return the number of sections in the collection view
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Constants.numberOfSections
    }

    //Return the number of items in the collection view
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flickrPosts.count
    }

    //Return the cell for a given index
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Get the cell from the collectionView using the specified identifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellReuseIdentifier, for: indexPath)
    
        //Check if the cell can be casted to custom class
        if let flickrPostCell = cell as? FlickerPostCollectionViewCell{
            configureAsFLickrPost(theCell: flickrPostCell, atIndexPath: indexPath)
        }

        return cell
    }
    
    // Make the cell display flickr post contents
    private func configureAsFLickrPost(theCell cell:FlickerPostCollectionViewCell,atIndexPath indexPath:IndexPath){
        // Set the flickr post's image
        do{
            let imageData = try Data(contentsOf: flickrPosts[indexPath.item].media["m"]!)
            cell.photoImageView.image = UIImage(data: imageData)
        }
        catch let imageDataError{
            print(imageDataError.localizedDescription)
        }
        
        // Remove the unnessery parts of the author string
        let authorString = flickrPosts[indexPath.item].author!.replacingOccurrences(
            of: "nobody@flickr.com (\"",
            with: ""
            ).replacingOccurrences(
                of: "\")",
                with: ""
        )
        
        // Change the post's author label
        cell.postAuthorLabel.text = "\(authorString)"
        
        // Set up the shareButton to display the action sheet for given cell
        cell.shareButton.tag = indexPath.row
        cell.shareButton.addTarget(self, action: #selector(self.shareButtonPressed(sender:)), for: .touchUpInside)
    }
    
    // Display the action sheed the the shareButton is pressed
    @objc func shareButtonPressed(sender: UIButton){
        // Prepare a blank actionSheet
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Add actions
        actionSheet.addAction(UIAlertAction(title: "Save image", style: .default, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Open image in browser", style: .default, handler: { (action) in
            
            // Check and open the image url in the browser
            guard let url = self.flickrPosts[sender.tag].media["m"] else {
                print("Invalid image URL")
                return
            }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }

        }))
        actionSheet.addAction(UIAlertAction(title: "Share image by email", style: .default, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Show the action sheet
        present(actionSheet, animated: true, completion: nil)
    }
    
    
}
// MARK: URLSession
extension FlickrPostCollectionViewController{
    
    // Get and set the flickr posts from the public feed
    func setPublicFeedPosts(forURLString urlString:String){
        
        // Try creating and URL from given string
        guard let flickrPublicFeedURL = URL(string: urlString) else {
            print("Error while creating URL from String")
            return
        }
        
        // Create a dataTask to get the flickr public feed data
        URLSession.shared.dataTask(with: flickrPublicFeedURL, completionHandler: { [weak self] (data, response, error) in
            
            // Check if data isn't nil
            guard let data = data else{
                print("Data is nil")
                return
            }
            
            do{
                // Set up the json decoder
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                
                // Try to decode json from the aquired data
                let websiteDescription = try jsonDecoder.decode(FlickrWebsiteDescription.self, from: data)
                
                // Take the task of setting the flickr posts to the main queue
                DispatchQueue.main.async {
                    self?.flickrPosts = websiteDescription.posts
                }

            }catch let jsonError{
                print(jsonError.localizedDescription)
            }
            
        }).resume()
    }
    
}

