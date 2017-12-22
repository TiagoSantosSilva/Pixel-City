//
//  ViewController.swift
//  Pixel-City
//
//  Created by Tiago Santos on 19/12/17.
//  Copyright © 2017 Tiago Santos. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire

class MapViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pullUpView: UIView!
    @IBOutlet weak var pullUpViewHeightConstraint: NSLayoutConstraint!
    
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 1000
    
    var spinner: UIActivityIndicatorView?
    var progressLabel: UILabel?
    
    var screenSize = UIScreen.main.bounds
    
    var flowLayout =  UICollectionViewFlowLayout()
    var collectionView: UICollectionView?
    
    var photoService: PhotoService?
    var appService: AppService?
    
    var imageArraySize: Int?
    var imageArray: [UIImage]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoService = PhotoService()
        appService = AppService()
        mapView.delegate = self
        locationManager.delegate = self
        configureLocationServices()
        addDoubleTapGestureRecognizer()
        initializeCollectionView()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView?.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCellReuseIdentifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        
        pullUpView.addSubview(collectionView!)
    }
    
    func addDoubleTapGestureRecognizer() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dropPin))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        mapView.addGestureRecognizer(doubleTap)
    }
    
    func addSwipeGestureRecognizer() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(animateViewDown))
        swipe.direction = .down
        mapView.addGestureRecognizer(swipe)
    }
    
    @objc func animateViewDown() {
        appService?.cancelAllSesions()
        animateView(constant: 0)
    }
    
    func animateViewUp() {
        animateView(constant: 300)
    }
    
    func animateView(constant: Int) {
        UIView.animate(withDuration: 0.3) {
            self.pullUpViewHeightConstraint.constant = CGFloat(constant)
            self.view.layoutIfNeeded()
        }
    }
    
    func addSpiner() {
        removeSpinner()
        
        spinner = UIActivityIndicatorView()
        spinner?.center = CGPoint(x: (screenSize.width / 2) - ((spinner?.frame.width)! / 2), y: pullUpViewHeightConstraint.constant / 2) // TODO: Change 150 to dynamic property
        spinner?.activityIndicatorViewStyle = .whiteLarge
        spinner?.color = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        spinner?.startAnimating()
        collectionView?.addSubview(spinner!)
    }
    
    func removeSpinner() {
        if spinner != nil {
            spinner?.removeFromSuperview()
        }
    }
    
    func removePin() {
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
    }
    
    func addProgressLabel() {
        removeProgressLabel()
        
        progressLabel = UILabel()
        progressLabel?.frame = CGRect(x: (screenSize.width / 2) - 120, y: 175, width: 240, height: 40)
        progressLabel?.font = UIFont(name: "Avenir", size: 18)
        progressLabel?.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        progressLabel?.textAlignment = .center
        collectionView?.addSubview(progressLabel!)
    }
    
    func removeProgressLabel() {
        if progressLabel != nil {
            progressLabel?.removeFromSuperview()
        }
    }
    
    @IBAction func centerMapButtonTapped(_ sender: Any) {
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            centerMapOnUserLocation()
        }
    }
    
    @objc func dropPin(sender: UITapGestureRecognizer) {
        appService?.cancelAllSesions()
        removePin()
        animateViewUp()
        addSwipeGestureRecognizer()
        addSpiner()
        addProgressLabel()
        
        let touchPoint = sender.location(in: mapView)
        let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        let annotation = DroppablePin(coordinate: touchCoordinate, identifier: DroppablePinReuseIdentifier)
        mapView.addAnnotation(annotation)
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(touchCoordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        
        photoService?.retrieveUrls(forAnnotation: annotation, handler: { (photoUrls) in
            if photoUrls.count != 0 {
                self.photoService?.retrieveImages(imageUrlArray: photoUrls, progressLabel: self.progressLabel!, handler: { (imageArray) in
                    self.imageArraySize = imageArray.count
                    self.imageArray = imageArray
                    self.removeSpinner()
                    self.removeProgressLabel()
                    self.collectionView?.reloadData()
                })
            }
        })
    }
}

