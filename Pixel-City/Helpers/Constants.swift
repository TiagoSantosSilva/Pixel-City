//
//  Constants.swift
//  Pixel-City
//
//  Created by Tiago Santos on 22/12/17.
//  Copyright © 2017 Tiago Santos. All rights reserved.
//

import Foundation

typealias JSON = [String: AnyObject]

let FlickrApiKey = "c649831ffb6122070cdde91bcdcfedf0"
let DroppablePinReuseIdentifier = "droppablePin"
let PhotoCellReuseIdentifier = "photoCell"

func flickrUrl(forApiKey key: String, withAnnotation annotation: DroppablePin, andNumberOfPhotos numberOfPhotos: Int) -> String {
    return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(key)&lat=\(annotation.coordinate.latitude)&lon=\(annotation.coordinate.longitude)&radius=1&radius_units=km&per_page=\(numberOfPhotos)&format=json&nojsoncallback=1"
}
