//
//  PhotoCollectionViewCell.swift
//  Metis
//
//  Created by Gina De La Rosa on 11/15/17.
//  Copyright © 2017 Gina Delarosa. All rights reserved.
//  Will display the users Published - Drafts - Private Posts in their profile.

import UIKit
import SDWebImage

protocol PhotoCollectionViewCellDelegate {
    func goToDetailVC(postId: String)
}

class ProfilePosts: UICollectionViewCell {
    
  
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var date: UILabel!
    
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
        
        guard let creationDate = post?.creationDate else {
            print("Unable to retrieve date")
            return
        }
        date.text = creationDate.timeAgoDisplay()
        
        
        let tapGestureForPhoto = UITapGestureRecognizer(target: self, action: #selector(self.photo_TouchUpInside))
        photo.addGestureRecognizer(tapGestureForPhoto)
        photo.isUserInteractionEnabled = true

    }
    
    func updateUser() {
       author.text = user?.username
    }
    
    @objc func photo_TouchUpInside() {
        if let id = post?.id {
            delegate?.goToDetailVC(postId: id)
        }
    }
}
