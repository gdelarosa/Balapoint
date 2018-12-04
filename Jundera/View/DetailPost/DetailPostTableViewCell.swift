//
//  DetailPostTableViewCell.swift
//  Balapoint
//
//  Created by Gina De La Rosa on 10/16/18.
//  Copyright © 2018 Gina De La Rosa. All rights reserved.

//  Will display the details of the post selected.

import UIKit
import Firebase

protocol DetailPostTableViewCellDelegate {
    func goToProfileUserVC(userId: String)
   // func didPressReport(post: Post)
}

class DetailPostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var dateCreated: UILabel!
    @IBOutlet weak var hashtags: UILabel!
    @IBOutlet weak var bodyText: UITextView!
    
    var detailDelegate: DetailPostTableViewCellDelegate?
    
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
        titleLabel.text = ""
        headerLabel.text = ""
        userName.text = ""
        dateCreated.text = ""
       // hashtags.text = ""
        bodyText.text = ""
        
        // Gesture for user profile
        let tapGestureForPhoto = UITapGestureRecognizer(target: self, action: #selector(self.photo_TouchUpInside))
        userIcon.addGestureRecognizer(tapGestureForPhoto)
        userIcon.isUserInteractionEnabled = true
        
        // Gesture for user profile
        let tapGestureForUsername = UITapGestureRecognizer(target: self, action: #selector(self.photo_TouchUpInside))
        userName.addGestureRecognizer(tapGestureForUsername)
        userName.isUserInteractionEnabled = true
    }
    
    func adjustUITextViewHeight(arg : UITextView)
    {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
    }
    
    func updateView() {
        
        if let photoUrlString = post?.photoUrl {
            let photoUrl = URL(string: photoUrlString)
            postImage.sd_setImage(with: photoUrl)
        }
        
        titleLabel.text = post?.title
        headerLabel.text = post?.caption
        bodyText.text = post?.body
    }
    
    func updateUser() {
        userName.text = user?.username
        userIcon.layer.borderWidth = 1
        userIcon.layer.masksToBounds = true
        userIcon.layer.borderColor = UIColor.clear.cgColor
        userIcon.layer.cornerRadius = userIcon.frame.height/2
        userIcon.clipsToBounds = true
        
        if let userPhotoUrlString = user?.profileImageUrl {
            let photoUrl = URL(string: userPhotoUrlString)
            userIcon.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholderImg"))
        }
        
    }
    
    @objc func photo_TouchUpInside() {
        if let id = user?.id {
            print("Go to user profile - DETAIL POST CELL")
            detailDelegate?.goToProfileUserVC(userId: id)
        } else {
            print("Unable to go to User Profile")
        }
    }    

}
