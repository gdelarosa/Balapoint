//
//  Helper.swift
//  Poto
//
//  Created by Zehua Lin on 24/1/17.
//  Copyright © 2017 Zehua Lin. All rights reserved.
//

import Foundation
import FirebaseAuth
import UIKit
import FirebaseStorage
import FirebaseDatabase

class Helper {
    
    static let shared = Helper()
    
    func blockUser(uid: String, VC: UIViewController) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let blockAction = UIAlertAction(title: "Block User", style: .destructive) { (action) in
            Api.USER_BLOCK.blockUser(targetUID: uid)
            self.displayAlert(title: "User Blocked", message: "You won't see their posts in your Home Feed. They won't know that you've blocked them.", VC: VC)
        }
        let unblockUser = UIAlertAction(title: "Unblock User", style: .default) { (action) in
            Api.USER_BLOCK.unblockUser(targetUID: uid)
            self.displayAlert(title: "User Unblocked", message: "You will see their posts in your Home Feed. They won't know that you've unblocked them.", VC: VC)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        Api.USER_BLOCK.checkIfBlocked(targetUID: uid) { (blocked) in
            if(blocked) {
                alertController.addAction(unblockUser)
            }else {
                alertController.addAction(blockAction)
            }
            VC.present(alertController, animated: true)
        }
    }
    
    func displayAlert(title: String, message: String, VC: UIViewController) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        controller.addAction(okAction)
        VC.present(controller, animated: true)
    }
}














