//
//  CameraViewController.swift
//  Metis
//
//  Created by Gina De La Rosa on 11/15/17.
//  Copyright © 2017 Gina Delarosa. All rights reserved.
//  For Creating a new post. TODO: Change this VC file name. 

import UIKit
import AVFoundation

class CreatePostViewController: UIViewController {
    
    @IBOutlet weak var photo: UIImageView! // Should be optional to post a picture
    @IBOutlet weak var captionTextView: UITextView! // Post Body
    @IBOutlet weak var shareButton: UIButton! // Post Button
    @IBOutlet weak var postTitle: UITextField! // Title
    @IBOutlet weak var header: UITextField! // Header
    @IBOutlet weak var deletePost: UIButton! // Delete Post
    
    var selectedImage: UIImage?
    var videoUrl: URL? //Wont need
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        photo.addGestureRecognizer(tapGesture)
        photo.isUserInteractionEnabled = true
        
        let aTabArray: [UITabBarItem] = (self.tabBarController?.tabBar.items)!
        for item in aTabArray {
            item.image = item.image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            item.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handlePost()
    }
    
    func handlePost() {
        
        if postTitle != nil {
           self.shareButton.isEnabled = true
            self.deletePost.isEnabled = true
           
        } else {
           self.shareButton.isEnabled = true
            self.deletePost.isEnabled = false
           
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func handleSelectPhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.mediaTypes = ["public.image", "public.movie"]
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func shareButton_TouchUpInside(_ sender: Any) {
        view.endEditing(true)
      
        if let profileImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            let ratio = profileImg.size.width / profileImg.size.height
           
            HelperService.uploadDataToServer(data: imageData, videoUrl: self.videoUrl, ratio: ratio, caption: header.text!, title: postTitle.text!, body: captionTextView.text!, onSuccess: {
                print("Successfully sent info to database!")
            self.clean()
            self.tabBarController?.selectedIndex = 0
        })
        
        } else {
            print("FAILED")
        }
    }
    
    /// Delete Button
    @IBAction func remove_TouchUpInside(_ sender: Any) {
        clean()
        handlePost()
    }
    
    /// This will delete the information if you press the X button 
    func clean() {
        self.header.text = ""
        self.postTitle.text = "" //added
        self.photo.image = UIImage(named: "placeholder-photo")
        self.selectedImage = nil
        self.captionTextView.text = ""
    }
    
    // TO-DO: Have an alert appear after tapping X. Should have the option to DELETE or SAVE AS DRAFT. If save as draft it will appear in the user profile. Will then have to clear out to start over.
    
}

// Extension for camera
extension CreatePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("did Finish Picking Media")
        print(info)
        
        if let videoUrl = info["UIImagePickerControllerMediaURL"] as? URL {
            if let thumnailImage = self.thumbnailImageForFileUrl(videoUrl) {
                selectedImage = thumnailImage
                photo.image = thumnailImage
                self.videoUrl = videoUrl
            }
            dismiss(animated: true, completion: nil)
        }
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImage = image
            photo.image = image
            dismiss(animated: true, completion: { 
            print("Image should appear in post")
            })
        }
    }
    
    func thumbnailImageForFileUrl(_ fileUrl: URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(7, 1), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch let err {
            print(err)
        }
        
        return nil
    }
}

