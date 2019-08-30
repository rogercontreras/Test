//
//  PlaceDetailTableViewController.swift
//  ArkusnexusTest
//
//  Created by Rogelio Contreras Velázquez on 28/08/19.
//  Copyright © 2019 Rogelio Contreras Velázquez. All rights reserved.
//

import UIKit
import GoogleMaps
import Cosmos
import SafariServices
import MapKit

class PlaceDetailTableViewController: UITableViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel1: UILabel!
    @IBOutlet weak var addressLabel2: UILabel!
    
    @IBOutlet weak var driveTimeLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    
    @IBOutlet weak var petIcon: UIImageView!
    @IBOutlet weak var rateControl: CosmosView!
    
    var currentPlace : Place = Places.shared.getCurrentItem()
    
    
    enum CellAction : Int {
        case directions = 0
        case call
        case website
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.fillInfo()
        self.loadMap()
    }
    
    func fillInfo() {
        self.titleLabel.text = currentPlace.placeName
        self.rateControl.rating = currentPlace.rating
        self.rateControl.settings.fillMode = .precise
        self.categoryLabel.text = currentPlace.category.capitalized + (currentPlace.isPetFriendly ? ", Dogs Allowed" : "")
        self.addressLabel1.text = currentPlace.addressLine1
        self.addressLabel2.text = currentPlace.addressLine2
        self.petIcon.isHidden = !currentPlace.isPetFriendly
        
        
        self.phoneLabel.text = currentPlace.phoneNumber
        self.websiteLabel.text = currentPlace.site.absoluteString
        
        if let distance = currentPlace.distance {
            self.distanceLabel.text = String(format: "%.1f km", distance/1000)
        }
        
        self.calculateETA { (eta) in
            self.driveTimeLabel.text = eta
        }
        
    }
    
    // MARK: - Table View Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == CellAction.directions.rawValue {
            openDirections()
        } else if indexPath.row == CellAction.call.rawValue {
            callPlace()
        } else {
            openBrowser()
        }
    }
    
    func openDirections() {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.open(URL(string:
                "comgooglemaps://?saddr=&daddr=\(currentPlace.latitude),\(currentPlace.longitude)&zoom=14&views=traffic&directionsmode=driving")!)
        } else {
            print("Can't use comgooglemaps://");
        }
    }
    
    func callPlace() {
        guard let phoneNumber = URL(string: "tel://" + self.currentPlace.phoneNumber.filterNumber()) else {
            return
        }
        
        UIApplication.shared.open(phoneNumber, options: [:], completionHandler: nil)
    }
    
    func openBrowser() {
        let safariVC = SFSafariViewController(url: self.currentPlace.site)
        self.present(safariVC, animated: true, completion: nil)
    }
    
    // MARK: - Maps ETA
    func calculateETA(completion: @escaping (String) -> Void) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: User.shared.location ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: currentPlace.latitude, longitude: currentPlace.longitude)))
        
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let direction = MKDirections(request: request)
        direction.calculateETA { (response, error) in
            guard let resp = response else {
                return
            }
            
            let time = NSInteger(resp.expectedTravelTime)
            let hours = time/3600
            let minutes = (time/60) % 60
            
            if hours > 0 && minutes > 0 {
                completion(String(format: "%d hours and %d min drive", hours, minutes))
            } else {
                if hours <= 0 {
                    completion(String(format: "%d min drive", minutes))
                } else if minutes <= 0 {
                    completion(String(format: "%d hours drive", hours))
                }
            }
        }
    }
    
    // MARK: - Google Maps
    func loadMap() {
        let camera = GMSCameraPosition.camera(withLatitude: currentPlace.latitude, longitude: currentPlace.longitude, zoom: 15.0)
        self.mapView.camera = camera
        
        let position = CLLocationCoordinate2D(latitude: currentPlace.latitude, longitude: currentPlace.longitude)
        let marker = GMSMarker(position: position)
        marker.icon = UIImage(named: "pin")
        marker.title = currentPlace.placeName
        marker.map = self.mapView
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
