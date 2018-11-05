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
    var users = [Userr]()
    var post: Post? //testing
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.reloadData()
//        if self.posts.isEmpty {
//            self.collectionView?.backgroundView = self.emptyHomeLabel
//        }
        fetchMySavedPosts()
      
        self.navigationItem.title = "Saved"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Futura", size: 18)!]
    }
    
    //Empty State Label
    let emptyHomeLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.text = "Oh...\n Save posts and have them appear here."
        messageLabel.textColor = #colorLiteral(red: 0.1538375616, green: 0.1488625407, blue: 0.1489177942, alpha: 1)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "Futura", size: 20)
        messageLabel.sizeToFit()
        return messageLabel
    }()
    
    /// Will display saved posts
    func fetchMySavedPosts() {
        guard let currentUser = Api.Userr.CURRENT_USER else {
            return
        }
        Api.MySavedPosts.REF_MYSAVEDPOSTS.child(currentUser.uid).observe(.childAdded, with: {
            snapshot in
            Api.Post.observePost(withId: snapshot.key, completion: {
                post in
                self.posts.append(post)
                self.collectionView.reloadData()
            })
            
        })
    }
    
    // Fetches User
    func fetchUser(uid: String, completed:  @escaping () -> Void ) {
        Api.Userr.observeUser(withId: uid, completion: {
            user in
            self.users.append(user)
            completed()
        })
        
    }
    
    // Will go to Detail Post
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail_Segue" {
            let detailVC = segue.destination as! DetailViewController
            let postId = sender  as! String
            detailVC.postId = postId
        }
    }
}

extension SavedPostsViewController: UICollectionViewDataSource {
    // Will load number of saved posts
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    // Will display the saved posts
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedCollectionViewCell", for: indexPath) as! SavedPostsCollectionViewCell
        let post = posts[indexPath.row]
        cell.post = post
        cell.delegate = self
        return cell
    }
}

// Performs Segue to Detail Post
extension SavedPostsViewController: SavedCollectionViewCellDelegate {
    func goToDetailSavedPost(postId: String) {
        performSegue(withIdentifier: "Detail_Segue", sender: postId)
    }
    
    func goToPersonProfile(userId: String) {
        performSegue(withIdentifier: "User_profileSegue", sender: userId)
    }
}

