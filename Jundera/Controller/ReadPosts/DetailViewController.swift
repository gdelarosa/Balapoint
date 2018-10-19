//
//  DetailViewController.swift
//  Metis
//
//  Created by Gina De La Rosa on 11/15/17.
//  Copyright © 2017 Gina Delarosa. All rights reserved.
//  Allows user to view a post after clicking on it. 

import UIKit

class DetailViewController: UIViewController {

    var postId = ""
    var post = Post()
    var user = Userr()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPost()
        setBackButton()
    }
    
    func setBackButton() {
        //Back buttion
        let btnLeftMenu: UIButton = UIButton()
        btnLeftMenu.setImage(UIImage(named: "back"), for: UIControlState())
        btnLeftMenu.addTarget(self, action: #selector(DetailViewController.onClickBack), for: UIControlEvents.touchUpInside)
        btnLeftMenu.frame = CGRect(x: 0, y: 0, width: 33/2, height: 27/2)
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func onClickBack()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }

    func loadPost() {
        Api.Post.observePost(withId: postId) { (post) in
            guard let postUid = post.uid else {
                return
            }
            self.fetchUser(uid: postUid, completed: {
                self.post = post
                self.tableView.reloadData()
            })
        }
    }
    
    func fetchUser(uid: String, completed:  @escaping () -> Void ) {
        Api.Userr.observeUser(withId: uid, completion: {
            user in
            self.user = user
            completed()
        })
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "Detail_CommentVC" {
//            let commentVC = segue.destination as! CommentViewController
//            let postId = sender  as! String
//            commentVC.postId = postId
//        }
//        
//        if segue.identifier == "Detail_ProfileUserSegue" {
//            let profileVC = segue.destination as! ProfileUserViewController
//            let userId = sender  as! String
//            profileVC.userId = userId
//        }
//    }
    
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailPostCell", for: indexPath) as! DetailPostTableViewCell
        cell.post = post
        cell.user = user
        cell.detailDelegate = self as? DetailPostTableViewCellDelegate
        return cell
    }
}

extension DetailViewController: HomeTableViewCellDelegate {
    func goToDetailPostVC(postId: String) {
        performSegue(withIdentifier: "DetailPost_Segue", sender: postId)
    }
    
    func goToCommentVC(postId: String) {
        performSegue(withIdentifier: "Detail_CommentVC", sender: postId)
    }
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "Detail_ProfileUserSegue", sender: userId)
    }
}
