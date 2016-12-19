//
//  MapViewController.swift
//  zhaw_moba1_lab11
//
//  Created by José Miguel Rota on 12.12.16.
//  Copyright © 2016 José Miguel Rota. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    var postOffice: PostOffice? = nil
    var location: CLLocation? = nil
    let regionRadius: CLLocationDistance = 1000
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBar.topItem?.title = postOffice?.name
        
        if let office = self.postOffice {
            let initialLocation = office.location
            self.centerMapOnLocation(location: initialLocation())
            let pin = MKPointAnnotation()
            pin.coordinate = initialLocation().coordinate
            pin.title = office.name
            mapView.addAnnotation(pin)
        }
        
        if let ownLocation = self.location {
            let ownPin = MKPointAnnotation()
            ownPin.coordinate = ownLocation.coordinate
            ownPin.title = "My Location"
            mapView.addAnnotation(ownPin)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "mainView")
        self.present(view!, animated: false, completion: nil)
        //self.navigationController?.popViewController(animated: true)
    }
}
