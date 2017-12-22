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
    
    func retrieveImages(handler: @escaping (_ status: Bool) -> ()) {
        
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
