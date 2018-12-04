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

    /// Topic: Food
    func observeFood(completion: @escaping (Post) -> Void) {
        REF_POSTS.queryOrdered(byChild: "hashtag").queryEqual(toValue: "food").observeSingleEvent(of: .value, with: {
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
    
    /// Topic: Education
    func observeEducation(completion: @escaping (Post) -> Void) {
        REF_POSTS.queryOrdered(byChild: "hashtag").queryEqual(toValue: "education").observeSingleEvent(of: .value, with: {
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
    
    /// Topic: Tech
    func observeTech(completion: @escaping (Post) -> Void) {
        REF_POSTS.queryOrdered(byChild: "hashtag").queryEqual(toValue: "tech").observeSingleEvent(of: .value, with: {
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
    
    /// Topic: Travel
    func observeTravel(completion: @escaping (Post) -> Void) {
        REF_POSTS.queryOrdered(byChild: "hashtag").queryEqual(toValue: "travel").observeSingleEvent(of: .value, with: {
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
    
    /// Topic: Lifestyle
    func observeLifestyle(completion: @escaping (Post) -> Void) {
        REF_POSTS.queryOrdered(byChild: "hashtag").queryEqual(toValue: "lifestyle").observeSingleEvent(of: .value, with: {
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
    
    /// Topic: Politics
    func observePolitics(completion: @escaping (Post) -> Void) {
        REF_POSTS.queryOrdered(byChild: "hashtag").queryEqual(toValue: "politics").observeSingleEvent(of: .value, with: {
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
        
        REF_POSTS.queryOrdered(byChild: "hashtag").queryEqual(toValue: "media").observeSingleEvent(of: .value, with: {
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
    
    /// Topic: Finance
    func observeFinance(completion: @escaping (Post) -> Void) {
        REF_POSTS.queryOrdered(byChild: "hashtag").queryEqual(toValue: "finance").observeSingleEvent(of: .value, with: {
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
    
    /// Topic: Health
    func observeHealth(completion: @escaping (Post) -> Void) {
        REF_POSTS.queryOrdered(byChild: "hashtag").queryEqual(toValue: "health").observeSingleEvent(of: .value, with: {
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
    
    /// Topic: Beauty
    func observeBeauty(completion: @escaping (Post) -> Void) {
        REF_POSTS.queryOrdered(byChild: "hashtag").queryEqual(toValue: "beauty").observeSingleEvent(of: .value, with: {
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
    
    /// Topic: LGBT
    func observeLgbt(completion: @escaping (Post) -> Void) {
        REF_POSTS.queryOrdered(byChild: "hashtag").queryEqual(toValue: "lgbt").observeSingleEvent(of: .value, with: {
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
}
