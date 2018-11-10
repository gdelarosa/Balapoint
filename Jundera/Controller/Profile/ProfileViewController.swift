//
//  ProfileViewController.swift
//  Balapoint
//
//  Created by Gina De La Rosa on 11/15/17.
//  Copyright © 2017 Gina Delarosa. All rights reserved.

//  User Profile - User can edit their information and view their posts

import UIKit
import Firebase
//import Segmentio

class ProfileViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var userId = ""
    var user: Userr!
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        if self.posts.isEmpty {
            self.collectionView?.backgroundView = self.emptyHomeLabel
        }
        fetchUser()
        fetchMyPosts()
        settingsBarButton()
    }
    
    //Empty State Label
    let emptyHomeLabel: UILabel = {
        let messageLabel = UILabel()
        //messageLabel.text = "Ah...\n Your published posts will appear here."
        messageLabel.textColor = #colorLiteral(red: 0.1538375616, green: 0.1488625407, blue: 0.1489177942, alpha: 1)
        messageLabel.numberOfLines = 2
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "Futura", size: 20)
        messageLabel.sizeToFit()
        return messageLabel
    }()
    
    func settingsBarButton() {
        let button: UIButton = UIButton(type: UIButtonType.custom)
        button.setImage(UIImage(named: "Settings.png"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(goToUsersSettings), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x:0.0,y:0.0, width:45,height: 45.0)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
       
    }

    func fetchUser() {
        Api.Userr.observeCurrentUser { (user) in
            self.user = user
            self.collectionView.reloadData()
        }
    }
    
    func fetchMyPosts() {
        
        guard let currentUser = Api.Userr.CURRENT_USER else {
            print("No current user in profile view controller")
            return
        }
        
        Api.MyPosts.REF_MYPOSTS.child(currentUser.uid).observe(.childAdded, with: {
            snapshot in
            Api.Post.observePost(withId: snapshot.key, completion: {
                post in
                self.posts.append(post)
                self.collectionView.reloadData()
            })
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Segues to Users Profile Update Settings
        if segue.identifier == "Profile_SettingSegue" {
            let settingVC = segue.destination as! SettingTableViewController
            settingVC.delegate = self
        }
        
        if segue.identifier == "Profile_DetailSegue" {
            let detailVC = segue.destination as! DetailViewController
            let postId = sender  as! String
            detailVC.postId = postId
        }
        // Segues to the actual Settings VC
        if segue.identifier == "User_SettingSegue" {
            print("Pressed")
            let userSettingVC = segue.destination as! UserSettingsTableViewController
            userSettingVC.delegate = self as? UserSettingTableViewControllerDelegate
            
        }
    }

}

// Will return the posts in the users profile.
extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! ProfilePosts
        let post = posts[indexPath.row]
        cell.post = post
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderProfileCollectionReusableView", for: indexPath) as! HeaderProfileCollectionReusableView
        if let user = self.user {
            headerViewCell.user = user
            headerViewCell.delegate2 = self
            headerViewCell.delegateUserSettings = self
        }
        return headerViewCell
    }
}

extension ProfileViewController: HeaderProfileCollectionReusableViewDelegateSwitchSettingVC {
    
    func goToSettingVC() {
        print("Pressed to go to EDIT profile")
        performSegue(withIdentifier: "Profile_SettingSegue", sender: nil)
    }
}

// Will lead to SETTINGS.
extension ProfileViewController: HeaderProfileCollectionReusableViewDelegateUserSettingVC  {
    @objc func goToUsersSettings() {
        print("Pressed to go to SETTINGS VC")
        performSegue(withIdentifier: "User_SettingSegue", sender: nil)
    }
}

extension ProfileViewController: SettingTableViewControllerDelegate {
    func updateUserInfor() {
        self.fetchUser()
    }
}

extension ProfileViewController: PhotoCollectionViewCellDelegate {
    func didSavePost(post: Post) {
      print("Did save Post - ProfileVC")
    }
    
    func didUnsavePost(post: Post) {
        print("Unsaved Post - ProfileVC")
    }
    
    func goToDetailVC(postId: String) {
        print("Pressed to go to Detail Post")
        performSegue(withIdentifier: "Profile_DetailSegue", sender: postId)
    }
    
    func didDeletePost(post: Post) {
        print("Did delete Post - ProfileVC")
        /// Deleting Post Action
            let controller = UIAlertController(title:"Delete Post?", message: "Are you sure you want to delete this post?", preferredStyle: .actionSheet)
            controller.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
                
                //guard let uid = Auth.auth().currentUser?.uid else { return }
                // Will have to test to make sure only the owner can delete their post. 
                guard let postId = post.id else { return }
                let ref = Database.database().reference().child("posts")
                ref.child(postId).removeValue(completionBlock: { (error, _) in
                    if let error = error {
                      print("There was an error deleting the post", error)
                    }
                    self.collectionView.reloadData() //testing
                    print("Post \(postId) successfully deleted!")
                })                
            }))
            controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(controller, animated: true, completion: nil)
    }
}


