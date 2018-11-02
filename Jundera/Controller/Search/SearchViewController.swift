//
//  SearchViewController.swift
//  Metis
//
//  Created by Gina De La Rosa on 11/15/17.
//  Copyright © 2017 Gina Delarosa. All rights reserved.
//  Search Bar - Will put this on the HomeViewController

import UIKit

class SearchViewController: UIViewController {

    var searchBar = UISearchBar()
    //var users: [Userr] = []
    var posts: [Post] = []
    var post: Post?
    var delegate: HomeTableViewCellDelegate?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.posts.removeAll()
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search Posts"
        searchBar.frame.size.width = view.frame.size.width - 60
        
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = searchItem
        setBackButton()
        tableView.allowsSelection = true
        //doSearch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.global(qos: .default).async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.searchBar.becomeFirstResponder()
                self.tableView.reloadData()
            })
        })
        navigationController?.navigationBar.tintColor = .gray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = .white
    }
    
    func doSearch() {
        if let searchText = searchBar.text {
            self.posts.removeAll()
            self.tableView.reloadData()
                Api.Userr.queryPosts(withText: searchText, completion: { (post) in
                       //self.post.isPublic = value
                        self.posts.append(post)
                        self.tableView.reloadData()
                    })
            
        }
    }
    
    func isFollowing(userId: String, completed: @escaping (Bool) -> Void) {
        Api.Follow.isFollowing(userId: userId, completed: completed)
    }
    
    // Should prepare to go to detail post. See HOMEVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Search_ProfileSegue" {
            let profileVC = segue.destination as! ProfileUserViewController
            let userId = sender  as! String
            profileVC.userId = userId
        }
        if segue.identifier == "DetailPost_Segue" {
            let detailVC = segue.destination as! DetailViewController
            let postID = sender  as! String
            detailVC.postId = postID
        }
    }

}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        doSearch()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        doSearch()
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        let post = posts[indexPath.row]
        cell.post = post
        //cell.delegate = self as? HomeTableViewCellDelegate
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Section \(indexPath.section), Row : \(indexPath.row)")
        
        tableView.deselectRow(at: indexPath, animated: false)
    }

}

// Will want to segue to the detail view of the post.
extension SearchViewController: HomeTableViewCellDelegate {
    
    func goToDetailPostVC(postId: String) {
        performSegue(withIdentifier: "DetailPost_Segue", sender: postId)
    }
    
    func didSavePost(post: Post) {
        print("Nothing happening here")
    }
    
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "Search_ProfileSegue", sender: userId)
    }
}
// Wont need
//extension SearchViewController: HeaderProfileCollectionReusableViewDelegate {
//    func updateFollowButton(forUser user: Userr) {
//        for u in self.users {
//            if u.id == user.id {
//                u.isFollowing = user.isFollowing
//                self.tableView.reloadData()
//            }
//        }
//    }
//}
