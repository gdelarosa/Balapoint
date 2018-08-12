//
//  AuthService.swift
//  Metis
//
//  Created by Gina De La Rosa on 11/14/17.
//  Copyright © 2017 Gina Delarosa. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class AuthService {
    
    static func signIn(email: String, password: String, onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            onSuccess()
        })
        
    }
    
    static func signUp(username: String, email: String, password: String, imageData: Data, onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { user, error in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            
            guard let result = user else {
                return
            }
            let uid = result.user.uid
            
            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("profile_image").child(uid)
            
            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    return
                }
                
                storageRef.downloadURL(completion: { (url, error) in
                    if let profileImageUrl = url?.absoluteString {
                        self.setUserInfomation(profileImageUrl: profileImageUrl, username: username, email: email, uid: uid, onSuccess: onSuccess)
                    }
                })
//                let profileImageUrl = metadata?.downloadURL()?.absoluteString
//
//                self.setUserInfomation(profileImageUrl: profileImageUrl!, username: username, email: email, uid: uid!, onSuccess: onSuccess)
            })
        })
        
    }
    
    static func setUserInfomation(profileImageUrl: String, username: String, email: String, uid: String, onSuccess: @escaping () -> Void) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users")
        let newUserReference = usersReference.child(uid)
        newUserReference.setValue(["username": username, "username_lowercase": username.lowercased(), "email": email, "profileImageUrl": profileImageUrl])
        onSuccess()
    }
    
    static func updateUserInfor(username: String, email: String, goal: String, imageData: Data, onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
        
        Api.Userr.CURRENT_USER?.updateEmail(to: email, completion: { (error) in
            if error != nil {
                onError(error!.localizedDescription)
            } else {
                let uid = Api.Userr.CURRENT_USER?.uid
                let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("profile_image").child(uid!)
                let storageItem = Storage.storage().reference().child(uid!) //added
                
                
                storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        return
                    }
                    //TO DO: Fix this
                  // let profileImageUrl = metadata?.downloadURL()?.absoluteString
                    
                  
                    storageRef.downloadURL(completion: { (url, error) in
                        if let profileImageUrl = url?.absoluteString {
                            self.updateDatabase(profileImageUrl: profileImageUrl, username: username, email: email, goal: goal, onSuccess: onSuccess, onError: onError)
                        }
                    })
                   
//                    self.updateDatabase(profileImageUrl: profileImageUrl!, username: username, email: email, goal: goal, onSuccess: onSuccess, onError: onError)
                })
            }
        })
        
    }
    
    static func updateDatabase(profileImageUrl: String, username: String, email: String, goal: String, onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
        let dict = ["username": username, "username_lowercase": username.lowercased(), "email": email, "goal": goal,
                    "profileImageUrl": profileImageUrl]
        Api.Userr.REF_CURRENT_USER?.updateChildValues(dict, withCompletionBlock: { (error, ref) in
            if error != nil {
                onError(error!.localizedDescription)
            } else {
                onSuccess()
            }
            
        })
    }
    
    static func logout(onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
        do {
            try Auth.auth().signOut()
            onSuccess()
            
        } catch let logoutError {
            onError(logoutError.localizedDescription)
        }
    }
}
