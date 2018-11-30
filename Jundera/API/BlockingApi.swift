//
//  BlockingApi.swift
//  Jundera
//
//  Created by Gina De La Rosa on 11/30/18.
//  Copyright © 2018 Gina De La Rosa. All rights reserved.
//

import Foundation
import FirebaseDatabase

class BlockApi {
    
    var REF_BLOCKED = Database.database().reference().child("blocked")
    var REF_BLOCKING = Database.database().reference().child("blocking")
    
    func blockAction(withUser id: String) {
        Api.MyPosts.REF_MYPOSTS.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                for key in dict.keys {
             Database.database().reference().child("feed").child(Api.Userr.CURRENT_USER!.uid).child(key).setValue(true)
                }
            }
        })
        REF_BLOCKED.child(id).child(Api.Userr.CURRENT_USER!.uid).setValue(true)
        REF_BLOCKING.child(Api.Userr.CURRENT_USER!.uid).child(id).setValue(true)
    }
    
    func unblockAction(withUser id: String) {
        
        Api.MyPosts.REF_MYPOSTS.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                for key in dict.keys {
                    Database.database().reference().child("feed").child(Api.Userr.CURRENT_USER!.uid).child(key).removeValue()
                }
            }
        })
        
        REF_BLOCKED.child(id).child(Api.Userr.CURRENT_USER!.uid).setValue(NSNull())
        REF_BLOCKING.child(Api.Userr.CURRENT_USER!.uid).child(id).setValue(NSNull())
    }
    
    func isBlocking(userId: String, completed: @escaping (Bool) -> Void) {
        REF_BLOCKED.child(userId).child(Api.Userr.CURRENT_USER!.uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let _ = snapshot.value as? NSNull {
                completed(false)
            } else {
                completed(true)
            }
        })
    }
}
