//
//  User.swift
//  UberTutorial
//
//  Created by Mykyta Yarovoi on 28.08.2024.
//

import Foundation
import CoreLocation

enum AccountType: Int {
    case passenger
    case driver
}

struct User {
    let fullname: String
    let email: String
    var accountType: AccountType!
    var location: CLLocation?
    let uid: String
    var homeLocation: String?
    var workLocation: String?
    
    init(uid: String, dictionary: [String : Any]) {
        self.fullname = dictionary["fullName"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.uid = uid
        
        if let home = dictionary["homeLocation"] as? String {
            self.homeLocation = home
        }
        
        if let work = dictionary["workLocation"] as? String {
            self.workLocation = work
        }

        if let index = dictionary["accountType"] as? Int {
            self .accountType = AccountType(rawValue: index)
        }
    }
}
