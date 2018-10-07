
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
}

class HomeTableViewCell: UITableViewCell {

    //@IBOutlet weak var profileImageView: UIImageView! //Will not need for home but for detail post
    @IBOutlet weak var postTitleLabel: UILabel! // Post Title
    @IBOutlet weak var nameLabel: UILabel! // User name of whom posted
    //@IBOutlet weak var goalLabel: UILabel! //Title
    @IBOutlet weak var postImageView: UIImageView! //Post Image
    @IBOutlet weak var likeImageView: UIImageView! // Save Post
    //@IBOutlet weak var likeCountButton: UIButton! //Saved
    @IBOutlet weak var captionLabel: UILabel! // Heading
   // @IBOutlet weak var heightConstraintPhoto: NSLayoutConstraint!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var imageBackgroundShadow: UIImageView!
    
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
        
        captionLabel.text = post?.caption //header
        postTitleLabel.text = post?.title //title
        
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
            print("Liked Item")
            //likeCountButton.setTitle("\(count) likes", for: UIControlState.normal)
        } else {
            //likeCountButton.setTitle("Be the first support this", for: UIControlState.normal)
        }
       
    }
    
    func setupUserInfo() {
        nameLabel.text = user?.username
      
//        if let photoUrlString = user?.profileImageUrl {
//            let photoUrl = URL(string: photoUrlString)
//            profileImageView.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholderImg"))
//
//        }
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

    }
    // CAUSES A CRASH
    @objc func nameLabel_TouchUpInside() { //If Name label is tapped then user will go to that user's profile. 
        if let id = user?.id {
            delegate?.goToProfileUserVC(userId: id)
        }
    }

    
    @objc func likeImageView_TouchUpInside() {
        Api.Post.incrementLikes(postId: post!.id!, onSucess: { (post) in
            self.updateLike(post: post)
            self.post?.likes = post.likes
            self.post?.isLiked = post.isLiked
            self.post?.likeCount = post.likeCount
        }) { (errorMessage) in
           // ProgressHUD.showError(errorMessage)
        }
        print("You Tapped The Save Icon")
        //incrementLikes(forRef: postRef)
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

