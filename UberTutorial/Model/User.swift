//
//  User.swift
//  UberTutorial
//
//  Created by Mykyta Yarovoi on 28.08.2024.
//

import Foundation

struct User {
    let fullname: String
    let email: String
    let accountType: Int
    
    init(dictionary: [String : Any]) {
        self.fullname = dictionary["fullName"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.accountType = dictionary["accountType"] as? Int ?? 0
    }
}
