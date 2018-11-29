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
        //loadFeed()
        loadUserPosts()
        exploreTableView.isHidden = false
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
//    func loadFeed() {
//        loadingPostCount = posts.count + 12
//        self.exploreTableView?.performBatchUpdates({
//            for _ in 1...12 {
//                if let postId = self.postIds?.popFirst()?.key {
//                    
//                  //  Database.database().reference(withPath: "posts/\(postId)").observeSingleEvent(of: .value, with: { snapshot in
//                        
//                        //Api.Post.observeHashtag { (post) in
////                            Database.database().reference(withPath: "posts/\(postId)").observeSingleEvent(of: .value, with : {
////                                snapshot in
////                                self.posts.append(post)
////                                self.exploreTableView.reloadData()
////                            })
//                    
//                        }
////                        Api.Post.observePost(withId: postId, completion: { post in
////                            self.posts.append(post)
////                            self.exploreTableView?.insertRows(at: [IndexPath(item: self.posts.count - 1, section: 0)], with: UITableViewRowAnimation.none)
////                        })
////                        let post = Post.transformPostPhoto(dict: self.postIds!, key: snapshot.key)
////                        self.posts.append(post)
////                        self.exploreTableView?.insertRows(at: [IndexPath(item: self.posts.count - 1, section: 0)], with: UITableViewRowAnimation.none)
////                        print("Data: \(post), \(snapshot.key), \(snapshot) \(String(describing: self.postIds))")
//                   // })
//                } else {
//                    break
//                }
//            }
//        }, completion: nil)
//    }
    
    func loadUserPosts() {
        Api.Post.observeTopPosts { (post) in
            guard let postUid = post.uid else { return }
            //print("The post uid is: \(postUid)")
            self.fetchUser(uid: postUid, completed: {
                self.posts.append(post)
                 self.exploreTableView.reloadData()
//                self.posts.sort(by: {(p1, p2) -> Bool in
//                    return p1.date?.compare(p2.date!) == .orderedDescending
//                })
                
                //self.updateView()
                //self.refreshControl.endRefreshing()
                //self.activityIndicatorView.stopAnimating()
            })
           // self.posts.append(post)
//            self.exploreTableView.reloadData()
        }
//        Api.Post.observeHashtag { (post) in
//            //self.posts.append(post)
//           // self.exploreTableView.reloadData()
//            self.loadFeed()
//        }
//        Database.database().reference(withPath: "hashtag/media").observeSingleEvent(of: .value, with: {
//            if let posts = $0.value as? [String: Any] {
//                self.postIds = posts
//                self.loadingPostCount = posts.count
//                self.loadFeed()
//                print(posts)
//            }
//        })
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
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath) as! TestDetailTableViewCell
    
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.post = posts[indexPath.row]
        cell.delegate = self
        cell.captionLabel.text = post.caption
        
        if let photoUrlString = post.photoUrl {
            let photoUrl = URL(string: photoUrlString)
            cell.postImageView.sd_setImage(with: photoUrl)
        } else {
            print("Unable to get photo")
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
