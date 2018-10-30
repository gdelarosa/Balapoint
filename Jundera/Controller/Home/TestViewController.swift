//
//  TestViewController.swift
//  Jundera
//
//  Created by Gina De La Rosa on 10/30/18.
//  Copyright © 2018 Gina De La Rosa. All rights reserved.
//

import UIKit
import Firebase

class TestViewController: UIViewController {
    
    @IBOutlet weak var exploreTableView: UITableView!
    
    var posts: [Post] = []
    var users = [Userr]()
    var postIds: [String: Any]?
    var postSnapshots = [DataSnapshot]()
    var loadingPostCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
//    func loadUserPosts() {
//        Database.database().reference(withPath: "hashtags/film").observeSingleEvent(of: .value, with: {
//            if var posts = $0.value as? [String: Any] {
//                if !self.postSnapshots.isEmpty {
//                    var index = self.postSnapshots.count - 1
//                    self.tableView?.performBatchUpdates({
//                        for post in self.postSnapshots.reversed() {
//                            if posts.removeValue(forKey: post.key) == nil {
//                                self.postSnapshots.remove(at: index)
//                                self.tableView?.deleteItems(at: [IndexPath(item: index, section: 0)])
//                                return
//                            }
//                            index -= 1
//                        }
//                    }, completion: nil)
//                    self.postIds = posts
//                    self.loadingPostCount = posts.count
//                } else {
//                    self.postIds = posts
//                    self.loadFeed()
//                }
//                self.registerForPostsDeletion()
//            }
//        })
//    }

}

extension TestViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        //let post = posts[indexPath.row]
        //cell.post = post
        cell.delegate = self as? HomeTableViewCellDelegate
        return cell
    }
}
