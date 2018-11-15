//
//  TopicImageCollectionViewCell.swift
//  Jundera
//
//  Created by Gina De La Rosa on 10/18/18.
//  Copyright © 2018 Gina De La Rosa. All rights reserved.
//

import UIKit

class TopicImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topicTitle: UILabel!
    @IBOutlet weak var imageLayer: UIImageView!
    
    override func awakeFromNib() {
        imageView.layer.cornerRadius = 8.0
        imageView.clipsToBounds = true
        imageLayer.layer.cornerRadius = 8.0
        imageLayer.clipsToBounds = true 
    }
    
    
}
