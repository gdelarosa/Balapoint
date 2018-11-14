//
//  SignUpViewController.swift
//  Balapoint
//
//  Created by Gina De La Rosa on 8/12/18.
//  Copyright © 2018 Gina Delarosa. All rights reserved.

// User Sign Up

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {
   var REF_USERS = Database.database().reference().child("users")
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        profileImage.layer.borderWidth = 2
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 8
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectProfileImageView))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        //handleTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleTextField()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    
    func handleTextField() {
        usernameTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        //emailTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        //passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        textField.text = usernameTextField.text?.lowercased()
        guard let username = usernameTextField.text, !username.isEmpty,
            let email = emailTextField.text, !email.isEmpty,
            
            let password = passwordTextField.text, !password.isEmpty else {
                signUpButton.setTitleColor(UIColor.lightText, for: UIControlState.normal)
                signUpButton.isEnabled = false
                return
        }
        signUpButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: UIControlState.normal)
        signUpButton.isEnabled = true
    }
    
    @objc func handleSelectProfileImageView() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func dismiss_onClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpBtn_TouchUpInside(_ sender: Any) {
        view.endEditing(true)
        self.loading.startAnimating()
        var profileImg = self.selectedImage
        if profileImg == nil {
            profileImg = UIImage(named: "placeholderImg")
        }

        let imageData = UIImageJPEGRepresentation(profileImg!, 0.1)

        AuthService.signUp(username: self.usernameTextField.text!, email: self.emailTextField.text!, password: self.passwordTextField.text!, imageData: imageData!, onSuccess: {
            self.loading.stopAnimating()
            self.performSegue(withIdentifier: "signUpToTabbarVC", sender: nil)
        }, onError: { (errorString) in
            let alertController = UIAlertController(title: "Oops!", message: errorString, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Okay", style: .default, handler: { (alert) in
                print("alert")
                alertController.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(alertAction)
            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("did Finish Picking Media")
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImage = image
            profileImage.image = image
            if profileImage.image == nil {
                profileImage.image = UIImage(named: "placeholderImg")
            }
        }
        dismiss(animated: true, completion: nil)
    }
}

