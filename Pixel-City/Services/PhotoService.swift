//
//  PhotoService.swift
//  Pixel-City
//
//  Created by Tiago Santos on 22/12/17.
//  Copyright © 2017 Tiago Santos. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class PhotoService {
    
    func retrieveUrls(forAnnotation annotation: DroppablePin, handler: @escaping (_ urlArray: [String]) -> ()) {
        Alamofire.request(flickrUrl(forApiKey: FlickrApiKey, withAnnotation: annotation, andNumberOfPhotos: 40)).responseJSON { (response) in
            let photoUrls = self.appendUrlsToImageArray(response: response)
            handler(photoUrls)
        }
    }
    
    func retrieveImages(imageUrlArray: [String], progressLabel: UILabel, handler: @escaping (_ imageArray: [UIImage]) -> ()) {
        var imageArray = [UIImage]()
        
        for url in imageUrlArray {
            Alamofire.request(url).responseImage(completionHandler: { (response) in
                guard let image = response.result.value else { return }
                imageArray.append(image)
                progressLabel.text = "\(imageArray.count)/\(imageUrlArray.count) IMAGES DOWNLOADED"
                
                if imageArray.count == imageUrlArray.count {
                    handler(imageArray)
                }
            })
        }
    }
    
    func appendUrlsToImageArray(response: DataResponse<Any>) -> [String] {
        guard let json = response.result.value as? JSON else { return [String]()}
        guard let photoDictionary = json["photos"] as? JSON else { return [String]()}
        guard let photos = photoDictionary["photo"] as? [JSON] else { return [String]()}
        var imageUrlArray = [String]()
        
        for photo in photos {
            let postUrl = "https://farm\(photo["farm"]!).staticflickr.com/\(photo["server"]!)/\(photo["id"]!)_\(photo["secret"]!)_h_d.jpg"
            imageUrlArray.append(postUrl)
        }
        return imageUrlArray
    }
}
