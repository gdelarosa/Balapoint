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
        setNavButtons()
        setBackButton()
        tableView.allowsSelection = true
    }
    
    func setNavButtons() {
        let button: UIButton = UIButton(type: UIButtonType.custom)
        button.setImage(UIImage(named: "SaveInCell.png"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(savePost), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x:0.0,y:0.0, width:25,height: 25.0)
        let barRightButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barRightButton
    }

    @objc func savePost() {
        print("Save post selected")
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Home_ProfileSegue" {
            let profileVC = segue.destination as! ProfileUserViewController
            let userID = sender  as! String
            profileVC.userId = userID
        }
    }
    
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
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
    
    func imageTapped(image:UIImage) {
        let newImageView = UIImageView(image: image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .white
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullscreenImage(_:)))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
}

extension DetailViewController: HomeTableViewCellDelegate {
    func didSavePost(post: Post) {
        print("Saved POST!")
    }
    
    func goToDetailPostVC(postId: String) {
        print("Going to Detail Post")
        performSegue(withIdentifier: "DetailPost_Segue", sender: postId)
    }
    
    func goToProfileUserVC(userId: String) {
        print("Going to Profile")
        performSegue(withIdentifier: "Home_ProfileSegue", sender: userId)
    }
}
