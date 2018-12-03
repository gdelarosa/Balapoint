//
//  TestDetailCollectionViewCell.swift
//  Jundera
//
//  Created by Gina De La Rosa on 11/14/18.
//  Copyright © 2018 Gina De La Rosa. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

protocol DetailTopicDelegate {
    func goToProfileUserVC(userId: String)
    func goToDetailPostVC(postId: String)
    func didSavePost(post: Post)
    func didUnsavePost(post: Post) //probs dont need
}

class TopicDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postTitleLabel: UILabel! // Post Title
    @IBOutlet weak var nameLabel: UILabel! // User name of whom posted
    @IBOutlet weak var postImageView: UIImageView! //Post Image
    @IBOutlet weak var likeImageView: UIImageView! // Save Post
    @IBOutlet weak var captionLabel: UILabel! // Heading
    @IBOutlet weak var postDateLabel: UILabel! // Date posted
    
    var delegate: DetailTopicDelegate?
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    var userTest: Userr? {
        didSet {
            setupUserInfo()
        }
    }
    
    var shot: DataSnapshot?
    
    func updateView() {
        postImageView.layer.cornerRadius = 8.0
        postImageView.clipsToBounds = true
        
        postTitleLabel.sizeToFit()
        
        captionLabel.text = post?.caption
        postTitleLabel.text = post?.title
        
        guard let creationDate = post?.date else {
            print("UNABLE TO GET DATE")
            return
        }
        print("Caption: \(String(describing: post?.caption))")
        print("Date is: \(creationDate)")
        postDateLabel.text = creationDate.timeAgoDisplay().lowercased()
        
        
        if (post?.ratio) != nil {
            layoutIfNeeded()
        }
        
        if let photoUrlString = post?.photoUrl {
            let photoUrl = URL(string: photoUrlString)
            postImageView.sd_setImage(with: photoUrl)
        }
        self.updateLike(post: (self.post!))
    }
    
    // Handle Save Post
    @objc func handleSavePost() {
        print("saved a post")
        guard let post = post else { return }
        delegate?.didSavePost(post: post)
    }
    
    // Handle Unsave Post
    @objc func handleUnsavePost() {
        print("Unsaved a post")
        guard let post = post else { return }
        delegate?.didUnsavePost(post: post)
    }
    // Handles Post Updates
    func updateLike(post: Post) {
        let imageName = post.saved == nil || !post.isSaved! ? "EmptySave" : "FilledSave"
        likeImageView.image = UIImage(named: imageName)
        guard let count = post.likeCount else {
            return
        }
        if count != 0 {
            
        }
    }
    
    func setupUserInfo() {
        nameLabel.text = userTest?.username
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
        if let id = userTest?.id {
            delegate?.goToProfileUserVC(userId: id)
        } else {
            print("Can't get user")
        }
    }
    
    // Goes to detail post
    @objc func cell_TouchUpInside() {
        if let post = post?.id {
            delegate?.goToDetailPostVC(postId: post)
        }
    }
    
    // Saves post action
    @objc func likeImageView_TouchUpInside() {
        Api.Post.incrementLikes(postId: post!.id!, onSucess: { (post) in
            self.updateLike(post: post)
            self.post?.isSaved = post.isSaved
            self.delegate?.didSavePost(post: post)
            //self.delegate?.didUnsavePost(post: post)
        }) { (errorMessage) in
            print("Error: \(String(describing: errorMessage))")
        }
    }
    
    //Nothing is happening here.
    @objc func unSave_TouchUpInside() {
        print("Nothing happening here")
        self.delegate?.didUnsavePost(post: post!)
    }
}

