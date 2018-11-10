//
//  PhotoCollectionViewCell.swift
//  Balapoint
//
//  Created by Gina De La Rosa on 10/15/18.
//  Copyright © 2017 Gina Delarosa. All rights reserved.

//  Will display the users Published - Drafts - Private Posts in their profile.
//  View for Other User Profile as well

import UIKit
import SDWebImage

protocol PhotoCollectionViewCellDelegate {
    func goToDetailVC(postId: String)
    func didSavePost(post: Post)
    func didUnsavePost(post: Post) //may not need?
    func didDeletePost(post: Post)
}

class ProfilePosts: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var savePost: UIImageView! //only visible not post owner
    @IBOutlet weak var deletePostButton: UIButton! //Only visible by post owner
    
    var delegate: PhotoCollectionViewCellDelegate?
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    var user: Userr? {
        didSet {
            updateUser()
        }
    }
    
    override func awakeFromNib() {
        title.text = ""
        header.text = ""
        author.text = ""
        date.text = ""
    }
    
    func updateView() {
        photo.layer.cornerRadius = 8.0
        photo.clipsToBounds = true
        if let photoUrlString = post?.photoUrl {
            let photoUrl = URL(string: photoUrlString)
            photo.sd_setImage(with: photoUrl)
        }
        title.text = post?.title
        header.text = post?.caption
        
        guard (post?.date) != nil else {
            print("Unable to retrieve date")
            return
        }
        //date.text = creationDate.timeAgoDisplay()
        
        self.updateLike(post: (self.post!))
        
        // Gesture to go to detail
        let tapGestureForPhoto = UITapGestureRecognizer(target: self, action: #selector(self.photo_TouchUpInside))
        title.addGestureRecognizer(tapGestureForPhoto)
        title.isUserInteractionEnabled = true
        
        // Will fill in saved icon
        let tapGestureForLikeImageView = UITapGestureRecognizer(target: self, action: #selector(self.savePost_TouchUpInside))
        savePost.addGestureRecognizer(tapGestureForLikeImageView)
        savePost.isUserInteractionEnabled = true
        
        // Gesture to delete post
        let tapGestureForDeletePost = UITapGestureRecognizer(target: self, action: #selector(self.deletePost_TouchUpInside))
        deletePostButton.addGestureRecognizer(tapGestureForDeletePost)
        deletePostButton.isUserInteractionEnabled = true

    }
    // Handle Save Post
    @objc func handleSavePost() {
        guard let post = post else { return }
        delegate?.didSavePost(post: post)
    }
    
    // Handle Unsave Post
    @objc func handleUnsavePost() {
        guard let post = post else { return }
        delegate?.didUnsavePost(post: post)
    }
    
    // Handles Post Updates
    func updateLike(post: Post) {
        let imageName = post.saved == nil || !post.isSaved! ? "EmptySave" : "FilledSave"
        savePost.image = UIImage(named: imageName)
        guard let count = post.likeCount else {
            print("Count Saved post")
            return
        }
        if count != 0 {
            
        }
    }
    
    func updateUser() {
       author.text = user?.username
    }
    
    // Goes to detail
    @objc func photo_TouchUpInside() {
        if let id = post?.id {
            delegate?.goToDetailVC(postId: id)
        }
    }
    
    // Saves post action
    @objc func savePost_TouchUpInside() {
        Api.Post.incrementLikes(postId: post!.id!, onSucess: { (post) in
            self.updateLike(post: post)
            self.post?.isSaved = post.isSaved
            self.delegate?.didSavePost(post: post)
            self.delegate?.didUnsavePost(post: post)
        }) { (errorMessage) in
            print("Error: \(String(describing: errorMessage))")
        }
    }
    
    // Unsave Action
    @objc func unSave_TouchUpInside() {
        self.delegate?.didUnsavePost(post: post!)
    }
    
    // Delete Post
    @objc func deletePost_TouchUpInside() {
        self.delegate?.didDeletePost(post: post!)
    }
}
