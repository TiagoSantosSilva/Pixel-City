//
//  PopImageViewController.swift
//  Pixel-City
//
//  Created by Tiago Santos on 22/12/17.
//  Copyright © 2017 Tiago Santos. All rights reserved.
//

import UIKit

class PopImageViewController: UIViewController {

    @IBOutlet weak var popImageView: UIImageView!
    
    var passedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popImageView.image = passedImage
    }
    
    func initData(forImage image: UIImage) {
        self.passedImage = image
    }
}
