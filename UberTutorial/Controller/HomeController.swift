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
    
    private let inputActivationView = LocationInputActivationView()
    private let locationInputView = LocationInputView()
    
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
        
        view.addSubview(inputActivationView)
        inputActivationView.centerX(inView: view)
        inputActivationView.setDimensions(height: 50, width: view.frame.width - 64)
        inputActivationView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        inputActivationView.alpha = 0
        
        UIView.animate(withDuration: 2) {
            self.inputActivationView.alpha = 1
        }
        
        inputActivationView.delegate = self
    }
    
    func configureMapView() {
        view.addSubview(mapView)
        mapView.frame = view.frame
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
    
    func configureLocationInputView() {
        locationInputView.delegate = self
        
        view.addSubview(locationInputView)
        locationInputView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 200)
        locationInputView.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.locationInputView.alpha = 1
        } completion: { _ in
            print("present tableview")
        }

    }
}

//MARK: - LocationServices

 extension HomeController: CLLocationManagerDelegate {
    
    func enableLocationServices() {
        locationManager.delegate = self
        
        let status = CLLocationManager()
        switch status.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways:
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

//MARK: - LocationInputActivationViewDelegate
extension HomeController: LocationInputActivationViewDelegate {
    func presentLocationInputView() {
        
        inputActivationView.alpha = 0
        configureLocationInputView()
    }
}

//MARK: - LocationInputViewDelegate
extension HomeController: LocationInputViewDelegate {
    func dismissLocationInputView() {
        
        UIView.animate(withDuration: 0.3) {
            self.locationInputView.alpha = 0
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.inputActivationView.alpha = 1
            }
        }
    }
}
