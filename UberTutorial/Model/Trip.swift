//
//  Trip.swift
//  UberTutorial
//
//  Created by Mykyta Yarovoi on 04.09.2024.
//

import CoreLocation

struct Trip {
    
    var pickupCoordinates: CLLocationCoordinate2D!
    var destinationCoordinates: CLLocationCoordinate2D!
    let passengerUid: String!
    var driverUid: String?
    var state: TripSate!
    
    init(passengerUid: String, dictionary: [String : Any]) {
        self.passengerUid = passengerUid
        
        if let pickupCoorinates = dictionary["pickupCoordinates"] as? NSArray {
            guard let lat = pickupCoorinates[0] as? CLLocationDegrees else { return }
            guard let long = pickupCoorinates[1] as? CLLocationDegrees else { return }
            self.pickupCoordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        
        if let destinationCoorinates = dictionary["destinationCoordinates"] as? NSArray {
            guard let lat = destinationCoorinates[0] as? CLLocationDegrees else { return }
            guard let long = destinationCoorinates[1] as? CLLocationDegrees else { return }
            self.destinationCoordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        
        self.driverUid = dictionary["driverUid"] as? String ?? ""
        
        if let state = dictionary["state"] as? Int {
            self.state = TripSate(rawValue: state)
        }
    }
}

enum TripSate: Int {
    case requested
    case accepted
    case inProgress
    case completed
}
