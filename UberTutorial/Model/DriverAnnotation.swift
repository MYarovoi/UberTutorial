//
//  DriverAnnotation.swift
//  UberTutorial
//
//  Created by Mykyta Yarovoi on 29.08.2024.
//

import MapKit

class DriverAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var uid: String
    
    init(coordinate: CLLocationCoordinate2D, uid: String) {
        self.coordinate = coordinate
        self.uid = uid
    }
}
