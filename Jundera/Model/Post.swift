//
//  Post.swift
//  Metis
//
//  Created by Gina De La Rosa on 11/15/17.
//  Copyright © 2017 Gina Delarosa. All rights reserved.
//  Likes are just the posts we want to save. Will have to refactor later. 

import Foundation
import FirebaseAuth

class Post {
    
    var caption: String?
    var photoUrl: String?
    var uid: String?
    var id: String?
    var likeCount: Int?
    var likes: Dictionary<String, Any>?
    var isLiked: Bool?
    var ratio: CGFloat?
    var title: String?
    var creationDate: Date?
}

extension Post {
    
    static func transformPostPhoto(dict: [String: Any], key: String) -> Post {
        let post = Post()
        post.id = key
        post.caption = dict["caption"] as? String
        post.photoUrl = dict["photoUrl"] as? String
        post.uid = dict["uid"] as? String
        post.likeCount = dict["likeCount"] as? Int
        post.likes = dict["likes"] as? Dictionary<String, Any>
        post.ratio = dict["ratio"] as? CGFloat
        post.title = dict["title"] as? String
        
        let secondsAgoFrom1970 = dict["creationDate"] as? Double ?? 0
        post.creationDate = Date(timeIntervalSince1970: secondsAgoFrom1970)
        
        if let currentUserId = Auth.auth().currentUser?.uid {
            
            if post.likes != nil {
                post.isLiked = post.likes![currentUserId] != nil
            }
        }
      
        return post
    }
}


