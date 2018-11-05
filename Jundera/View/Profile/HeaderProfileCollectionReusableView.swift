//
//  HeaderProfileCollectionReusableView.swift
//  Balapoint
//
//  Created by Gina De La Rosa on 10/15/18.
//  Copyright © 2018 Gina Delarosa. All rights reserved.
//  Header for Profile

import UIKit


protocol HeaderProfileCollectionReusableViewDelegate {
    func updateFollowButton(forUser user: Userr)
}

protocol HeaderProfileCollectionReusableViewDelegateSwitchSettingVC {
    func goToSettingVC()
}

protocol HeaderProfileCollectionReusableViewDelegateUserSettingVC {
    func goToUsersSettings()
}

class HeaderProfileCollectionReusableView: UICollectionReusableView, UITextViewDelegate {
    
    @IBOutlet weak var profileImage: UIImageView! //Image
    @IBOutlet weak var nameLabel: UILabel! // Name
    @IBOutlet weak var goalLabel: UILabel! // Bio
    @IBOutlet weak var websiteUrl: UITextView! // Website
    @IBOutlet weak var editButton: UIButton! // EDIT
    @IBOutlet weak var followButton: UIButton! // Follow or Unfollow 
    
    var delegate: HeaderProfileCollectionReusableViewDelegate?
    var delegate2: HeaderProfileCollectionReusableViewDelegateSwitchSettingVC?
    var delegateUserSettings: HeaderProfileCollectionReusableViewDelegateUserSettingVC?
    
    var user: Userr? {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clear()
    }
    
    func updateView() {
        nameLabel.text = user?.username
        goalLabel.text = user?.bio
        websiteUrl.text = user?.website

        if let photoUrlString = user!.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            
           self.profileImage.sd_setImage(with: photoUrl)
            profileImage.layer.borderWidth = 1
            profileImage.layer.masksToBounds = true
            profileImage.layer.borderColor = UIColor.clear.cgColor
            profileImage.layer.cornerRadius = profileImage.frame.height/2
            profileImage.clipsToBounds = true
        }
        
        func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
            makeURLOpen()
            UIApplication.shared.open(URL, options: [:])
            return false
        }
        
        if user?.id == Api.Userr.CURRENT_USER?.uid {
            editButton.setTitle("Edit", for: UIControlState.normal)
            editButton.addTarget(self, action: #selector(self.goToSettingVC), for: UIControlEvents.touchUpInside)
        } else {
            editButton.isHidden = true
        }
        
        if user?.id == Api.Userr.CURRENT_USER?.uid {
          followButton.isHidden = true
        } else {
            updateStateFollowButton()
        }
    }
    
    // Opens website URL
    func makeURLOpen() {
        let attributedString = NSMutableAttributedString(string: (user?.website)!, attributes:[NSAttributedStringKey.link: URL(string: (user?.website)!)!])
        
        websiteUrl.attributedText = attributedString
        guard let url = URL(string: (user?.website)!) else {
            print("Not the right URL")
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        
    }
    
    /// Clears labels
    func clear() {
        self.nameLabel.text = ""
        self.goalLabel.text = ""
        self.websiteUrl.text = ""
    }
    
    @objc func goToSettingVC() {
        delegate2?.goToSettingVC()
    }
    
    @objc func goToUsersSettings() {
        delegateUserSettings?.goToUsersSettings()
    }
    
    /// Updates following status
    func updateStateFollowButton() {
        if user!.isFollowing! {
            configureUnFollowButton()
        } else {
            configureFollowButton()
        } 
    }
    
    // Mark: Configuration for following another user
    func configureFollowButton() {
//        followButton.layer.borderWidth = 1
//        followButton.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232.255, alpha: 1).cgColor
//        followButton.layer.cornerRadius = 5
//        followButton.clipsToBounds = true
        
//        followButton.setTitleColor(UIColor.white, for: UIControlState.normal)
//        followButton.backgroundColor = UIColor(red: 69/255, green: 142/255, blue: 255/255, alpha: 1)
        followButton.setTitle("Follow", for: UIControlState.normal)
        followButton.addTarget(self, action: #selector(self.followAction), for: UIControlEvents.touchUpInside)
    }
    
    func configureUnFollowButton() {
//        followButton.layer.borderWidth = 1
//        followButton.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232.255, alpha: 1).cgColor
//        followButton.layer.cornerRadius = 5
//        followButton.clipsToBounds = true
        
//        followButton.setTitleColor(UIColor.black, for: UIControlState.normal)
//        followButton.backgroundColor = UIColor.clear
        followButton.setTitle("Following", for: UIControlState.normal)
        followButton.addTarget(self, action: #selector(self.unFollowAction), for: UIControlEvents.touchUpInside)
    }
    
    /// Follow Action
    @objc func followAction() {
        if user!.isFollowing! == false {
            Api.Follow.followAction(withUser: user!.id!)
            configureUnFollowButton()
            user!.isFollowing! = true
            delegate?.updateFollowButton(forUser: user!)
        }
    }
    
    /// Unfollow Action
    @objc func unFollowAction() {
        if user!.isFollowing! == true {
            Api.Follow.unFollowAction(withUser: user!.id!)
            configureFollowButton()
            user!.isFollowing! = false
            delegate?.updateFollowButton(forUser: user!)
        }
    }
}


