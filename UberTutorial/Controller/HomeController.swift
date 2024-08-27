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
    
    //MARK: - Lifycycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
//        signOut()
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
        
        view.addSubview(mapView)
        mapView.frame = view.frame
    }
}
