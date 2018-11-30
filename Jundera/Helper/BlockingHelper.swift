//
//  BlockingHelper.swift
//  Jundera
//
//  Created by Gina De La Rosa on 11/30/18.
//  Copyright © 2018 Gina De La Rosa. All rights reserved.
//

import Foundation
import FirebaseDatabase

class BlockingHelper {
    
    static let shared = BlockingHelper()
    
    func blockUser(uid: String, VC: UIViewController) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let blockAction = UIAlertAction(title: "Block User", style: .destructive) { (action) in
            Api.blockUser.blockUser(targetUID: uid)
            self.displayAlert(title: "User Blocked", message: "You won't see their posts in your Home Feed. They won't know that you've blocked them.", VC: VC)
        }
        let unblockUser = UIAlertAction(title: "Unblock User", style: .default) { (action) in
            Api.blockUser.unblockUser(targetUID: uid)
            self.displayAlert(title: "User Unblocked", message: "You will see their posts in your Home Feed. They won't know that you've unblocked them.", VC: VC)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        Api.blockUser.checkIfBlocked(targetUID: uid) { (blocked) in
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
