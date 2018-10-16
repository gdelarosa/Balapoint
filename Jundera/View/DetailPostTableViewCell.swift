//
//  DetailPostTableViewCell.swift
//  Jundera
//
//  Created by Gina De La Rosa on 10/16/18.
//  Copyright © 2018 Gina De La Rosa. All rights reserved.
//

import UIKit

protocol DetailPostTableViewCellDelegate {
    func goToProfileUserVC(userId: String)
}

class DetailPostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var savePostIcon: UIImageView!
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var dateCreated: UILabel!
    @IBOutlet weak var hashtags: UILabel!
    
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
        hashtags.text = ""
    }
    
    func updateView() {
        if let photoUrlString = post?.photoUrl {
            let photoUrl = URL(string: photoUrlString)
            postImage.sd_setImage(with: photoUrl)
        }
        titleLabel.text = post?.title
        headerLabel.text = post?.caption
        
        guard let creationDate = post?.creationDate else {
            print("Unable to retrieve date")
            return
        }
        dateCreated.text = creationDate.timeAgoDisplay()
        
        
//        let tapGestureForPhoto = UITapGestureRecognizer(target: self, action: #selector(self.photo_TouchUpInside))
//        photo.addGestureRecognizer(tapGestureForPhoto)
//        photo.isUserInteractionEnabled = true
        
    }
    
    func updateUser() {
        userName.text = user?.username
    }
    
//    @objc func photo_TouchUpInside() {
//        if let id = post?.id {
//            delegate?.goToDetailVC(postId: id)
//        }
//    }

}
