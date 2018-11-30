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
    
    //Test
      var uid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        fetchUser()
        fetchMyPosts()
        setBackButton()
        
    }
    
    @IBAction func blockUserAction(_ sender: Any) {
        Helper.shared.blockUser(uid: userr.id!, VC: self)
       // presentAlert()
    }
    
    func isFollowing(userId: String, completed: @escaping (Bool) -> Void) {
        Api.Follow.isFollowing(userId: userId, completed: completed)
    }
    
    func isBlocking(userId: String, completed: @escaping (Bool) -> Void) {
        Api.Blocking.isBlocking(userId: userId, completed: completed)
    }
    
    func fetchUser() {
        Api.Userr.observeUser(withId: userId) { (userr) in
            self.isFollowing(userId: userr.id!, completed: { (value) in
                userr.isFollowing = value
                self.userr = userr
                self.collectionView.reloadData()
            })
            
//            self.isBlocking(userId: userr.id!, completed: { (values) in
//                userr.isBlocking = values
//                self.userr = userr
//            })
        }
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
    
     func blockAction() {
        if userr!.isBlocking! == false {
            Api.Blocking.blockAction(withUser: userr!.id!)
            userr!.isFollowing! = true
            print("User is blocked mofo!")
        }
    }
    
     func unblockAction() {
        if userr!.isBlocking! == true {
            Api.Blocking.unblockAction(withUser: userr!.id!)
            userr!.isBlocking! = false
        }
        
    }
    
    func presentAlert() {
        if userr!.isBlocking! == false {
            didBlock()
        } else {
            didUnblock()
        }
    }
    
    /// Block User Action: NEED TO TEST! 
    func didBlock() {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: "Block User", style: .destructive, handler: { (_) in
            
            let confirmationController = UIAlertController(title: "User Blocked", message: "They will not be able to view your posts or follow you.", preferredStyle: .alert)
            confirmationController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (alert) in
                confirmationController.dismiss(animated: true, completion: {
                    controller.dismiss(animated: true, completion: nil)
                })
            }))
        
            self.blockAction()
        }))
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
    
    func didUnblock() {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: "Unblock User", style: .destructive, handler: { (_) in
            
            let confirmationController = UIAlertController(title: "User Unblocked", message: "They will be able to follow you.", preferredStyle: .alert)
            confirmationController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (alert) in
                confirmationController.dismiss(animated: true, completion: {
                    controller.dismiss(animated: true, completion: nil)
                })
            }))
            
            self.unblockAction()
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
    
    func didSavePost(post: Post) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("saved").child(uid)
        guard let postId = post.id else { return }
        
        let values = [postId: post.uid]
        
        if post.isSaved == true {
            ref.updateChildValues(values as [AnyHashable : Any]) { (err, ref) in
                if let err = err {
                    print("Failed to put save post data in db:", err)
                    return
                }
                print("Successfully put save post in db")
            }
        } else {
            ref.child(post.id!).removeValue {_,_ in
                print("Post is unsaved")
            }
        }
    }
    
    func didUnsavePost(post: Post) {
        print("Unsaved Post - ProfileUserVC")
    }
    
    func goToDetailVC(postId: String) {
        performSegue(withIdentifier: "ProfileUser_DetailSegue", sender: postId)
    }
    
    func didDeletePost(post: Post) {
        print("Delete Post - ProfileUserVC.")
    }
}
