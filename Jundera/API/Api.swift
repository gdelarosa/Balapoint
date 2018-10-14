//
//  Api.swift
//  Metis
//
//  Created by Gina De La Rosa on 11/14/17.
//  Copyright © 2017 Gina Delarosa. All rights reserved.
//  TODO: Will need to update -

import Foundation

struct Api {
    
    static var Userr = UserApi()
    static var Post = PostApi()
    static var Comment = CommentApi()
    static var Post_Comment = Post_CommentApi()
    static var MyPosts = MyPostsApi()
    static var Follow = FollowApi()
    static var Feed = FeedApi()
    static var HashTag = HashTagApi()
    static var SavedPosts = SavedPostsApi() //added for viewing saved posts.
}
