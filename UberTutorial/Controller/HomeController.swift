//
//  HomeController.swift
//  UberTutorial
//
//  Created by Mykyta Yarovoi on 27.08.2024.
//

import UIKit
import FirebaseAuth
import MapKit

class HomeController: UIViewController {
    
    //MARK: - Properties
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    
    
    //MARK: - Lifycycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
//                signOut()
        enableLocationServices()
    }
    
    //MARK: - API
    
    func checkIfUserIsLoggedIn() {
        
        if Auth.auth().currentUser?.uid == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        } else {
            configureUI()
        }
    }
    
    func signOut() {
        
        do {
            try Auth.auth().signOut()
        } catch {
            debugPrint("Error signing out")
        }
    }
    
    //MARK: Helper Functions
    
    func configureUI() {
        configureMapView()
    }
    
    func configureMapView() {
        view.addSubview(mapView)
        mapView.frame = view.frame
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
}

//MARK: - LocationServices

 extension HomeController: CLLocationManagerDelegate {
    
    func enableLocationServices() {
        locationManager.delegate = self
        
        let status = CLLocationManager().authorizationStatus
        switch status {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways:
            printContent("authorizedAlways")
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
        @unknown default:
            break
        }
    }
     
     func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
         let status = manager.authorizationStatus
         
         if status == .authorizedWhenInUse {
             locationManager.requestAlwaysAuthorization()
         }
     }
}
