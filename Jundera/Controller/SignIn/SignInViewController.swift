//
//  SignInViewController.swift
//  Balapoint
//
//  Created by Gina De La Rosa on 8/12/18.
//  Copyright © 2018 Gina Delarosa. All rights reserved.

//  User Sign In

import UIKit
import Firebase

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.isEnabled = false
        handleTextField()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Api.Userr.CURRENT_USER != nil {
            self.performSegue(withIdentifier: "signInToTabbarVC", sender: nil)
            
        }
    }
    
    func handleTextField() {
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        
    }
    
    @objc func textFieldDidChange() {
        guard let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
                signInButton.setTitleColor(UIColor.lightText, for: UIControlState.normal)
                signInButton.isEnabled = false
                return
        }
        
        signInButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        signInButton.isEnabled = true
    }
    
    @IBAction func signInButton_TouchUpInside(_ sender: Any) {
        let wrongPasswordAlert = UIAlertController(title: "Oops!", message: "Something went wrong. Please check that your email and or password is correct.", preferredStyle: .alert)
        wrongPasswordAlert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        
        view.endEditing(true)
        AuthService.signIn(email: emailTextField.text!, password: passwordTextField.text!, onSuccess: {
            self.performSegue(withIdentifier: "signInToTabbarVC", sender: nil)
        }, onError: { error in
            self.present(wrongPasswordAlert, animated: true, completion: nil)
        })
    }
    
    /// Takes user to Terms and Conditions
    @IBAction func goesToTermsPage(_ sender: Any) {
        if let url = URL(string: "https://www.balapoint.com/terms.html") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    /// Takes user to Privacy Policy
    @IBAction func goesToPrivacyPage(_ sender: Any) {
        if let url = URL(string: "https://www.balapoint.com/privacypolicy.html") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    // Action to reset password
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        let forgotPasswordAlert = UIAlertController(title: "Forgot password?", message: "Enter email address", preferredStyle: .alert)
        forgotPasswordAlert.addTextField { (textField) in
            textField.placeholder = "Enter email address"
        }
        forgotPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        forgotPasswordAlert.addAction(UIAlertAction(title: "Reset Password", style: .default, handler: { (action) in
            let resetEmail = forgotPasswordAlert.textFields?.first?.text
            Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: { (error) in
                if error != nil{
                    let resetFailedAlert = UIAlertController(title: "Reset Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetFailedAlert, animated: true, completion: nil)
                }else {
                    let resetEmailSentAlert = UIAlertController(title: "Reset email sent successfully", message: "Check your email", preferredStyle: .alert)
                    resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetEmailSentAlert, animated: true, completion: nil)
                }
            })
        }))
        self.present(forgotPasswordAlert, animated: true, completion: nil)
    }
    
}
