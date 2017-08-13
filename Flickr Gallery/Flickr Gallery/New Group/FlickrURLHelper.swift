//
//  FlickrFeedURLHelperDelegate.swift
//  Flickr Gallery
//
//  Created by Sebastian Waloszek on 13/08/2017.
//  Copyright © 2017 Sebastian Waloszek. All rights reserved.
//

import Foundation

protocol FlickrFeedURLHelperDelegate: class{
    func didFinishURLRequest(withPosts posts:[FlickrPost])
}

// MARK: URLSession
class FlickrFeedURLHelper{
    
    weak var delegate:FlickrFeedURLHelperDelegate?
    
    // The url of the public feed flickr posts in json format
    private let flickrPublicFeedString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"
    
    // Get and set the flickr posts from the public feed
    func getPublicFeedPosts(withTag tag:String?){
        
        var searchURL = flickrPublicFeedString
        
        // If tag was given adding it to the URL
        if let searchTag = tag{
             searchURL += "&tags=\(searchTag)"
        }
     
        // Try creating URL from given string
        guard let flickrPublicFeedURL = URL(string: searchURL) else {
            print("Error while creating URL from String")
            return
        }
        
        // Create a dataTask to get the flickr public feed data
        URLSession.shared.dataTask(with: flickrPublicFeedURL, completionHandler: {(data, response, error) in
            
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
                
                // Take the delegate task to the main queue
                DispatchQueue.main.async {
                    self.delegate?.didFinishURLRequest(withPosts: websiteDescription.posts)
                }
                
            }catch let jsonError{
                print(jsonError.localizedDescription)
            }
            
        }).resume()
    }
}
