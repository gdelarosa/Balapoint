//
//  TechViewController.swift
//  Jundera
//
//  Created by Gina De La Rosa on 11/29/18.
//  Copyright © 2018 Gina De La Rosa. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class TechViewController: UIViewController {
    
    @IBOutlet weak var techTableView: UITableView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    var post = Post()
    var postIds: [String: Any]?
    var postSnapshots = [DataSnapshot]()
    var loadingPostCount = 0
    
    
    var posts = [Post]()
    var users = [Userr]()
    
    private var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackButton()
        loadUserPosts()
        techTableView.isHidden = false
        activityView.isHidden = true
        if posts.count == 0 {
            activityView.stopAnimating()
        }
    }
    
    // Setup View
    private func setupView() {
        setupTableView()
        setupActivityIndicatorView()
    }
    
    // Setup TableView
    private func setupTableView() {
        techTableView.isHidden = false
        if #available(iOS 10.0, *) {
            techTableView.refreshControl = refreshControl
        } else {
            techTableView.addSubview(refreshControl)
        }
        
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        techTableView.estimatedRowHeight = 521
       techTableView.rowHeight = UITableViewAutomaticDimension
        techTableView.dataSource = self
        techTableView.allowsSelection = true
    }
    
    // Refreshes data
    @objc private func refreshData(_ sender: Any) {
        
    }
    
    // Activity Indicator Setup
    private func setupActivityIndicatorView() {
        activityView.startAnimating()
    }
    
    private func updateView() {
        let hasPosts = posts.count > 0
        techTableView.isHidden = !hasPosts
        
        if hasPosts {
            techTableView.reloadData()
        }
        self.activityView.stopAnimating()
    }
    
    func loadUserPosts() {
        Api.HashTag.observeTech { (post) in
            guard let postUid = post.uid else { return }
            //print("The post uid is: \(postUid)")
            self.fetchUser(uid: postUid, completed: {
                self.posts.append(post)
                self.techTableView.reloadData()
                //                self.posts.sort(by: {(p1, p2) -> Bool in
                //                    return p1.date?.compare(p2.date!) == .orderedDescending
                //                })
                //self.updateView()
                //self.refreshControl.endRefreshing()
                //self.activityIndicatorView.stopAnimating()
            })
        }
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

extension TechViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath) as! TopicDetailTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.post = posts[indexPath.row]
        cell.userTest = users[indexPath.row]
        cell.delegate = self
        
        return cell
    }
}

// MARK: Segue Actions
extension TechViewController: DetailTopicDelegate {
    
    func goToDetailPostVC(postId: String) {
        performSegue(withIdentifier: "DetailPost_Segue", sender: postId)
    }
    
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "Home_ProfileSegue", sender: userId)
    }
}
