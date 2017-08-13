//
//  MailViewController.swift
//  Flickr Gallery
//
//  Created by Sebastian Waloszek on 12/08/2017.
//  Copyright © 2017 Sebastian Waloszek. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class MailHelperViewController: UIViewController,MFMailComposeViewControllerDelegate{
    
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
