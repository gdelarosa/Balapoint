//
//  SearchViewController.swift
//  Balapoint
//
//  Created by Gina De La Rosa on 10/15/18.
//  Copyright © 2017 Gina Delarosa. All rights reserved.
//  Search Bar - Will put this on the HomeViewController

import UIKit


class SearchViewController: UIViewController {

    var searchBar = UISearchBar()
    var users: [Userr] = []
    var posts: [Post] = []
    //var tags: [Hashtag] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search users"
        searchBar.frame.size.width = view.frame.size.width - 60
        
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = searchItem
        setBackButton()
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
            self.users.removeAll()
            self.tableView.reloadData()
            Api.Userr.queryUsers(withText: searchText, completion: { (user) in
                    self.users.append(user)
                    self.tableView.reloadData()
                })
//            Api.Userr.queryTags(withText: searchText, completion: {(tags) in
//                self.tags.append(tags)
//                self.tableView.reloadData()
//            })
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Search_ProfileSegue" {
            let profileVC = segue.destination as! ProfileUserViewController
            let userId = sender  as! String
            profileVC.userId = userId
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
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        let user = users[indexPath.row]
        cell.user = user
        cell.delegate = self
        return cell
    }
}
extension SearchViewController: SearchTableViewCellDelegate {
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "Search_ProfileSegue", sender: userId)
    }
}


