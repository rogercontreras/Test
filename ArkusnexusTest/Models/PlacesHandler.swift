//
//  PlacesHandler.swift
//  ArkusnexusTest
//
//  Created by Rogelio Contreras Velázquez on 27/08/19.
//  Copyright © 2019 Rogelio Contreras Velázquez. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class Places: NSObject {
    
    static let shared : Places = Places()
    var itemsList : [Place] = []
    var currentItem : Int = 0
    
    override init() {
        
    }
    
    func fetchInfo(success: @escaping () -> Void) {
        Alamofire.request("http://www.mocky.io/v2/5bf3ce193100008900619966", method: .get).responseData(completionHandler: { (data) in
            guard (data.data != nil) else {
                return
            }
            let decoder = JSONDecoder()
            do {
                self.itemsList = try decoder.decode([Place].self, from: data.data!)
                success()
            } catch let error {
                print(error)
            }
        })
    }
    
    func orderPlaces(nearTo position : CLLocationCoordinate2D, completion: @escaping () -> Void) {
        let origin = CLLocation(latitude: position.latitude, longitude: position.longitude)
        
        for i in 0 ..< itemsList.count {
            let destination = CLLocation(latitude: itemsList[i].latitude, longitude: itemsList[i].longitude)
            itemsList[i].distance = origin.distance(from: destination)
        }
        
        itemsList = itemsList.sorted(by: { $0.distance ?? 0 < $1.distance ?? 0 })
        completion()
    }
    
    open func getCurrentItem() -> Place {
        return itemsList[currentItem]
    }
}

struct Place : Codable {
    let placeId : String
    let placeName : String
    let address : String
    let category : String
    let isOpenNow : String
    let latitude : Double
    let longitude : Double
    let thumbnail : URL
    let rating : Double
    let isPetFriendly : Bool
    let addressLine1 : String
    let addressLine2 : String
    let phoneNumber : String
    let site : URL
    var distance : Double?
    
    enum CodingKeys: String, CodingKey {
        case placeId = "PlaceId"
        case placeName = "PlaceName"
        case address = "Address"
        case category = "Category"
        case isOpenNow = "IsOpenNow"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case thumbnail = "Thumbnail"
        case rating = "Rating"
        case isPetFriendly = "IsPetFriendly"
        case addressLine1 = "AddressLine1"
        case addressLine2 = "AddressLine2"
        case phoneNumber = "PhoneNumber"
        case site = "Site"
        case distance = ""
    }
}
