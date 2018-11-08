//
//  SavedPostsCollectionViewCell.swift
//  Balapoint
//
//  Created by Gina De La Rosa on 10/29/18.
//  Copyright © 2018 Gina De La Rosa. All rights reserved.

//  Will display Saved Posts

import UIKit
import SDWebImage

protocol SavedCollectionViewCellDelegate {
    func goToDetailSavedPost(postId: String)
    func goToPersonProfile(userId: String)
}

class SavedPostsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var savePostIcon: UIImageView!
    
    var delegate: SavedCollectionViewCellDelegate?
    
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
        
        // Tap Title to go to Detail Post
        let tapGestureForTitle = UITapGestureRecognizer(target: self, action: #selector(self.title_TouchUpInside))
        title.addGestureRecognizer(tapGestureForTitle)
        title.isUserInteractionEnabled = true
        
        // Tap header to go to Detail Post
        let tapGestureForHeader = UITapGestureRecognizer(target: self, action: #selector(self.title_TouchUpInside))
        header.addGestureRecognizer(tapGestureForHeader)
        header.isUserInteractionEnabled = true
        
        // Tap image to go to Detail Post
        let tapGestureForImage = UITapGestureRecognizer(target: self, action: #selector(self.title_TouchUpInside))
        photo.addGestureRecognizer(tapGestureForImage)
        photo.isUserInteractionEnabled = true
        
        // Tap User Name to go to Profile
        let tapGestureForProfile = UITapGestureRecognizer(target: self, action: #selector(self.profileImage_TouchUpInside))
        author.addGestureRecognizer(tapGestureForProfile)
        author.isUserInteractionEnabled = true
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
        updateLike(post: self.post!)
        
    }
    
    func updateUser() {
        author.text = user?.username
    }
    
    /// Will update saved posts
    func updateLike(post: Post) {
        // post.likes and post.isLiked
        let imageName = post.saved == nil || !post.isSaved! ? "EmptySave" : "FilledSave"
        savePostIcon.image = UIImage(named: imageName)
//        guard let count = post.likeCount else {
//            return
//        }
//        if count != 0 {
//        }
    }
    
    // Goes to Detail Post
    @objc func title_TouchUpInside() {
        if let id = post?.id {
            delegate?.goToDetailSavedPost(postId: id)
        } else {
            print("Unable to go to detail post")
        }
    }
    
    // Goes to user profile.
    @objc func profileImage_TouchUpInside() {
        if let id = user?.id {
            delegate?.goToPersonProfile(userId: id)
        } else {
            print("Can't get user")
        }
    }
}
