//
//  ImageSavingHelper.swift
//  Flickr Gallery
//
//  Created by Sebastian Waloszek on 13/08/2017.
//  Copyright © 2017 Sebastian Waloszek. All rights reserved.
//

import Foundation
import UIKit

class ImageSavingHelper{
    
    // MARK: Alert variables
    static var successfullSavingAlert:UIAlertController{
        get{
            let alert = UIAlertController(title: "Saved!", message: "Image saved successfully", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            return alert
        }
    }
    
    static var failedSavingAlert:UIAlertController{
        get{
            let alert = UIAlertController(title: "Error!", message: "Image wasn't saved", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            return alert
        }
    }
    
    // MARK: Saving
    static func saveImageToGallery(withURL imageURL:URL) -> Bool{
        do {
            let imageData = try Data(contentsOf: imageURL)
            if let image = UIImage(data: imageData){
                // Save the image to system gallery
                UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
                return true
            }
        }catch let imageDataError{
            print(imageDataError.localizedDescription)
            return false
        }
        return false
    }
}
