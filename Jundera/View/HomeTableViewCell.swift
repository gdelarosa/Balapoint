
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
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel! // User name of whom posted
    @IBOutlet weak var goalLabel: UILabel! //Title
    @IBOutlet weak var postImageView: UIImageView! //Post Image
    @IBOutlet weak var likeImageView: UIImageView!
   // @IBOutlet weak var commentImageView: UIImageView! //Not needed
   // @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var likeCountButton: UIButton! //Saved
    @IBOutlet weak var captionLabel: UILabel! // Heading
    @IBOutlet weak var heightConstraintPhoto: NSLayoutConstraint!
   // @IBOutlet weak var volumeView: UIView!
   // @IBOutlet weak var volumeButton: UIButton!
    @IBOutlet weak var postDateLabel: UILabel!
    
    var delegate: HomeTableViewCellDelegate?
    //var player: AVPlayer?
   // var playerLayer: AVPlayerLayer?
    
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
    
    var isMuted = true
    
    func updateView() {
        captionLabel.text = post?.caption //header
        postTitleLabel.text = post?.title //added for title
        
        if (post?.ratio) != nil {
            //heightConstraintPhoto.constant = UIScreen.main.bounds.width / ratio
            layoutIfNeeded()

        }
        
        if let photoUrlString = post?.photoUrl {
            let photoUrl = URL(string: photoUrlString)
            postImageView.sd_setImage(with: photoUrl)
        }
     
        self.updateLike(post: (self.post!))
    }
    
//    @IBAction func volumeButton_TouchUpInSide(_ sender: UIButton) {
//        if isMuted {
//            isMuted = !isMuted
//            volumeButton.setImage(UIImage(named: "Icon_Volume"), for: UIControlState.normal)
//        } else {
//            isMuted = !isMuted
//            volumeButton.setImage(UIImage(named: "Icon_Mute"), for: UIControlState.normal)
//
//        }
//        player?.isMuted = isMuted
//    }
    
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
      
        //goalLabel.text = user?.goal
//        if let photoUrlString = user?.profileImageUrl {
//            let photoUrl = URL(string: photoUrlString)
//            profileImageView.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholderImg"))
//
//        }
    }
    
      override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = ""
       //goalLabel.text = ""
        captionLabel.text = ""
        postTitleLabel.text = "" //added for title
        postDateLabel.text = "" //added for Date
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.commentImageView_TouchUpInside))
//        commentImageView.addGestureRecognizer(tapGesture)
//        commentImageView.isUserInteractionEnabled = true
        
        let tapGestureForLikeImageView = UITapGestureRecognizer(target: self, action: #selector(self.likeImageView_TouchUpInside))
        likeImageView.addGestureRecognizer(tapGestureForLikeImageView)
        likeImageView.isUserInteractionEnabled = true
        
        let tapGestureForNameLabel = UITapGestureRecognizer(target: self, action: #selector(self.nameLabel_TouchUpInside))
        nameLabel.addGestureRecognizer(tapGestureForNameLabel)
        nameLabel.isUserInteractionEnabled = true

    }
    
    
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
        //profileImageView.image = UIImage(named: "placeholderImg")
        //playerLayer?.removeFromSuperlayer()
       // player?.pause()
        //self.volumeView.isHidden = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
