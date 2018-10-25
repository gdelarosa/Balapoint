//
//  SavedPostsViewController.swift
//  Balapoint
//
//  Created by Gina De La Rosa on 11/15/17.
//  Copyright © 2017 Gina Delarosa. All rights reserved.
//

import UIKit
import Firebase

class SavedPostsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        //collectionView.delegate = self
        
       //fetchMySavedPosts1()
       fetchMySavedPosts2()
    }
    
    @IBAction func refresh_TouchUpInside(_ sender: Any) {
      
    }
    func fetchMySavedPosts2() { //Working. 
        guard let currentUser = Api.Userr.CURRENT_USER else {
            return
        }
        Api.MySavedPosts.REF_MYSAVEDPOSTS.child(currentUser.uid).observe(.childAdded, with: { //
            snapshot in
            Api.Post.observePost(withId: snapshot.key, completion: {
                post in
                self.posts.append(post)
                self.collectionView.reloadData()
            })
        })//
    }
    // Display User's Saved Posts - Not working
    func fetchMySavedPosts1() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("saved").child(uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            print("Posts Liked: \(snapshot.value ?? "")")
            if let savedPostsDict = snapshot.value as? [String: Any] {
                savedPostsDict.forEach({ (uid, postId) in
                    print("The post UID is \(uid). \n The postiD is \(postId)")
                    let postRef = Database.database().reference().child("posts")
                    postRef.child(uid).child(postId as! String).observeSingleEvent(of: .value, with: { snapshot in

                            guard let dict = snapshot.value as? [String:Any] else {
                                print("Unable to return dict")
                                return
                        }
                            
                            let post = Post.transformPostPhoto(dict: dict, key: snapshot.key)
                        
                            post.id = postId as? String

                            self.posts.append(post)
                            self.collectionView?.reloadData()
                           print("Testing son")
                        }, withCancel: { (err) in
                            print("Failed to fetch post from db:", err)
                        })
                })
            }
        }) { (err) in
            print("Failed to fetch saved posts from db:", err)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Discover_DetailSegue" {
            let detailVC = segue.destination as! DetailViewController
            let postId = sender  as! String
            detailVC.postId = postId
        }
    }
}

extension SavedPostsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! ProfilePosts
        let post = posts[indexPath.row]
        cell.post = post
        cell.delegate = self

        return cell
    }
}

//extension SavedPostsViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 2
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.size.width / 3 - 1, height: collectionView.frame.size.width / 3 - 1)
//    }
//}

extension SavedPostsViewController: PhotoCollectionViewCellDelegate {
    func goToDetailVC(postId: String) {
        performSegue(withIdentifier: "Discover_DetailSegue", sender: postId)
    }

}

