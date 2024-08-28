//
//  Service.swift
//  UberTutorial
//
//  Created by Mykyta Yarovoi on 28.08.2024.
//

import Firebase
import FirebaseAuth

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")

struct Service {
    
    static let shared = Service()
    let currentUid = Auth.auth().currentUser?.uid
    
    func fetchUserData() {
        REF_USERS.child(currentUid!).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String : Any] else { return }
            guard let fullname = dictionary["fullName"] as? String else { return }
            print("\(snapshot)")
        }
    }
}
