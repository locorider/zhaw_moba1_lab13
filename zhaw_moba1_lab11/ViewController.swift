//
//  ViewController.swift
//  zhaw_moba1_lab11
//
//  Created by José Miguel Rota on 04.12.16.
//  Copyright © 2016 José Miguel Rota. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var inputX: UITextField!
    @IBOutlet weak var inputY: UITextField!
    @IBOutlet weak var tableView: PostOfficeTableView!
    
    var filteredPostOffices: [SearchResult] = []
    var location: CLLocation? = nil
    let postOfficeStore = PostOfficeStore()
    let locationManager = CLLocationManager()
    let textCellIdentifier = "tableCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.getlocationForUser()
        
        self.postOfficeStore.load(file: "post-switzerland", type: "txt")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.getlocationForUser()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didClickBtnSearch(_ sender: Any) {
        if var strLat = inputX.text {
            let lat = strLat.characters.count > 0 ? strLat : "0"
            if var strLong = inputY.text {
                let long = strLong.characters.count > 0 ? strLong : "0"
                let location = CLLocation(latitude: Double(lat)!, longitude: Double(long)!)
                self.filterPostOffices(location)
            }
        }
    }
    
    func filterPostOffices(_ location: CLLocation) {
        self.filteredPostOffices = self.postOfficeStore.filter(fromLocation: location, distance: 5000)
        self.tableView.reloadData()
    }
    
    func getlocationForUser() {
        if CLLocationManager.locationServicesEnabled() {
            //Then check whether the user has granted you permission to get his location
            if CLLocationManager.authorizationStatus() == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            } else if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied {
                
            } else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                locationManager.requestLocation()
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.last
        let lat: Double = (location?.coordinate.latitude)!
        let long: Double = (location?.coordinate.longitude)!
        inputX.text = "\(lat)"
        inputY.text = "\(long)"
        print("Updating location \(lat) \(long)")
        self.filterPostOffices(location!)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.filteredPostOffices.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.textCellIdentifier, for: indexPath) as! PostOfficeTableCell
        let postOffice = self.filteredPostOffices[indexPath.row]
        
        let km = round(postOffice.distanceMeter) / 1000
        
        cell.lblName?.text = postOffice.postOffice.name ?? "No Name Provided"
        cell.lblOpeningHours.text = postOffice.postOffice.openingHours ?? "No Opening Hours Provided"
        cell.lblDistance.text = String(format: "%.3fkm", km)
        return cell
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postOffice = self.filteredPostOffices[indexPath.row]
        let mapView = self.storyboard?.instantiateViewController(withIdentifier: "mapView") as? MapViewController
        
        mapView?.postOffice = postOffice.postOffice
        mapView?.location = self.location
        //self.navigationController?.pushViewController(mapView!, animated: true)
        self.present(mapView!, animated: false, completion: nil)
    }
}

