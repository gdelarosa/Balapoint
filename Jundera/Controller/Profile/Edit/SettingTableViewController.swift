//
//  SettingTableViewController.swift
//  Metis
//
//  Created by Gina De La Rosa on 11/15/17.
//  Copyright © 2017 Gina Delarosa. All rights reserved.
//  View Controller will allow user to edit their profile. 

import UIKit

protocol SettingTableViewControllerDelegate {
    func updateUserInfor()
}

class SettingTableViewController: UITableViewController {

    @IBOutlet weak var usernnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var goalTextField: UITextField!
    
    var delegate: SettingTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Edit Profile"
        usernnameTextField.delegate = self
        emailTextField.delegate = self
        goalTextField.delegate = self
        fetchCurrentUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false //Testing for Profile Editing
    }
    
    func fetchCurrentUser() {
        Api.Userr.observeCurrentUser { (userr) in
            self.usernnameTextField.text = userr.username
            self.emailTextField.text = userr.email
            self.goalTextField.text = userr.bio
            if let profileUrl = URL(string: userr.profileImageUrl!) {
                self.profileImageView.sd_setImage(with: profileUrl)
            }
        }
    }
    
    @IBAction func saveBtn_TouchUpInside(_ sender: Any) {
        if let profileImg = self.profileImageView.image, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
          
            AuthService.updateUserInfor(username: usernnameTextField.text!, email: emailTextField.text!,
                goal:goalTextField.text!, imageData: imageData, onSuccess: {
                print("Success!)")
                self.delegate?.updateUserInfor()
            }, onError: { (errorMessage) in
                print("Error: \(String(describing: errorMessage))")
            })
        }
    }

    @IBAction func logoutBtn_TouchUpInside(_ sender: Any) {
        AuthService.logout(onSuccess: {
            let storyboard = UIStoryboard(name: "Start", bundle: nil)
            let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
            self.present(signInVC, animated: true, completion: nil)
        }) { (errorMessage) in
            print("ERROR: \(String(describing: errorMessage))")
        }
    }
    
    @IBAction func changeProfileBtn_TouchUpInside(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }

}

extension SettingTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("did Finish Picking Media")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            profileImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

extension SettingTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return")
        textField.resignFirstResponder()
        return true
    }
}











































