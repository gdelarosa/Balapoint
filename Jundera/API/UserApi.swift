//
//  UserApi.swift
//  Metis
//
//  Created by Gina De La Rosa on 11/14/17.
//  Copyright © 2017 Gina Delarosa. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class UserApi {
    
    var REF_USERS = Database.database().reference().child("users")
    
    func observeUserByUsername(username: String, completion: @escaping (Userr) -> Void) {
        REF_USERS.queryOrdered(byChild: "username_lowercase").queryEqual(toValue: username).observeSingleEvent(of: .childAdded, with: {
            snapshot in
            print(snapshot)
            if let dict = snapshot.value as? [String: Any] {
                let user = Userr.transformUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        })
    }
   
    func observeUser(withId uid: String, completion: @escaping (Userr) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = Userr.transformUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        })
    }
    
    func observeCurrentUser(completion: @escaping (Userr) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        REF_USERS.child(currentUser.uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = Userr.transformUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        })
    }
    
    func observeUsers(completion: @escaping (Userr) -> Void) {
        REF_USERS.observe(.childAdded, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = Userr.transformUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        })
    }
    
    func queryUsers(withText text: String, completion: @escaping (Userr) -> Void) {
        REF_USERS.queryOrdered(byChild: "username_lowercase").queryStarting(atValue: text).queryEnding(atValue: text+"\u{f8ff}").queryLimited(toFirst: 10).observeSingleEvent(of: .value, with: {
            snapshot in
            snapshot.children.forEach({ (s) in
                let child = s as! DataSnapshot
                if let dict = child.value as? [String: Any] {
                    let user = Userr.transformUser(dict: dict, key: child.key)
                    completion(user)
                }
            })
        })
    }
    
    var CURRENT_USER: User? {
        if let currentUser = Auth.auth().currentUser {
            return currentUser
        }
        
        return nil
    }
    
    var REF_CURRENT_USER: DatabaseReference? {
        guard let currentUser = Auth.auth().currentUser else {
            return nil
        }
        
        return REF_USERS.child(currentUser.uid)
    }
}
