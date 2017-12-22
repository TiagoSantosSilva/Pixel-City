//
//  AppService.swift
//  Pixel-City
//
//  Created by Tiago Santos on 22/12/17.
//  Copyright © 2017 Tiago Santos. All rights reserved.
//

import Foundation
import Alamofire

class AppService {
    func cancelAllSesions() {
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach({$0.cancel()})
            downloadData.forEach({$0.cancel()})
        }
    }
}
