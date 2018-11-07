//
//  ProfileUserViewController.swift
//  Balapoint
//
//  Created by Gina De La Rosa on 11/15/17.
//  Copyright © 2017 Gina Delarosa. All rights reserved.

//  Other User Profile - Logged in user can view another person's profile 

import UIKit
import Firebase

class ProfileUserViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var userr: Userr!
    var posts: [Post] = []
    var userId = ""
    var delegate: HeaderProfileCollectionReusableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("userId: \(userId)")
        collectionView.dataSource = self
        fetchUser()
        fetchMyPosts()
        setBackButton()
    }
    
    @IBAction func blockUserAction(_ sender: Any) {
        didSelectOptions(user: userr)
    }
    
    func fetchUser() {
        Api.Userr.observeUser(withId: userId) { (userr) in
            self.isFollowing(userId: userr.id!, completed: { (value) in
                userr.isFollowing = value
                self.userr = userr
                self.collectionView.reloadData()
            })
        }
    }
    
    func isFollowing(userId: String, completed: @escaping (Bool) -> Void) {
        Api.Follow.isFollowing(userId: userId, completed: completed)
    }
    
    func fetchMyPosts() {
        Api.MyPosts.fetchMyPosts(userId: userId) { (key) in
            Api.Post.observePost(withId: key, completion: {
                post in
                self.posts.append(post)
                self.collectionView.reloadData()
            })
        }
    }
    
    /// Block User Action: NEED TO TEST! 
    func didSelectOptions(user: Userr) {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: "Block User", style: .destructive, handler: { (_) in
            
            let confirmationController = UIAlertController(title: "User Blocked", message: "You will no longer be able to view their posts.", preferredStyle: .alert)
            confirmationController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (alert) in
                confirmationController.dismiss(animated: true, completion: {
                    controller.dismiss(animated: true, completion: nil)
                })
            }))
            
            let ref = Database.database().reference().child("blocked").childByAutoId()
            guard let uid = Auth.auth().currentUser?.uid else { return }
            guard let userId = self.userr.id else { return }
            let values: [String:Any] = [
                "uid": uid,
                "users": userId
            ]
            ref.updateChildValues(values, withCompletionBlock: { (err, _) in
                if let err = err {
                    print("Failed to block user:", err)
                    return
                }
                print("Successfully blocked user:", values["users"] as? String ?? "")
                self.present(confirmationController, animated: true, completion: nil)
            })
            
        }))
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ProfileUser_DetailSegue" {
            let detailVC = segue.destination as! DetailViewController
            let postId = sender  as! String
            detailVC.postId = postId
        }
    }

}


extension ProfileUserViewController: UICollectionViewDataSource {
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
        if let user = self.userr {
            headerViewCell.user = user
            headerViewCell.delegate = self.delegate
            headerViewCell.delegate2 = self
            
        }
        return headerViewCell
    }
}
// Will lead to EDITING profile
extension ProfileUserViewController: HeaderProfileCollectionReusableViewDelegateSwitchSettingVC {
    func goToSettingVC() {
        performSegue(withIdentifier: "ProfileUser_SettingSegue", sender: nil)
    }
}

extension ProfileUserViewController: PhotoCollectionViewCellDelegate {
    func goToDetailVC(postId: String) {
        performSegue(withIdentifier: "ProfileUser_DetailSegue", sender: postId)
    }
}
