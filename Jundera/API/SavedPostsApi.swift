//
//  SavedPostsApi.swift
//  Jundera
//
//  Created by Gina De La Rosa on 10/7/18.
//  Copyright © 2018 Gina De La Rosa. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class SavedPostsApi {
    
    var REF_MySavedPosts = Database.database().reference().child("saved")
    
    func observeSavedPosts(withId id: String, completion: @escaping (Post) -> Void) {
        REF_MySavedPosts.child(id).observe(.childAdded, with: {
            snapshot in
            let key = snapshot.key
            Api.Post.observePost(withId: key, completion: { (post) in
                completion(post)
            })
        })
    }
    
    func observeSavedPostsRemoved(withId id: String, completion: @escaping (Post) -> Void) {
        REF_MySavedPosts.child(id).observe(.childRemoved, with: {
            snapshot in
            let key = snapshot.key
            Api.Post.observePost(withId: key, completion: { (post) in
                completion(post)
            })
        })
    }
}
