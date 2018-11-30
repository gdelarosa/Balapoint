//
//  HashTagApi.swift
//  Balapoint
//
//  Created by Gina De La Rosa on 11/15/17.
//  Copyright © 2017 Gina Delarosa. All rights reserved.
//

import Foundation
import FirebaseDatabase

class HashTagApi {
    
    var REF_HASHTAG = Database.database().reference().child("hashtag")
    var REF_POSTS = Database.database().reference().child("posts")

    
    /// Topic: Delete this. 
    func observeTopPosts(completion: @escaping (Post) -> Void) {
        REF_POSTS.queryOrdered(byChild: "hashtag").queryStarting(atValue: "cooking").observeSingleEvent(of: .value, with: {
            snapshot in
            let arraySnapshot = (snapshot.children.allObjects as! [DataSnapshot]).reversed()
            arraySnapshot.forEach({ (child) in
                if let dict = child.value as? [String: Any] {
                    let post = Post.transformPostPhoto(dict: dict, key: child.key)
                    completion(post)
                    //print(dict)
                }
            })
        })
    }
    
    /// Topic: Food
    func observeFood(completion: @escaping (Post) -> Void) {
        REF_POSTS.queryOrdered(byChild: "hashtag").queryStarting(atValue: "food").observeSingleEvent(of: .value, with: {
            snapshot in
            let arraySnapshot = (snapshot.children.allObjects as! [DataSnapshot]).reversed()
            arraySnapshot.forEach({ (child) in
                if let dict = child.value as? [String: Any] {
                    let post = Post.transformPostPhoto(dict: dict, key: child.key)
                    completion(post)
                    //print(dict)
                }
            })
        })
    }
    
    /// Topic: Education
    func observeEducation(completion: @escaping (Post) -> Void) {
        REF_POSTS.queryOrdered(byChild: "hashtag").queryStarting(atValue: "education").observeSingleEvent(of: .value, with: {
            snapshot in
            let arraySnapshot = (snapshot.children.allObjects as! [DataSnapshot]).reversed()
            arraySnapshot.forEach({ (child) in
                if let dict = child.value as? [String: Any] {
                    let post = Post.transformPostPhoto(dict: dict, key: child.key)
                    completion(post)
                    //print(dict)
                }
            })
        })
    }
    
    /// Topic: Tech
    func observeTech(completion: @escaping (Post) -> Void) {
        REF_POSTS.queryOrdered(byChild: "hashtag").queryStarting(atValue: "tech").observeSingleEvent(of: .value, with: {
            snapshot in
            let arraySnapshot = (snapshot.children.allObjects as! [DataSnapshot]).reversed()
            arraySnapshot.forEach({ (child) in
                if let dict = child.value as? [String: Any] {
                    let post = Post.transformPostPhoto(dict: dict, key: child.key)
                    completion(post)
                    //print(dict)
                }
            })
        })
    }
    
    /// Topic: Travel
    func observeTravel(completion: @escaping (Post) -> Void) {
        REF_POSTS.queryOrdered(byChild: "hashtag").queryStarting(atValue: "travel").observeSingleEvent(of: .value, with: {
            snapshot in
            let arraySnapshot = (snapshot.children.allObjects as! [DataSnapshot]).reversed()
            arraySnapshot.forEach({ (child) in
                if let dict = child.value as? [String: Any] {
                    let post = Post.transformPostPhoto(dict: dict, key: child.key)
                    completion(post)
                    //print(dict)
                }
            })
        })
    }
    
    /// Topic: Lifestyle
    func observeLifestyle(completion: @escaping (Post) -> Void) {
        REF_POSTS.queryOrdered(byChild: "hashtag").queryStarting(atValue: "lifestyle").observeSingleEvent(of: .value, with: {
            snapshot in
            let arraySnapshot = (snapshot.children.allObjects as! [DataSnapshot]).reversed()
            arraySnapshot.forEach({ (child) in
                if let dict = child.value as? [String: Any] {
                    let post = Post.transformPostPhoto(dict: dict, key: child.key)
                    completion(post)
                    //print(dict)
                }
            })
        })
    }
    
    /// Topic: Politics
    func observePolitics(completion: @escaping (Post) -> Void) {
        REF_POSTS.queryOrdered(byChild: "hashtag").queryStarting(atValue: "politics").observeSingleEvent(of: .value, with: {
            snapshot in
            let arraySnapshot = (snapshot.children.allObjects as! [DataSnapshot]).reversed()
            arraySnapshot.forEach({ (child) in
                if let dict = child.value as? [String: Any] {
                    let post = Post.transformPostPhoto(dict: dict, key: child.key)
                    completion(post)
                }
            })
        })
    }
    
    /// Topic: Media
    func observeMedia(completion: @escaping (Post) -> Void) {
        REF_POSTS.queryOrdered(byChild: "hashtag").queryStarting(atValue: "media").observeSingleEvent(of: .value, with: {
            snapshot in
            let arraySnapshot = (snapshot.children.allObjects as! [DataSnapshot]).reversed()
            arraySnapshot.forEach({ (child) in
                if let dict = child.value as? [String: Any] {
                    let post = Post.transformPostPhoto(dict: dict, key: child.key)
                    completion(post)
                    //print(dict)
                }
            })
        })
    }
    
    /// Topic: Finance
    func observeFinance(completion: @escaping (Post) -> Void) {
        REF_POSTS.queryOrdered(byChild: "hashtag").queryStarting(atValue: "finance").observeSingleEvent(of: .value, with: {
            snapshot in
            let arraySnapshot = (snapshot.children.allObjects as! [DataSnapshot]).reversed()
            arraySnapshot.forEach({ (child) in
                if let dict = child.value as? [String: Any] {
                    let post = Post.transformPostPhoto(dict: dict, key: child.key)
                    completion(post)
                    //print(dict)
                }
            })
        })
    }
    
    /// Topic: Health
    func observeHealth(completion: @escaping (Post) -> Void) {
        REF_POSTS.queryOrdered(byChild: "hashtag").queryStarting(atValue: "health").observeSingleEvent(of: .value, with: {
            snapshot in
            let arraySnapshot = (snapshot.children.allObjects as! [DataSnapshot]).reversed()
            arraySnapshot.forEach({ (child) in
                if let dict = child.value as? [String: Any] {
                    let post = Post.transformPostPhoto(dict: dict, key: child.key)
                    completion(post)
                    //print(dict)
                }
            })
        })
    }
    
    /// Topic: Beauty
    func observeBeauty(completion: @escaping (Post) -> Void) {
        REF_POSTS.queryOrdered(byChild: "hashtag").queryStarting(atValue: "beauty").observeSingleEvent(of: .value, with: {
            snapshot in
            let arraySnapshot = (snapshot.children.allObjects as! [DataSnapshot]).reversed()
            arraySnapshot.forEach({ (child) in
                if let dict = child.value as? [String: Any] {
                    let post = Post.transformPostPhoto(dict: dict, key: child.key)
                    completion(post)
                    //print(dict)
                }
            })
        })
    }
    
    /// Topic: LGBT
    func observeLgbt(completion: @escaping (Post) -> Void) {
        REF_POSTS.queryOrdered(byChild: "hashtag").queryStarting(atValue: "lgbt").observeSingleEvent(of: .value, with: {
            snapshot in
            let arraySnapshot = (snapshot.children.allObjects as! [DataSnapshot]).reversed()
            arraySnapshot.forEach({ (child) in
                if let dict = child.value as? [String: Any] {
                    let post = Post.transformPostPhoto(dict: dict, key: child.key)
                    completion(post)
                    //print(dict)
                }
            })
        })
    }
}
