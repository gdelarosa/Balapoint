//
//  MySavedPostsApi.swift
//  Balapoint
//
//  Created by Gina De La Rosa on 10/24/18.
//  Copyright © 2018 Gina De La Rosa. All rights reserved.
//

import Foundation
import FirebaseDatabase

class MySavedPostsApi {
    
    var REF_MYSAVEDPOSTS = Database.database().reference().child("saved")
    
    func fetchMySavedPosts(userId: String, completion: @escaping (String) -> Void) {
        REF_MYSAVEDPOSTS.child(userId).observe(.childAdded, with: {
            snapshot in
            completion(snapshot.key)
        })
    }
    
    func fetchCountMySavedPosts(userId: String, completion: @escaping (Int) -> Void) {
        REF_MYSAVEDPOSTS.child(userId).observe(.value, with: {
            snapshot in
            let count = Int(snapshot.childrenCount)
            completion(count)
        })
    }
}
