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

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        searchBar.frame.size.width = view.frame.size.width - 60
        
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = searchItem
        setBackButton()
        doSearch()
    }
    
//    func setBackButton() {
//        //Back buttion
//        let btnLeftMenu: UIButton = UIButton()
//        btnLeftMenu.setImage(UIImage(named: "back"), for: UIControlState())
//        btnLeftMenu.addTarget(self, action: #selector(SearchViewController.onClickBack), for: UIControlEvents.touchUpInside)
//        btnLeftMenu.frame = CGRect(x: 0, y: 0, width: 33/2, height: 27/2)
//        let barButton = UIBarButtonItem(customView: btnLeftMenu)
//        self.navigationItem.leftBarButtonItem = barButton
//    }
//    
//    @objc func onClickBack()
//    {
//        _ = self.navigationController?.popViewController(animated: true)
//    }
    
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
           // profileVC.delegate = self
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

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        let post = posts[indexPath.row]
        cell.post = post
        cell.delegate = self as? HomeTableViewCellDelegate
        return cell
    }
}

// Will want to segue to the detail view of the post.
extension SearchViewController: PeopleTableViewCellDelegate {
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
