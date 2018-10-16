//
//  HomeViewController.swift
//  Metis
//
//  Created by Gina De La Rosa on 12/15/17.
//  Copyright © 2017 Gina Delarosa. All rights reserved.
//  What user will first see after logging in or signing up.
    
import UIKit
import SDWebImage
import Segmentio

class HomeViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var swipeMenu: Segmentio!
    
    var posts = [Post]()
    var users = [Userr]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 521
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        loadPosts()
        loadMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    /// Swipe Menu using Segmentio Pod
    func loadMenu() {
        swipeMenu.setup(content: segmentioContent(),
                        style: SegmentioStyle.onlyLabel,
                        options: segmentioOptions())

        swipeMenu.selectedSegmentioIndex = 0
        swipeMenu.valueDidChange = { segmentio, segmentIndex in
            print("Selected item: ", segmentIndex)
        }
    }
    
   func segmentioOptions() -> SegmentioOptions {
    
    let SegmentioStates = (
        defaultState: SegmentioState(
            backgroundColor: .clear,
            titleFont: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
            titleTextColor: .black
        ),
        selectedState: SegmentioState(
            backgroundColor: .white,
            titleFont: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
            titleTextColor: .black
        ),
        highlightedState: SegmentioState(
            backgroundColor: UIColor.lightGray.withAlphaComponent(0.6),
            titleFont: UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize),
            titleTextColor: .black
        )
    )
        
        return SegmentioOptions(
            backgroundColor: .white,
            segmentPosition: SegmentioPosition.fixed(maxVisibleItems: 5),
            scrollEnabled: true,
            indicatorOptions: SegmentioIndicatorOptions(),
            horizontalSeparatorOptions: SegmentioHorizontalSeparatorOptions(),
            verticalSeparatorOptions: nil,
            imageContentMode: .center,
            labelTextAlignment: .center,
            labelTextNumberOfLines: 1,
            segmentStates: SegmentioStates,
            animationDuration: 0.3
        )

    }

     func segmentioContent() -> [SegmentioItem] {
        return [
            SegmentioItem(title: "Home", image: nil),
            SegmentioItem(title: "Tech", image: nil),
            SegmentioItem(title: "Food", image: nil),
            SegmentioItem(title: "Travel", image: nil),
            SegmentioItem(title: "Beauty", image: nil),
            SegmentioItem(title: "Politics", image: nil),
            SegmentioItem(title: "College", image: nil),
            SegmentioItem(title: "Health", image: nil),
            SegmentioItem(title: "Science", image: nil)
        ]
    }
    
    fileprivate func goToControllerAtIndex(_ index: Int) {
        swipeMenu.selectedSegmentioIndex = index
    }
    
    /// Will load all posts onto users feed.
    
    func loadPosts() {
        
        Api.Feed.observeFeed(withId: Api.Userr.CURRENT_USER!.uid) { (post) in
            guard let postUid = post.uid else {
                return
            }
            self.fetchUser(uid: postUid, completed: {
                self.posts.append(post)
                self.tableView.reloadData()
            })
        }
        
        Api.Feed.observeFeedRemoved(withId: Api.Userr.CURRENT_USER!.uid) { (post) in
            self.posts = self.posts.filter { $0.id != post.id }
            self.users = self.users.filter { $0.id != post.uid }
            
            self.tableView.reloadData()
        }
    }
    
    func fetchUser(uid: String, completed:  @escaping () -> Void ) {
        Api.Userr.observeUser(withId: uid, completion: {
            user in
            self.users.append(user)
            completed()
        })
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "CommentSegue" {
//            let commentVC = segue.destination as! CommentViewController
//            let postId = sender  as! String
//            commentVC.postId = postId
//        }
//        
//        if segue.identifier == "Home_ProfileSegue" {
//            let profileVC = segue.destination as! ProfileUserViewController
//            let userId = sender  as! String
//            profileVC.userId = userId
//        }
//    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomeTableViewCell
        let post = posts[indexPath.row]
        let user = users[indexPath.row]
        cell.post = post
        cell.user = user
        cell.delegate = self
        return cell
    }
    
}

extension HomeViewController: HomeTableViewCellDelegate {
    
    func goToCommentVC(postId: String) {
        performSegue(withIdentifier: "CommentSegue", sender: postId)
    }
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "Home_ProfileSegue", sender: userId)
    }
}
