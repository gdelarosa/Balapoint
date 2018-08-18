//
//  User.swift
//  Metis
//
//  Created by Gina De La Rosa on 11/15/17.
//  Copyright © 2017 Gina Delarosa. All rights reserved.
//

import Foundation

class Userr {
    
    var email: String?
    var profileImageUrl: String?
    var username: String?
    var id: String?
    var isFollowing: Bool?
    var goal: String? //Won't need but will have to have a bio of sorts like goal. 
    var postTitle: String?
}

extension Userr {
    static func transformUser(dict: [String: Any], key: String) -> Userr {
        let user = Userr()
        user.email = dict["email"] as? String
        user.profileImageUrl = dict["profileImageUrl"] as? String
        user.username = dict["username"] as? String
        user.id = key
        user.goal = dict["goal"] as? String //Won't need
        user.postTitle = dict["title"] as? String
        return user
    }
}
