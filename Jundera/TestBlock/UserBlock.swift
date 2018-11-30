//
//  UserBlock.swift
//  Poto
//
//  Created by Zehua Lin on 11/6/17.
//  Copyright © 2017 Zehua Lin. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserBlock {
    
    let REF_USER_BLOCK = Database.database().reference().child("user-block")
    
    func blockUser(targetUID: String) {
        guard let uid = Api.Userr.CURRENT_USER?.uid else {return}
        REF_USER_BLOCK.child(uid).child(targetUID).setValue(true)
    }
    
    func unblockUser(targetUID: String) {
        guard let uid = Api.Userr.CURRENT_USER?.uid else {return}
        REF_USER_BLOCK.child(uid).child(targetUID).setValue(NSNull())
    }
    
    func checkIfBlocked(targetUID: String, completion: @escaping (Bool) -> Void) {
        guard let uid = Api.Userr.CURRENT_USER?.uid else {return}
        REF_USER_BLOCK.child(uid).child(targetUID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                completion(false)
            }else {
                completion(true)
            }
        })
    }
    
    func observeBlockList(uid: String, completion: @escaping (String) -> Void) {
        REF_USER_BLOCK.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String : AnyObject] {
                for key in dict.keys {
                    completion(key)
                }
            }
        })
    }
    
    func observeBlock(uid: String, completion: @escaping (String) -> Void) {
        REF_USER_BLOCK.child(uid).observe(.childAdded, with: { (snapshot) in
            completion(snapshot.key)
        })
    }
    
    func observeUnblock(uid: String, completion: @escaping (String) -> Void) {
        REF_USER_BLOCK.child(uid).observe(.childRemoved, with: { (snapshot) in
            completion(snapshot.key)
        })
    }
}
