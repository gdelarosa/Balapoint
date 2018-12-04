//
//  SavedPostsViewController.swift
//  Balapoint
//
//  Created by Gina De La Rosa on 11/15/17.
//  Copyright © 2017 Gina Delarosa. All rights reserved.
//  User will be able to view their saved post

import UIKit
import Firebase

class SavedPosts {
    var thePosts = [SavedPosts]()
    var key = ""
}

class SavedPostsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var posts = [Post]()
    var users = [Userr]()
    var post: Post?
    
    private var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
        fetchMySavedPosts()
    }
    
    func setupNavigation() {
        self.navigationItem.title = "Saved"
    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Futura", size: 18)!]
    }
    
    func setupView() {
        setupCollectionView()
        setupMessageLabel()
        setupActivityIndicatorView()
    }
    
    private func setupCollectionView() {
        collectionView.isHidden = true
        
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        collectionView.dataSource = self
    }
    
    
    @objc private func refreshData(_ sender: Any) {
        fetchMySavedPosts()
    }
    
    // Activity Indicator Setup
    private func setupActivityIndicatorView() {
        activityIndicatorView.startAnimating()
    }
    
    private func updateView() {
        let hasPosts = posts.count > 0
        collectionView.isHidden = !hasPosts
        messageLabel.isHidden = hasPosts
        
        if hasPosts {
            collectionView.reloadData()
        }
        
        self.activityIndicatorView.stopAnimating()
       
    }
    
    private func setupMessageLabel() {
        messageLabel.isHidden = true
        messageLabel.text = "Your saved posts will appear here 🔒."
    }
    
    /// Will display saved posts
    func fetchMySavedPosts() {
        guard let currentUser = Api.Userr.CURRENT_USER else { return }
    Api.MySavedPosts.REF_MYSAVEDPOSTS.child(currentUser.uid).observe(.childAdded, with: {
            snapshot in
            DispatchQueue.main.async {
            self.posts.removeAll()
            Api.Post.observePost(withId: snapshot.key, completion: {
                post in
                guard let postUid = post.uid else { return }
                self.fetchUser(uid: postUid, completed: {
                    self.posts.append(post)
                    self.posts.sort(by: {(p1, p2) -> Bool in
                        return p1.date?.compare(p2.date!) == .orderedDescending
                    })
                    
                    self.updateView()
                    self.refreshControl.endRefreshing()
                    self.activityIndicatorView.stopAnimating()
                })
            })
           }
        })
       Api.MySavedPosts.REF_MYSAVEDPOSTS.child(currentUser.uid).observe(.childRemoved, with: { snapshot in
        Api.Post.observePost(withId: snapshot.key , completion: { post in
            if let index = self.posts.index(where: {$0.id == snapshot.key}) {
                self.posts.remove(at: index)
                self.collectionView.reloadData()
            } else {
                print("Post not found")
              }
            })
        })
        self.updateView()
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
        
        if segue.identifier == "User_profileSegue" {
            let personVC = segue.destination as! ProfileUserViewController
            let userId = sender as! String
            personVC.userId = userId
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
        cell.post = posts[indexPath.row]
        cell.user = users[indexPath.row]
        cell.delegate = self
        return cell
    }
}

// Performs Segue to Detail Post
extension SavedPostsViewController: SavedCollectionViewCellDelegate {
    
    func unsavePost(post: Post) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("saved").child(uid)
        guard let postId = post.id else { return }
        
        let values = [postId: post.uid]
        
        if post.isSaved == true {
            ref.updateChildValues(values as [AnyHashable : Any]) { (err, ref) in
                if let err = err {
                    print("Failed to put save post data in db:", err)
                    return
                }
                print("Successfully put save post in db")
            }
        } else {
            ref.child(post.id!).removeValue {_,_ in
                print("Post is unsaved from SavedPostsVC")
            }
        }
        
    }
    
    func goToDetailSavedPost(postId: String) {
        performSegue(withIdentifier: "Detail_Segue", sender: postId)
    }
    
    func goToPersonProfile(userId: String) {
        performSegue(withIdentifier: "User_profileSegue", sender: userId)
    }
}

