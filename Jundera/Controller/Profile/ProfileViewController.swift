//
//  ProfileViewController.swift
//  Metis
//
//  Created by Gina De La Rosa on 11/15/17.
//  Copyright © 2017 Gina Delarosa. All rights reserved.
//  User Profile - User can edit their information and view their posts

import UIKit
import Segmentio

class ProfileViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var user: Userr!
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self as? UICollectionViewDelegate
        fetchUser()
        fetchMyPosts()
        settingsBarButton()
        
    }
    
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

// Will return the posts in the users profile. TODO: Update UI.
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
            headerViewCell.delegateUserSettings = self //added. Not sure if this is actually needed. Will circle back.
        }
        return headerViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell Selected")
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
    func goToDetailVC(postId: String) {
        performSegue(withIdentifier: "Profile_DetailSegue", sender: postId)
    }
}


