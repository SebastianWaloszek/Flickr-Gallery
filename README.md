# Flickr-Gallery
A simple Flicker gallery app developed using Swift 4 and Xcode 9 beta 5.

Implementing features:
- Uses new Swift 4 JSON parsing
- For cashing and asynchronous  image downloading the SDWebImage API was used

App functionality:
- Show posts from Flickr's public feed
- Search for posts by given tag
- Order posts by date the photo was taken or post's published date
- Save image in System Gallery
- Open image in browser
- Share picture by email

Known issues:
- Sometimes the format of the requested JSON causes the JSON decoder to fail with the message: "The data couldn’t be read because it isn’t in the correct format."
Possible fix:
- A JSON formatting method must be implemented.
