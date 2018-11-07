//
//  SearchCollectionViewCell.swift
//  Jundera
//
//  Created by Gina De La Rosa on 11/6/18.
//  Copyright © 2018 Gina De La Rosa. All rights reserved.
//

import UIKit

protocol SearchTableViewCellDelegate {
    func goToProfileUserVC(userId: String)
}

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var delegate: SearchTableViewCellDelegate?
    
    var user: Userr? {
        didSet {
            updateView()
        }
    }
    //var hashTag: Hashtag?
    
    func updateView() {
        nameLabel.text = user?.username
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderColor = UIColor.clear.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        
        if let photoUrlString = user?.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            profileImage.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholderImg"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let nameTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.nameAndPhoto_TouchUpInside))
        nameLabel.addGestureRecognizer(nameTapGesture)
        nameLabel.isUserInteractionEnabled = true
        
        let photoTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.nameAndPhoto_TouchUpInside))
        profileImage.addGestureRecognizer(photoTapGesture)
        profileImage.isUserInteractionEnabled = true
    }
    
    @objc func nameAndPhoto_TouchUpInside() {
        if let id = user?.id {
            delegate?.goToProfileUserVC(userId: id)
        }
    }
}

