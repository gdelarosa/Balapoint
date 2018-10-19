//
//  HeaderProfileCollectionReusableView.swift
//  Metis
//
//  Created by Gina De La Rosa on 11/15/17.
//  Copyright © 2017 Gina Delarosa. All rights reserved.
//

import UIKit
import Segmentio

protocol HeaderProfileCollectionReusableViewDelegate {
    func updateFollowButton(forUser user: Userr)
}

protocol HeaderProfileCollectionReusableViewDelegateSwitchSettingVC {
    func goToSettingVC()
}

protocol HeaderProfileCollectionReusableViewDelegateUserSettingVC {
    func goToUsersSettings()
}

class HeaderProfileCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var myPostsCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel! // BIO
    @IBOutlet weak var followButton: UIButton! //This will be button to EDIT profile if it's user selecting it.
    @IBOutlet weak var personalMenu: Segmentio!
   //@IBOutlet weak var userSettingsButton: UIButton!
    
    var delegate: HeaderProfileCollectionReusableViewDelegate?
    var delegate2: HeaderProfileCollectionReusableViewDelegateSwitchSettingVC?
    var delegateUserSettings: HeaderProfileCollectionReusableViewDelegateUserSettingVC?
    
    var user: Userr? {
        didSet {
            updateView()
            loadMenu()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clear()
    }
    
    func updateView() {
        nameLabel.text = user?.username
        goalLabel.text = user?.bio
    
        if let photoUrlString = user!.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            
           self.profileImage.sd_setImage(with: photoUrl)
            profileImage.layer.borderWidth = 1
            profileImage.layer.masksToBounds = true
            profileImage.layer.borderColor = UIColor.clear.cgColor
            profileImage.layer.cornerRadius = profileImage.frame.height/2
            profileImage.clipsToBounds = true
        }
        
//        Api.MyPosts.fetchCountMyPosts(userId: user!.id!) { (count) in
//             self.myPostsCountLabel.text = "\(count)"
//        }
        
//        Api.Follow.fetchCountFollowing(userId: user!.id!) { (count) in
//            self.followingCountLabel.text = "\(count)"
//        }
//
//        Api.Follow.fetchCountFollowers(userId: user!.id!) { (count) in
//            self.followersCountLabel.text = "\(count)"
//        }
        
        if user?.id == Api.Userr.CURRENT_USER?.uid {
            followButton.setTitle("Edit", for: UIControlState.normal)
            followButton.addTarget(self, action: #selector(self.goToSettingVC), for: UIControlEvents.touchUpInside)

        } else {
            followButton.isHidden = true
            updateStateFollowButton()
        }
//        
//        if user?.id == Api.Userr.CURRENT_USER?.uid {
//            userSettingsButton.setTitle("Settings", for: UIControlState.normal)
//            userSettingsButton.addTarget(self, action: #selector(self.goToUsersSettings), for: UIControlEvents.touchUpInside)
//        } else {
//            userSettingsButton.isHidden = true //if user is on another users profile, the settings button should be hidden. 
//        }
    }
    
    func clear() {
        self.nameLabel.text = ""
        self.goalLabel.text = ""
        //self.myPostsCountLabel.text = ""
        //self.followersCountLabel.text = ""
        //self.followingCountLabel.text = ""
    }
    
    @objc func goToSettingVC() {
        delegate2?.goToSettingVC()
    }
    
    @objc func goToUsersSettings() {
        delegateUserSettings?.goToUsersSettings()
    }
    
    func updateStateFollowButton() {
        if user!.isFollowing! {
            configureUnFollowButton()
        } else {
            configureFollowButton()
        } 
    }
    
    func configureFollowButton() {
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232.255, alpha: 1).cgColor
        followButton.layer.cornerRadius = 5
        followButton.clipsToBounds = true
        
        followButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        followButton.backgroundColor = UIColor(red: 69/255, green: 142/255, blue: 255/255, alpha: 1)
        followButton.setTitle("Follow", for: UIControlState.normal)
        followButton.addTarget(self, action: #selector(self.followAction), for: UIControlEvents.touchUpInside)
    }
    
    func configureUnFollowButton() {
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232.255, alpha: 1).cgColor
        followButton.layer.cornerRadius = 5
        followButton.clipsToBounds = true
        
        followButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        followButton.backgroundColor = UIColor.clear
        followButton.setTitle("Following", for: UIControlState.normal)
        followButton.addTarget(self, action: #selector(self.unFollowAction), for: UIControlEvents.touchUpInside)
    }
    
    @objc func followAction() {
        if user!.isFollowing! == false {
            Api.Follow.followAction(withUser: user!.id!)
            configureUnFollowButton()
            user!.isFollowing! = true
            delegate?.updateFollowButton(forUser: user!)
        }
    }
    
    @objc func unFollowAction() {
        if user!.isFollowing! == true {
            Api.Follow.unFollowAction(withUser: user!.id!)
            configureFollowButton()
            user!.isFollowing! = false
            delegate?.updateFollowButton(forUser: user!)
        }
    }
    
    /// Swipe Menu for viewing Published - Draft - Private. Should only appear if the user is accessing their profile and not a visitor. 
    func loadMenu() {
        personalMenu.setup(content: segmentioContent(),
                           style: SegmentioStyle.onlyLabel,
                           options: segmentioOptions())
        
        personalMenu.selectedSegmentioIndex = 0
        personalMenu.valueDidChange = { segmentio, segmentIndex in
            print("Selected item: ", segmentIndex)
        }
    }
    
    func segmentioOptions() -> SegmentioOptions {
        
        let SegmentioStates = (
            defaultState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                titleTextColor: .black
            ),
            selectedState: SegmentioState(
                backgroundColor: .white,
                titleFont: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                titleTextColor: .black
            ),
            highlightedState: SegmentioState(
                backgroundColor: UIColor.lightGray.withAlphaComponent(0.6),
                titleFont: UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize),
                titleTextColor: .black
            )
        )
        
        return SegmentioOptions(
            backgroundColor: .white,
            segmentPosition: SegmentioPosition.fixed(maxVisibleItems: 3),
            scrollEnabled: true,
            indicatorOptions: SegmentioIndicatorOptions(color: #colorLiteral(red: 0.1960784314, green: 0.6274509804, blue: 0.7882352941, alpha: 1)),
            horizontalSeparatorOptions: SegmentioHorizontalSeparatorOptions(color: UIColor.clear),
            verticalSeparatorOptions: nil,
            imageContentMode: .center,
            labelTextAlignment: .center,
            labelTextNumberOfLines: 1,
            segmentStates: SegmentioStates,
            animationDuration: 0.3
        )
        
    }
    
    func segmentioContent() -> [SegmentioItem] {
        return [
            SegmentioItem(title: "Published", image: nil),
            SegmentioItem(title: "Drafts", image: nil),
            SegmentioItem(title: "Private", image: nil),
        ]
    }
    
    fileprivate func goToControllerAtIndex(_ index: Int) {
        personalMenu.selectedSegmentioIndex = index
    }

}
