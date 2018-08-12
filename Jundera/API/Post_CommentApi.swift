//
//  Post_CommentApi.swift
//  Metis
//
//  Created by Gina De La Rosa Team on 11/14/17.
//  Copyright © 2017 Gina Delarosa. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Post_CommentApi {
    
    var REF_POST_COMMENTS = Database.database().reference().child("post-comments")
    
    
//    func observeComments(withPostId id: String, completion: @escaping (Comment) -> Void) {
//        REF_COMMENTS.child(id).observeSingleEvent(of: .value, with: {
//            snapshot in
//            if let dict = snapshot.value as? [String: Any] {
//                let newComment = Comment.transformComment(dict: dict)
//                completion(newComment)
//            }
//        })
//    }
    
}
