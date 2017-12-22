//
//  PopImageViewController.swift
//  Pixel-City
//
//  Created by Tiago Santos on 22/12/17.
//  Copyright © 2017 Tiago Santos. All rights reserved.
//

import UIKit

class PopImageViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var popImageView: UIImageView!
    
    var passedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popImageView.image = passedImage
        addDoubleTapToDismiss()
    }
    
    func initData(forImage image: UIImage) {
        self.passedImage = image
    }
    
    func addDoubleTapToDismiss() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        view.addGestureRecognizer(doubleTap)
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
}
