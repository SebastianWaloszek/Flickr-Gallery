//
//  FlickrPostCollectionViewController.swift
//  Flickr Gallery
//
//  Created by Sebastian Waloszek on 10/08/2017.
//  Copyright © 2017 Sebastian Waloszek. All rights reserved.
//

import UIKit
import MessageUI
import SDWebImage

class PublicFeedCollectionViewController: UIViewController,UICollectionViewDataSource {

    // MARK: IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dateSortingControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: Model
    var flickrPosts = [FlickrPost](){
        //Reload the collectionView when new posts where set
        didSet{
            self.collectionView?.reloadData()
        }
    }
    
    // MARK: Helpers
    var flickrURLHelper = FlickrFeedURLHelper(){
        didSet{
            flickrURLHelper.delegate = self
        }
    }
    
    // MARK: Constants
    private struct Constants {
        // Identifier for the reusable cell in the collection view
        static let cellReuseIdentifier = "FlickrPostCell"
    }
    
    // MARK: Refreshing
    // For refreshing and getting new posts from flickr feed
    private var postsRefresher = UIRefreshControl(){
        // Set up the refresher and add it action to get new posts
        didSet{
            postsRefresher.tintColor = UIColor.white
            postsRefresher.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)
        }
    }
    
    // Get new posts,sort them and then end refreshing
    @objc func refreshPosts() {
        flickrURLHelper.getPublicFeedPosts(withTag: searchBar.text?.firstWord)
        postsRefresher.endRefreshing()
    }
    
    // IBActions
    // Sort the posts after user changed the sorting mode
    @IBAction func changePostsSorting(_ sender: UISegmentedControl) {
        flickrPosts = FlickrSortingHelper.sortDateDescending(
            posts: flickrPosts,
            by: FlickrSortingHelper.Sorting(rawValue: sender.selectedSegmentIndex)!
        )
    }
    
    // MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize, set up and add the refresher
        postsRefresher = UIRefreshControl()
        collectionView?.addSubview(postsRefresher)
        
        // Make the segmented control look more square
        dateSortingControl.layer.borderColor = UIColor(
            red: 0,
            green: 123/255,
            blue: 255/255,
            alpha: 1
        ).cgColor
        dateSortingControl.layer.borderWidth = 1.5
        
        searchBar.delegate = self
        
        // Hide the keyboard when user touches the screen
        hideKeyboardWhenTappedAround()
        
        flickrURLHelper = FlickrFeedURLHelper()
        
        // Search and get flickr posts from the public feed
        flickrURLHelper.getPublicFeedPosts(withTag: searchBar.text?.firstWord)
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flickrPosts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        //Get the cell from the collectionView using the specified identifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellReuseIdentifier, for: indexPath)

        //Check if the cell can be casted to custom class
        if let flickrPostCell = cell as? FlickerPostCollectionViewCell{
            // Set up the cell visually
            flickrPostCell.setUpCell(asFLickrPost: flickrPosts[indexPath.item])
            
            // Configure the shareButton to display the action sheet for given cell
            flickrPostCell.shareButton.tag = indexPath.row
            flickrPostCell.shareButton.addTarget(self, action: #selector(self.shareButtonPressed(sender:)), for: .touchUpInside)
        }

        return cell
    }
    
    // MARK: Share button actions
    // Display the action sheed when the shareButton is pressed
    @objc func shareButtonPressed(sender: UIButton){
        
        // Check the image url
        guard let imageURL = self.flickrPosts[sender.tag].media["m"] else {
            print("Invalid image URL")
            return
        }
        
        // Prepare a blank actionSheet
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Add action to save image in device
        actionSheet.addAction(UIAlertAction(title: "Save image", style: .default, handler: { (action) in
            let alert:UIAlertController?
            if ImageSavingHelper.saveImageToGallery(withURL: imageURL){
                // Inform the user that image was succesfully saved
                alert = ImageSavingHelper.successfullSavingAlert
            } else{
                // Inform the user that image wasn't saved
                alert = ImageSavingHelper.failedSavingAlert
            }
            self.present(alert!, animated: true)
        }))
        
        // Add action to open image in browser
        actionSheet.addAction(UIAlertAction(title: "Open image in browser", style: .default, handler: { (action) in
            // Check and open the image url in the browser
            if UIApplication.shared.canOpenURL(imageURL) {
                UIApplication.shared.open(imageURL, options: [:], completionHandler: nil)
            }
        }))
        
        // Add action to send an email with the image
        actionSheet.addAction(UIAlertAction(title: "Share image by email", style: .default, handler: { (action) in
            // Send the image using the image's url
            let mailViewController = MailHelperViewController()
            self.addChildViewController(mailViewController)
            mailViewController.sendMail(withImage: imageURL)
        }))
        
        // Add action to dismiss the actionSheet
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Show the action sheet
        present(actionSheet, animated: true, completion: nil)
    }
}
// MARK: FlickrFeedURLHelperDelegate
extension PublicFeedCollectionViewController: FlickrFeedURLHelperDelegate{
    // Sort and set the flickr posts after fetching them from public feed
    func didFinishURLRequest(withPosts posts: [FlickrPost]) {
        self.flickrPosts = FlickrSortingHelper.sortDateDescending(
            posts: posts,
            by: FlickrSortingHelper.Sorting(rawValue: self.dateSortingControl!.selectedSegmentIndex)!
        )
    }
}

// MARK: SearchBarDelegate
// Handle the searchBar events
extension PublicFeedCollectionViewController: UISearchBarDelegate{
    // Hide the keyboard and cancel button
    override func resignFirstResponder() -> Bool {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        return super.resignFirstResponder()
    }
    
    // React to user pressing the cancel button
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    // React to user starting to edit textfield
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    // Search for posts when user
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        flickrURLHelper.getPublicFeedPosts(withTag: searchBar.text?.firstWord)
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
}




