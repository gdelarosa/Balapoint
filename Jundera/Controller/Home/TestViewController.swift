//
//  TestViewController.swift
//  Jundera
//
//  Created by Gina De La Rosa on 10/30/18.
//  Copyright © 2018 Gina De La Rosa. All rights reserved.
//  Goes to selected Topic when tapped 

import UIKit
import Firebase
import SDWebImage

class TestViewController: UIViewController {
    
    @IBOutlet weak var exploreTableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    
    var post = Post()
    var postIds: [String: Any]?
    var postSnapshots = [DataSnapshot]()
    var loadingPostCount = 0
    
    
    var posts = [Post]()
    var users = [Userr]()
    
    private var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserPosts()
        exploreTableView.isHidden = false
        //loadPosts()
       // setupView()
        activityIndicatorView.isHidden = true
        if posts.count == 0 {
            activityIndicatorView.stopAnimating()
        }
    }

// Setup View
private func setupView() {
    setupTableView()
    setupActivityIndicatorView()
}

// Setup TableView
private func setupTableView() {
    exploreTableView.isHidden = false
    if #available(iOS 10.0, *) {
        exploreTableView.refreshControl = refreshControl
    } else {
        exploreTableView.addSubview(refreshControl)
    }
    
    // Configure Refresh Control
    refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    exploreTableView.estimatedRowHeight = 521
    exploreTableView.rowHeight = UITableViewAutomaticDimension
    exploreTableView.dataSource = self
    exploreTableView.allowsSelection = true
}

// Refreshes data
@objc private func refreshData(_ sender: Any) {
    
}

// Activity Indicator Setup
private func setupActivityIndicatorView() {
    activityIndicatorView.startAnimating()
}

private func updateView() {
    let hasPosts = posts.count > 0
    exploreTableView.isHidden = !hasPosts
   
    if hasPosts {
        exploreTableView.reloadData()
    }
    self.activityIndicatorView.stopAnimating()
}
    func loadFeed() {
        loadingPostCount = postSnapshots.count + 12
        self.exploreTableView?.performBatchUpdates({
            for _ in 1...12 {
                if let postId = self.postIds?.popFirst()?.key {
                    Database.database().reference(withPath: "posts/\(postId)").observeSingleEvent(of: .value, with: { postSnapshot in
                        self.postSnapshots.append(postSnapshot)
                        self.exploreTableView?.insertRows(at: [IndexPath(item: self.postSnapshots.count - 1, section: 0)], with: UITableViewRowAnimation.none)
                    })
                } else {
                    break
                }
            }
        }, completion: nil)
    }
    
    func loadUserPosts() {
        Database.database().reference(withPath: "hashtag/media").observeSingleEvent(of: .value, with: {
            if let posts = $0.value as? [String: Any] {
                self.postIds = posts
                self.loadingPostCount = posts.count
                self.loadFeed()
                print("Post \(posts)")
            }
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
    
    // Save posts
    func didSavePost(post: Post) {
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
                print("Post is unsaved from HomeVC")
            }
        }
    }
    
    func didUnsavePost(post: Post) {
        print("This function is unused")
    }
    
    // Will segue go to DetailVC is title of post is selected.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailPost_Segue" {
            print("Segue to Detail from HOME VC")
            let detailVC = segue.destination as! DetailViewController
            let postID = sender  as! String
            detailVC.postId = postID
        }
        // Go to Profile View Controller
        if segue.identifier == "Home_ProfileSegue" {
            print("Segue to profile from HomeVC")
            let profileVC = segue.destination as! ProfileUserViewController
            let userID = sender  as! String
            profileVC.userId = userID
        }
    }

}

extension TestViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postSnapshots.count
            //posts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath) as! TestDetailTableViewCell
//        let post = posts[indexPath.row]
//        //let user = users[indexPath.row]
//        cell.selectionStyle = UITableViewCellSelectionStyle.none
//        cell.post = post
//        //cell.user = user
//        cell.delegate = self
//        self.exploreTableView.reloadData()
        
        
        let postSnapshot = postSnapshots[indexPath.row]

        if let value = postSnapshot.value as? [String: Any], let photoUrl = value["photoUrl"] as? String {
          
           // let imageView = UIImageView()
            cell.postImageView.sd_setImage(with: URL(string: photoUrl), completed: nil)
            
//            cell.backgroundView = imageView
//            imageView.sd_setImage(with: URL(string: photoUrl), completed: nil)
//            imageView.contentMode = .scaleAspectFill
//            imageView.isAccessibilityElement = true
            //imageView.accessibilityLabel = "Photo with hashtag \(hashtag)"
        }
        
        return cell
    }
}

// MARK: Segue Actions
extension TestViewController: DetailTopicDelegate {
    
    func goToDetailPostVC(postId: String) {
        performSegue(withIdentifier: "DetailPost_Segue", sender: postId)
    }
    
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "Home_ProfileSegue", sender: userId)
    }
}
