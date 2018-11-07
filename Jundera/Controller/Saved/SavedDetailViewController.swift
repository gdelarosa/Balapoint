//
//  SavedDetailViewController.swift
//  Jundera
//
//  Created by Gina De La Rosa on 11/7/18.
//  Copyright © 2018 Gina De La Rosa. All rights reserved.
//

import UIKit
import Firebase

class SavedDetailViewController: UIViewController {
    
    var postId = ""
    var creationDate = ""
    
    var post = Post()
    var user = Userr()
    
    var delegate: DetailPostTableViewCellDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPost()
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
            print("Segue to profile from DetailPostVC")
            let profileVC = segue.destination as! ProfileUserViewController
            let userID = sender  as! String
            profileVC.userId = userID
        } else {
            print("Unable to segue to user profile from detail post.")
        }
    }
    
    
    @IBAction func reportButton(_ sender: Any) {
        didSelectOptions(post: post)
    }
    
    /// Reporting Action
    func didSelectOptions(post: Post) {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: "Report Post", style: .destructive, handler: { (_) in
            
            let confirmationController = UIAlertController(title: "Post Reported", message: "We take reports very seriously and will look into this matter for you", preferredStyle: .alert)
            confirmationController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (alert) in
                confirmationController.dismiss(animated: true, completion: {
                    controller.dismiss(animated: true, completion: nil)
                })
            }))
            
            let ref = Database.database().reference().child("reports").childByAutoId()
            guard let uid = Auth.auth().currentUser?.uid else { return }
            guard let postId = post.id else { return }
            let values: [String:Any] = [
                "uid": uid,
                "time_interval": Date().timeIntervalSince1970,
                "post": postId
            ]
            ref.updateChildValues(values, withCompletionBlock: { (err, _) in
                if let err = err {
                    print("Failed to report post:", err)
                    return
                }
                print("Successfully reported post:", values["post"] as? String ?? "")
                self.present(confirmationController, animated: true, completion: nil)
            })
            
        }))
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
}

extension SavedDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailPostCell", for: indexPath) as! DetailPostTableViewCell
        cell.post = post
        cell.user = user
        cell.detailDelegate = self
        
        return cell
    }
}

extension SavedDetailViewController: DetailPostTableViewCellDelegate {
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
