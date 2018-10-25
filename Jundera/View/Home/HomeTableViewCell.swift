
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
    func didSavePost(post: Post)
}

class HomeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var postTitleLabel: UILabel! // Post Title
    @IBOutlet weak var nameLabel: UILabel! // User name of whom posted
    @IBOutlet weak var postImageView: UIImageView! //Post Image
    @IBOutlet weak var likeImageView: UIImageView! // Save Post
    @IBOutlet weak var captionLabel: UILabel! // Heading
    //@IBOutlet weak var postDateLabel: UILabel! // Date posted
    
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
//        postImageView.dropShadow()

        postTitleLabel.sizeToFit()
        
        captionLabel.text = post?.caption //header
        postTitleLabel.text = post?.title //title
        //guard let creationDate = post?.creationDate else {
           // print("Unable to retrieve date")
           // return
        //}
        //postDateLabel.text = creationDate.timeAgoDisplay()
       
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
    
    func updateLike(post: Post) {
        
        let imageName = post.likes == nil || !post.isLiked! ? "SaveInCell" : "SavedInCell2"
        likeImageView.image = UIImage(named: imageName)
        guard let count = post.likeCount else {
            return
        }
        if count != 0 {
            print("Liked Item: \(count)")
        }
        //delegate?.didSavePost(post: post)
        //testing for save post
        // The delegate is used in the HomeVC as well. Line 91. 
       
    }
    // Testing but not currently using. 
    func updateSavedPosts(post: Post) {
        //guard let post = post else { return }
//        let image = post.saved == nil || !post.isSaved! ? "SaveInCell" : "SavedInCell2"
//        likeImageView.image = UIImage(named: image)
        
        delegate?.didSavePost(post: post)
    }
    
    func setupUserInfo() {
        nameLabel.text = user?.username
    }
    
      override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = ""
        captionLabel.text = ""
        postTitleLabel.text = ""
        //postDateLabel.text = ""
        
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
    
    // Goes to user profile
    @objc func nameLabel_TouchUpInside() {
        if let id = user?.id {
            delegate?.goToProfileUserVC(userId: id)
        }
    }
    // Goes to detail post
    @objc func cell_TouchUpInside() {
        if let post = post?.id {
            delegate?.goToDetailPostVC(postId: post)
        }
    }

    @objc func likeImageView_TouchUpInside() {
        Api.Post.incrementLikes(postId: post!.id!, onSucess: { (post) in
            self.updateLike(post: post)
            self.updateSavedPosts(post: post)//testing
            self.post?.likes = post.likes
            self.post?.isLiked = post.isLiked
            self.post?.likeCount = post.likeCount
        }) { (errorMessage) in
            print("Error: \(String(describing: errorMessage))")
        }
        print("You Tapped the Save icon to LIKE")
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
