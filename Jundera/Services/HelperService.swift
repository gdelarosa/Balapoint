//
//  HelperService.swift
//  Metis
//
//  Created by Gina De La Rosa on 11/15/17.
//  Copyright © 2017 Gina Delarosa. All rights reserved.
//  TO-DO: Should be optional to post a picture. Will have to change so that if there is no picture then the other data will be sent to the server.

import Foundation
import FirebaseStorage

class HelperService {
    
    static func uploadDataToServer(data: Data, videoUrl: URL? = nil, ratio: CGFloat, caption: String, title: String, body: String, onSuccess: @escaping () -> Void) {
        if let videoUrl = videoUrl {
            self.uploadVideoToFirebaseStorage(videoUrl: videoUrl, onSuccess: { (videoUrl) in
                uploadImageToFirebaseStorage(data: data, onSuccess: { (thumbnailImageUrl) in
                    sendDataToDatabase(photoUrl: thumbnailImageUrl, videoUrl: videoUrl, ratio: ratio, caption: caption, title: title, body: body, onSuccess: onSuccess)
                })
            })
        } else {
            uploadImageToFirebaseStorage(data: data) { (photoUrl) in
                self.sendDataToDatabase(photoUrl: photoUrl, ratio: ratio, caption: caption, title: title, body: body, onSuccess: onSuccess)
            }
        }
    }
    
    static func uploadCommentToServer(data: Data, caption: String, onSuccess: @escaping () -> Void) {
        
    }
    //Wont need
    static func uploadVideoToFirebaseStorage(videoUrl: URL, onSuccess: @escaping (_ videoUrl: String) -> Void) {
        let videoIdString = NSUUID().uuidString
        
        let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("posts").child(videoIdString)
        
        storageRef.putFile(from: videoUrl, metadata: nil) { (metadata, error) in
            if error != nil {
                return
            }
            storageRef.downloadURL(completion: { (url, error) in
                if let videoURL = url?.absoluteString {
                    onSuccess(videoURL)
                }
            })
            

        }
    }
    
    static func uploadImageToFirebaseStorage(data: Data, onSuccess: @escaping (_ imageUrl: String) -> Void) {
        
        let photoIdString = NSUUID().uuidString
        
        let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("posts").child(photoIdString)
        
        storageRef.putData(data, metadata: nil) { (metadata, error) in
            if error != nil {
                return
            }
            storageRef.downloadURL(completion: { (url, error) in
                if let photoURL = url?.absoluteString {
                    onSuccess(photoURL)
                }
            })
        }
    }
    // Not currently using
    static func sendDataToDatabase(photoUrl: String, videoUrl: String? = nil, ratio: CGFloat, caption: String, title: String, body: String, onSuccess: @escaping () -> Void) {
        let newPostId = Api.Post.REF_POSTS.childByAutoId().key
        let newPostReference = Api.Post.REF_POSTS.child(newPostId!)
        
        guard let currentUser = Api.Userr.CURRENT_USER else {
            return
        }
        // Hashtag Reference
        let words = caption.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        for var word in words {
            if word.hasPrefix("#") {
                word = word.trimmingCharacters(in: CharacterSet.punctuationCharacters)
                word = word.trimmingCharacters(in: CharacterSet.symbols)
                let newHashReference = Api.HashTag.REF_HASHTAG.child(word.lowercased())
                newHashReference.setValue([newPostId: true])
            }
        }
        
        let currentUserId = currentUser.uid
        var dict = ["uid": currentUserId ,"photoUrl": photoUrl, "caption": caption, "likeCount": 0, "ratio": ratio, "title": title, "body": body] as [String : Any]
        
        //Wont need
        if let videoUrl = videoUrl {
            dict["videoUrl"] = videoUrl
        }
        newPostReference.setValue(dict, withCompletionBlock: {
            (error, ref) in
            if error != nil {
               // ProgressHUD.showError(error!.localizedDescription)
                return
            }
            
            Api.Feed.REF_FEED.child(Api.Userr.CURRENT_USER!.uid).child(newPostId!).setValue(true)
            
            let myPostRef = Api.MyPosts.REF_MYPOSTS.child(currentUserId).child(newPostId!)
            myPostRef.setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil {
                  //  ProgressHUD.showError(error!.localizedDescription)
                    return
                }
            })
           // ProgressHUD.showSuccess("Success")
            onSuccess()
        })
    }
}
