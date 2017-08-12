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

class FlickrPostCollectionViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

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
    
    // MARK: Constants
    private struct Constants {
        // Identifier for the reusable cell in the collection view
        static let cellReuseIdentifier = "FlickrPostCell"
        
        // The number of sections in the collection view
        static let numberOfSections = 1
        
        // The url of the public feed flickr posts in json format
        static let flickrPublicFeedString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"
    }
    
    // MARK: Searching by tag
    @objc private func searchForPosts() {
        
        // If no tag was given search for posts without any criteria
        guard let singleTag = searchBar.text?.components(separatedBy: " ").first else{
            setPublicFeedPosts(forURLString:  Constants.flickrPublicFeedString)
            return
        }
    
        // Prepare URL and search for posts with given tag
        let searchURL = Constants.flickrPublicFeedString + "&tags=\(singleTag)"
        setPublicFeedPosts(forURLString:  searchURL)
    }
    
    // MARK: Refreshing
    // For refreshing and getting new posts from flickr feed
    private var postsRefresher = UIRefreshControl(){
        // Set up the refresher and add it to the subview
        didSet{
            postsRefresher.tintColor = UIColor.white
            postsRefresher.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)
        }
    }
    
    // Get new posts,sort them and then end refreshing
    @objc func refreshPosts() {
        searchForPosts()
        postsRefresher.endRefreshing()
    }
    // MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Search and get flickr posts from the public feed
        searchForPosts()
        
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
        
        // Set search bar's delegate
        searchBar.delegate = self
        
        // Hide the keyboard when user touches the screen
        hideKeyboardWhenTappedAround()

    }

    // MARK: Sorting posts
    private enum Sorting:Int{
        case byDatePublished
        case byDateTaken
    }
    
    // Sort the posts after the sorting mode was changed
    @IBAction func changePostsSorting(_ sender: UISegmentedControl) {
        sortPosts(bySortingIndex: sender.selectedSegmentIndex)
    }
    
    //Sort the posts by date
    private func sortPosts(bySortingIndex sortingIndex:Int){
        switch sortingIndex {
        // Sort the posts by newest publish date
        case Sorting.byDatePublished.rawValue:
            flickrPosts = flickrPosts.sorted(by: {$0.publishedDate > $1.publishedDate })
            
         // Sort the posts by newest photo taken date
        case Sorting.byDateTaken.rawValue:
            flickrPosts = flickrPosts.sorted(by: {$0.photoTakenDate > $1.photoTakenDate })
            
        default:
            break
        }
    }
    
    // MARK: UICollectionViewDataSource
    //Return the number of sections in the collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Constants.numberOfSections
    }

    //Return the number of items in the collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flickrPosts.count
    }

    //Return the cell for a given index
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        //Get the cell from the collectionView using the specified identifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellReuseIdentifier, for: indexPath)

        //Check if the cell can be casted to custom class
        if let flickrPostCell = cell as? FlickerPostCollectionViewCell{
            // Set up the cell visualy
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
            self.saveToPhotoGallery(imageAtURL: imageURL)
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
        
        // Dismiss the actionSheet
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Show the action sheet
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func saveToPhotoGallery(imageAtURL imageURL:URL){
        do {
            let imageData = try Data(contentsOf: imageURL)
            if let image = UIImage(data: imageData){
                // Save the image to system gallery
                UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
                
                // Inform the user that image was succesfully saved
                let alert = UIAlertController(title: "Saved!", message: "Image saved successfully", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }catch let imageDataError{
            print(imageDataError.localizedDescription)
        }
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
                
                // Take the task of setting and sorting the flickr posts to the main queue
                DispatchQueue.main.async {
                    self?.flickrPosts = websiteDescription.posts
                    self?.sortPosts(bySortingIndex: (self?.dateSortingControl?.selectedSegmentIndex)!)
                }

            }catch let jsonError{
                print(jsonError.localizedDescription)
            }
            
        }).resume()
    }
}

// MARK: SearchBarDelegate
// Handle the searchBar events
extension FlickrPostCollectionViewController: UISearchBarDelegate{
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
        searchForPosts()
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
}




