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

// MARK: IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dateSortingControl: UISegmentedControl!

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
    
    // For refreshing and getting new posts from flickr feed
    private var postsRefresher = UIRefreshControl(){
        // Set up the refresher and it to the subview
        didSet{
            postsRefresher.tintColor = UIColor.white
            postsRefresher.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)
            collectionView?.addSubview(postsRefresher)
        }
    }
    
    // Get new posts,sort them and then end refreshing
    @objc func refreshPosts() {
        setPublicFeedPosts(forURLString: Constants.flickrPublicFeedString)
        sortPosts(bySortingIndex: dateSortingControl.selectedSegmentIndex)
        postsRefresher.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get and set the flickr posts from the public feed
        setPublicFeedPosts(forURLString: Constants.flickrPublicFeedString)
        
        // Initialize and set up the refresher
        postsRefresher = UIRefreshControl()
        
        // Make the segmented control look more square
        dateSortingControl.layer.borderColor = UIColor.white.cgColor
        dateSortingControl.layer.borderWidth = 1.5
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
            configureAsFLickrPost(theCell: flickrPostCell, atIndexPath: indexPath)
        }

        return cell
    }
    
    // Make the cell display flickr post contents
    private func configureAsFLickrPost(theCell cell:FlickerPostCollectionViewCell,atIndexPath indexPath:IndexPath){
        
        // Get the flickr post atIndexPath
        let post = flickrPosts[indexPath.item]
        
        // Set the flickr post's image
         cell.photoImageView.sd_setImage(with: post.media["m"], completed: nil)
        
        // Remove the unnessery parts of the author string
        let authorString = post.author!.replacingOccurrences(
            of: "nobody@flickr.com (\"",
            with: ""
            ).replacingOccurrences(
                of: "\")",
                with: ""
        )
        
        // Set the post's author
        cell.postAuthorLabel.text = "\(authorString)"
        
        // Set the post's published date
        cell.datePublishedLabel.text = "Published: \(post.publishedDate.toFormattedString())"

        // Set the date on which the photo was taken
        cell.dateTakenLabel.text = "Taken: \(post.photoTakenDate.toFormattedString())"
        
        // Set the post's tags
        cell.tagsLabel.text = "\(post.tags)"
        
        // Set up the shareButton to display the action sheet for given cell
        cell.shareButton.tag = indexPath.row
        cell.shareButton.addTarget(self, action: #selector(self.shareButtonPressed(sender:)), for: .touchUpInside)
    }
    
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
            self.sendMail(withImage: imageURL)
        }))
        
        // Dismiss the actionSheet
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

// MARK: MFMailCompose
extension FlickrPostCollectionViewController: MFMailComposeViewControllerDelegate{
    
    // Send email with image under given url
    func sendMail(withImage imageURL: URL) {
        // Check if email can be send
        if MFMailComposeViewController.canSendMail() {
            // Create viewController for sending email
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self;
            
            do{
                // Get the image data from the url
                let imageData = try Data(contentsOf: imageURL)
                
                // Get image name from url
                let imageURLWithoutExt = imageURL.deletingPathExtension()
                let imageName = imageURLWithoutExt.lastPathComponent
                
                // Attach image to email
                mail.addAttachmentData(imageData,
                                       mimeType: "image/jpg",
                                       fileName: imageName
                )
                
                // Present the email sending view
                self.present(mail, animated: true, completion: nil)
                
            }catch let imageDataError{
                print(imageDataError.localizedDescription)
            }
        }
    }
    
    // Hide the email sending view after sending email
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
// MARK: Date - Extension
extension Date{
    // Return the date as string in dd/MM/yyyy format
    func toFormattedString () -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        return dateFormatter.string(from: self)
    }
}

