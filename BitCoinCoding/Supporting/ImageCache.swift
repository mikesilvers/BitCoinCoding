//
//  ImageCache.swift
//  BitCoinCoding
//
//  Created by Mike Silvers on 5/29/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import UIKit
import Foundation

/// The image cache used throughout the project
let imageCache = NSCache<AnyObject, AnyObject>()

// MARK - UIImageView extensions
extension UIImageView {
    
    // MARK: - Cache maintenance functions
    
    /**
     Clears the image cache
     
     Allows for the clearing of the image cache using an array of image URL's to clear specific images or `nil` to clear all imabes in the cache.
     - Parameter urlStrings: An optional array of strings representing the URL for each image to be cleared out of the cache.  If the array is omitted, all images in the cache are cleared.
     */
    func clearImageCache(_ urlStrings: [String]? = nil) {
        
        if urlStrings == nil || urlStrings?.count == 0 {
            imageCache.removeAllObjects()
        } else {
            for x in urlStrings! {
                imageCache.removeObject(forKey: x as AnyObject)
            }
        }
        
    }
    
    // MARK: - Caching functions
    /**
     Adds images to the image cache
     
     The image cache is used to prevent redownloading of images every time you view an image.  This is especially useful when cells with images are displayed.  Without caching, images would be downloaded every time and casuse "jumpiness" to the scroll of the cells.
     
     - Parameter urlString: the URL of the image represented by a string.  The image is keyed by this value in the cache.
     - Parameter forceDownload: `true` will force the image to be downloaded (even if it is currently in the cache).  The default `false` will check the cache and download the image if it is not in the cache.
     */
    func cacheImage(_ urlString: String,_ forceDownload: Bool = false) {
        
        // check to see if the image is in the cache
        if !forceDownload, let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            
            // if the image is cached, return it
            // We check to see if we are in the main thread - this may not happen if this function is called
            // by an async process
            if Thread.isMainThread {
                self.image = cachedImage
                return
            } else {
                DispatchQueue.main.async {
                    self.image = cachedImage
                    return
                }
            }
        }
        
        // if the image has not been cached, cache it and set it
        if let imageURL = URL(string: urlString) {
            
            // perform the request for the image
            URLSession.shared.dataTask(with: imageURL, completionHandler: {(theData, theResponse, theError) in
                
                if let httpResponse = theResponse as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200...299:
                        if let id = theData,
                            let image = UIImage(data: id) {
                                // cache the newly found image
                                // note: no need to deal with threading in the cache - Apple takes care of
                                // cache locking and such so it is thread safe
                                imageCache.setObject(image as AnyObject, forKey: urlString as AnyObject)
                                // and display it
                                DispatchQueue.main.async {
                                    self.image = image
                                }
                        }
                    default:
                        // we are not doing much for a failure.  This print is mainly for debug purposes.
                        // in the future we may want to add some remote logging so we can see if there
                        // is a programatic issue or an issue with requests for non-existent images
                        if let e = theError {
                            print("Request failed: \(e)")
                        }
                    }
                }
                
            }).resume()
        }
    }
}
