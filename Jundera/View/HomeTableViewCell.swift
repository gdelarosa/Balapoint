
//
//  HomeTableViewCell.swift
//  Metis
//
//  Created by Gina De La Rosa on 11/15/17.
//  Copyright © 2017 Gina Delarosa. All rights reserved.
//  Cell for posts in the Home View Controller

import UIKit
import AVFoundation

protocol HomeTableViewCellDelegate {
    func goToCommentVC(postId: String)
    func goToProfileUserVC(userId: String)
    func goToDetailPostVC(postId: String)
}

class HomeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var postTitleLabel: UILabel! // Post Title
    @IBOutlet weak var nameLabel: UILabel! // User name of whom posted
    @IBOutlet weak var postImageView: UIImageView! //Post Image
    @IBOutlet weak var likeImageView: UIImageView! // Save Post
    @IBOutlet weak var captionLabel: UILabel! // Heading
    @IBOutlet weak var postDateLabel: UILabel! // Date posted
    @IBOutlet weak var imageBackgroundShadow: UIImageView! //Might not use after all
    
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
        imageBackgroundShadow.isHidden = false
        captionLabel.text = post?.caption //header
        postTitleLabel.text = post?.title //title
        guard let creationDate = post?.creationDate else {
            print("Unable to retrieve date")
            return
        }
        postDateLabel.text = creationDate.timeAgoDisplay()
       
        if (post?.ratio) != nil {
            layoutIfNeeded()
        }
        
        if let photoUrlString = post?.photoUrl {
            let photoUrl = URL(string: photoUrlString)
            postImageView.sd_setImage(with: photoUrl)
            
        }
     
        self.updateLike(post: (self.post!))
    }
    
    func updateLike(post: Post) {
        
        let imageName = post.likes == nil || !post.isLiked! ? "SaveInCell" : "SavedInCell"
        likeImageView.image = UIImage(named: imageName)
        guard let count = post.likeCount else {
            return
        }
        if count != 0 {
            print("Liked Item: \(count)")
        }
       
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
        
        let tapGestureForLikeImageView = UITapGestureRecognizer(target: self, action: #selector(self.likeImageView_TouchUpInside))
        likeImageView.addGestureRecognizer(tapGestureForLikeImageView)
        likeImageView.isUserInteractionEnabled = true
        
        let tapGestureForNameLabel = UITapGestureRecognizer(target: self, action: #selector(self.nameLabel_TouchUpInside))
        nameLabel.addGestureRecognizer(tapGestureForNameLabel)
        nameLabel.isUserInteractionEnabled = true
        
        //Testing for going to detail view by tapping on the title. Will have to setup to let user tap on cell. 
        let tapGestureForTitle = UITapGestureRecognizer(target: self, action: #selector(self.cell_TouchUpInside))
        postTitleLabel.addGestureRecognizer(tapGestureForTitle)
        postTitleLabel.isUserInteractionEnabled = true

    }
    
    // CAUSES A CRASH
    /// If a user taps on the user name label they will go to that profile.
    
    @objc func nameLabel_TouchUpInside() {
        if let id = user?.id {
            delegate?.goToProfileUserVC(userId: id)
        }
    }
    
    @objc func cell_TouchUpInside() {
        if let post = post?.id {
            delegate?.goToDetailPostVC(postId: post)
        }
    }

    
    @objc func likeImageView_TouchUpInside() {
        Api.Post.incrementLikes(postId: post!.id!, onSucess: { (post) in
            self.updateLike(post: post)
            self.post?.likes = post.likes
            self.post?.isLiked = post.isLiked
            self.post?.likeCount = post.likeCount
        }) { (errorMessage) in
            print("Error: \(String(describing: errorMessage))")
        }
        print("You Tapped the Save icon")
    }
    
    @objc func commentImageView_TouchUpInside() {
      print("commentImageView_TouchUpInside")
        if let id = post?.id {
            delegate?.goToCommentVC(postId: id)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        print("Reusing cell")
       
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
