//
//  UserSettingsTableViewController.swift
//  Balapoint
//
//  Created by Gina De La Rosa on 8/19/18.
//  Copyright © 2018 Gina De La Rosa. All rights reserved.

//  Allows user to view settings.

import UIKit
import Firebase

protocol UserSettingTableViewControllerDelegate {
    func updateUserSettings()
}

class UserSettingsTableViewController: UITableViewController {
    
     var delegate: UserSettingTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Settings"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Futura", size: 18)!]
        setBackButton()
    }
    
    @IBAction func goToTermsPage(_ sender: Any) {
        if let url = URL(string: "https://www.balapoint.com/terms.html") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func goToPrivacyPage(_ sender: Any) {
        if let url = URL(string: "https://www.balapoint.com/privacypolicy.html") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    // Logout
    @IBAction func logoutBtn_TouchUpInside(_ sender: Any) {
        AuthService.logout(onSuccess: {
            let storyboard = UIStoryboard(name: "Start", bundle: nil)
            let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
            self.present(signInVC, animated: true, completion: nil)
        }) { (errorMessage) in
            print("ERROR: \(String(describing: errorMessage))")
        }
    }
    
    // Delete Account: Need to add an alert before deleting.
    @IBAction func deleteAccount_TouchUpInside(_ sender: Any) {
        let user = Auth.auth().currentUser
        user?.delete { error in
            if let error = error {
                print("Error with deleting account: \(error)")
            } else {
                print("Successfully deleted account")
                let storyboard = UIStoryboard(name: "Start", bundle: nil)
                let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
                self.present(signInVC, animated: true, completion: nil)
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }



}
