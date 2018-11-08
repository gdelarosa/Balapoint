
//
//  HomeTableViewCell.swift
//  Metis
//
//  Created by Gina De La Rosa on 11/15/17.
//  Copyright © 2017 Gina Delarosa. All rights reserved.
//  Cell for posts in the Home View Controller

import UIKit
import AVFoundation
import Firebase

protocol HomeTableViewCellDelegate {
    func goToProfileUserVC(userId: String)
    func goToDetailPostVC(postId: String)
    func didSavePost(post: Post)
    func didUnsavePost(post: Post)
}

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var postTitleLabel: UILabel! // Post Title
    @IBOutlet weak var nameLabel: UILabel! // User name of whom posted
    @IBOutlet weak var postImageView: UIImageView! //Post Image
    @IBOutlet weak var likeImageView: UIImageView! // Save Post
    @IBOutlet weak var captionLabel: UILabel! // Heading
    @IBOutlet weak var postDateLabel: UILabel! // Date posted
    
    var delegate: HomeTableViewCellDelegate?
    
    var post: Post? {
        didSet {
          updateView()
        }
    }
    
    var user: Userr? {
        didSet {
           setupUserInfo()
        }
    }
    
    func updateView() {
        postImageView.layer.cornerRadius = 8.0
        postImageView.clipsToBounds = true

        postTitleLabel.sizeToFit()
        
        captionLabel.text = post?.caption //header
        postTitleLabel.text = post?.title //title
        
        guard let creationDate = post?.date else {
            print("UNABLE TO GET DATE")
            return
        }
        postDateLabel.text = creationDate.timeAgoDisplay().lowercased()

       
        if (post?.ratio) != nil {
            layoutIfNeeded()
        }
        
        if let photoUrlString = post?.photoUrl {
            let photoUrl = URL(string: photoUrlString)
            postImageView.sd_setImage(with: photoUrl)
        }
     
        self.updateLike(post: (self.post!))
        //self.updateSavedPosts(post: (self.post!)) //testing
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
    
    func updateLike(post: Post) {
        //post.likes and post.isLiked
        let imageName = post.saved == nil || !post.isSaved! ? "EmptySave" : "FilledSave"
        likeImageView.image = UIImage(named: imageName)
        guard let count = post.likeCount else {
            print("Count Saved post")
            return
        }
        if count != 0 {
            
        }
//        if post.isSaved == true {
//            print("Post Is Saved")
//        }
//        if post.isSaved == false {
//            print("Post Not Saved")
//        }
    }
    
    func setupUserInfo() {
        nameLabel.text = user?.username
    }
    
      override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = ""
        captionLabel.text = ""
        postTitleLabel.text = ""
        postDateLabel.text = ""
        
        // Will fill in saved icon
        let tapGestureForLikeImageView = UITapGestureRecognizer(target: self, action: #selector(self.likeImageView_TouchUpInside))
        likeImageView.addGestureRecognizer(tapGestureForLikeImageView)
        likeImageView.isUserInteractionEnabled = true
        
        // Will go to user profile
        let tapGestureForNameLabel = UITapGestureRecognizer(target: self, action: #selector(self.nameLabel_TouchUpInside))
        nameLabel.addGestureRecognizer(tapGestureForNameLabel)
        nameLabel.isUserInteractionEnabled = true
        
        // Will go to Detail Post
        let tapGestureForTitle = UITapGestureRecognizer(target: self, action: #selector(self.cell_TouchUpInside))
        postTitleLabel.addGestureRecognizer(tapGestureForTitle)
        postTitleLabel.isUserInteractionEnabled = true
        
        // Will go to Detail Post
        let tapGestureForHeader = UITapGestureRecognizer(target: self, action: #selector(self.cell_TouchUpInside))
        captionLabel.addGestureRecognizer(tapGestureForHeader)
        captionLabel.isUserInteractionEnabled = true

    }
    
    // Goes to user profile.
    @objc func nameLabel_TouchUpInside() {
        if let id = user?.id {
            print("Go to User Profile - HOME CELL")
            delegate?.goToProfileUserVC(userId: id)
        } else {
            print("Can't get user")
        }
    }
    
    // Goes to detail post
    @objc func cell_TouchUpInside() {
        if let post = post?.id {
            print("Go to Detail Post - HOME CELL")
            delegate?.goToDetailPostVC(postId: post)
        }
    }
    
    
    @objc func likeImageView_TouchUpInside() {
        Api.Post.incrementLikes(postId: post!.id!, onSucess: { (post) in
            self.updateLike(post: post)
            //self.post?.likes = post.likes
            //self.post?.isLiked = post.isLiked
            self.post?.isSaved = post.isSaved //testing 
            //self.post?.likeCount = post.likeCount
            self.delegate?.didSavePost(post: post)
            self.delegate?.didUnsavePost(post: post) //testing
        }) { (errorMessage) in
            print("Error: \(String(describing: errorMessage))")
        }
    }
    
    @objc func unSave_TouchUpInside() {
        self.delegate?.didUnsavePost(post: post!)
    }
}
