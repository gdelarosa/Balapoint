//
//  CameraViewController.swift
//  Balapoint
//
//  Created by Gina De La Rosa on 11/15/17.
//  Copyright © 2017 Gina Delarosa. All rights reserved.

//  For Creating a new post. TODO: Change this VC file name. 

import UIKit
import AVFoundation

class CreatePostViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var photo: UIImageView! // Should be optional to post a picture
    @IBOutlet weak var captionTextView: UITextView! // Post Body
    @IBOutlet weak var postTitle: UITextField! // Title
    @IBOutlet weak var header: UITextField! // Header
    
    
    var selectedImage: UIImage?
    var videoUrl: URL? //Wont need
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsBarButton()
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
        captionTextView.delegate = self
        //handlePost()
    }
    
    ///Navigation Bar
    func settingsBarButton() {
        let button: UIButton = UIButton(type: UIButtonType.custom)
        button.setImage(UIImage(named: "Dark.png"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(deletePostInfo), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x:0.0,y:0.0, width:25,height: 25.0)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        
        let publishButton: UIButton = UIButton(type: UIButtonType.custom)
        publishButton.addTarget(self, action: #selector(shareButton_TouchUpInside(_:)), for: UIControlEvents.touchUpInside)
        publishButton.setTitle("Publish", for: UIControlState.normal)
        publishButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        let rightBarButton = UIBarButtonItem(customView: publishButton)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        
        self.navigationItem.title = "Create"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Futura", size: 18)!]
    }
    
    // Deletes post info
    @objc func deletePostInfo() {
        print("Delete post button pressed on nav bar")
        presentAlertWithTitle(title: "Are you sure?", message: "Select yes to clear post.", options: "Yes", "Cancel") {
            (option) in
            switch(option) {
            case 0:
                print("Clear Post")
                self.clean()
                break
            case 1:
                print("Cancelled")
            default:
                break
            }
        }
    }

    
    //Adds a bullet point to each new line
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        if (text == "\n") {
            if range.location == textView.text.count {
                let updatedText: String = textView.text!.appendingFormat("\n \u{2022} ")
                textView.text = updatedText
            }
            else {
                let beginning: UITextPosition = textView.beginningOfDocument
                let start: UITextPosition = captionTextView.position(from: beginning, offset: range.location)!
                let end: UITextPosition = textView.position(from: start, offset: range.length)!
                let textRange: UITextRange = captionTextView.textRange(from: start, to: end)!
            
                captionTextView.replace(textRange, withText: "\n \u{2022} ")
            
                let cursor: NSRange = NSMakeRange(range.location, 0)
                    //NSMakeRange(range.location + "\n \u{2022} ", 0)
            
                textView.selectedRange = cursor
            }
            return false
        }
        return true
    }

    func handlePost() {
        
        if postTitle != nil {
          // self.shareButton.isEnabled = true
            //self.deletePost.isEnabled = true
           
        } else {
           //self.shareButton.isEnabled = true
            //self.deletePost.isEnabled = false
           
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
        if (postTitle.text?.isEmpty)! {
            print("title is empty")
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.07
            animation.repeatCount = 2
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: postTitle.center.x - 10, y: postTitle.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: postTitle.center.x + 10, y: postTitle.center.y))
            postTitle.layer.add(animation, forKey: "position")
        } else {
            presentAlertWithTitle(title: "How would you like to publish?", message: "", options: "Make Public", " Make Private", "Cancel") {
                (option) in
                switch(option) {
                case 0:
                    print("Public")
                    if let profileImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
                        let ratio = profileImg.size.width / profileImg.size.height
                        
                        HelperService.uploadDataToServer(data: imageData, videoUrl: self.videoUrl, ratio: ratio, caption: self.header.text!, title: self.postTitle.text!, body: self.captionTextView.text!, onSuccess: {
                            print("Successfully sent info to database!")
                            self.clean()
                            self.tabBarController?.selectedIndex = 0
                        })
                        
                    } else {
                        print("FAILED TO POST")
                    }
                    break
                case 1:
                    print("Private")
                default:
                    break
                }
            }
        }
    }
    
//    /// Clear Button
//    @IBAction func remove_TouchUpInside(_ sender: Any) {
//        presentAlertWithTitle(title: "Are you sure?", message: "Select yes to clear post or save as a draft", options: "Yes", "Draft", "Cancel") {
//            (option) in
//            switch(option) {
//            case 0:
//                print("Clear Post")
//                self.clean()
//                self.handlePost()
//                break
//            case 1:
//                print("Save as draft")
//            case 2:
//                print("Cancel")
//            default:
//                break
//            }
//        }
//    }
    
    /// This will delete the information if you press the X button 
    func clean() {
        self.header.text = ""
        self.postTitle.text = ""
        self.photo.image = UIImage(named: "placeholder-photo")
        self.selectedImage = nil
        self.captionTextView.text = ""
    }
    
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

