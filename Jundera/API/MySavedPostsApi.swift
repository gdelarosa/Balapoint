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

    func saveAction(withUser id: String) {
        REF_MYSAVEDPOSTS.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                for key in dict.keys {
             Database.database().reference().child("saved").child(Api.Userr.CURRENT_USER!.uid).child(key).setValue(true)
                }
            }
        })
        REF_MYSAVEDPOSTS.child(Api.Userr.CURRENT_USER!.uid).child(id).setValue(true)
    }
    
    func unSaveAction(withUser id: String) {
        
        Api.MyPosts.REF_MYPOSTS.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                for key in dict.keys {
                    Database.database().reference().child("saved").child(Api.Userr.CURRENT_USER!.uid).child(key).removeValue()
                    print("Post was unsaved")
                }
            }
        })
        REF_MYSAVEDPOSTS.child(Api.Userr.CURRENT_USER!.uid).child(id).setValue(NSNull())
    }
    
    func isSaved(userId: String, completed: @escaping (Bool) -> Void) {
        REF_MYSAVEDPOSTS.child(userId).child(Api.Userr.CURRENT_USER!.uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let _ = snapshot.value as? NSNull {
                print("Is saved: FALSE")
                completed(false)
            } else {
                print("Is saved: TRUE")
                completed(true)
            }
        })
    }
    
//    func incrementLikes(postId: String, onSucess: @escaping (Post) -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
//        let postRef = Api.MySavedPosts.REF_MYSAVEDPOSTS.child(postId)
//            //Api.Post.REF_POSTS.child(postId)
//        postRef.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
//            if var post = currentData.value as? [String : AnyObject], let uid = Api.Userr.CURRENT_USER?.uid {
//                var likes: Dictionary<String, Bool>
//                var saves: Dictionary<String, Bool> //testing
//                saves = post["saved"] as? [String : Bool] ?? [:] //testing
//                
//                likes = post["likes"] as? [String : Bool] ?? [:]
//                
//                var likeCount = post["likeCount"] as? Int ?? 0
//                if let _ = likes[uid] {
//                    likeCount -= 1
//                    likes.removeValue(forKey: uid)
//                    saves.removeValue(forKey: uid) //testing
//                } else {
//                    likeCount += 1
//                    likes[uid] = true
//                    saves[uid] = true //testing
//                }
//                post["likeCount"] = likeCount as AnyObject?
//                post["likes"] = likes as AnyObject?
//                post["saved"] = saves as AnyObject? //testing
//                
//                currentData.value = post
//                
//                return TransactionResult.success(withValue: currentData)
//            }
//            return TransactionResult.success(withValue: currentData)
//        }) { (error, committed, snapshot) in
//            if let error = error {
//                onError(error.localizedDescription)
//            }
//            if let dict = snapshot?.value as? [String: Any] {
//                let post = Post.transformPostPhoto(dict: dict, key: snapshot!.key)
//                onSucess(post)
//            }
//        }
//    }
    
    
}
