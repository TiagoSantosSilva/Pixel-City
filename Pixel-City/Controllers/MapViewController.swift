//
//  ViewController.swift
//  Pixel-City
//
//  Created by Tiago Santos on 19/12/17.
//  Copyright © 2017 Tiago Santos. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func centerMapButtonTapped(_ sender: Any) {
    }
    
}

