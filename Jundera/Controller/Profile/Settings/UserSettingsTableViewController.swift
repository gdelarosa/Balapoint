//
//  UserSettingsTableViewController.swift
//  Balapoint
//
//  Created by Gina De La Rosa on 8/19/18.
//  Copyright © 2018 Gina De La Rosa. All rights reserved.

//  Allows user to view settings.

import UIKit

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
    // Delete Account
    @IBAction func deleteAccount_TouchUpInside(_ sender: Any) {
        presentAlertWithTitle(title: "Are you sure?", message: "Deleting your account will result in all posts being deleted and information associated with your email.", options: "Yes Delete My Account", "Cancel") {
            (option) in
            switch(option) {
            case 0:
                print("Deleted Account")
                AuthService.deleteAccount(onSuccess: {
                    let storyboard = UIStoryboard(name: "Start", bundle: nil)
                    let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
                    self.present(signInVC, animated: true, completion: nil)
                }, onError: { (errorString) in
                    print("Error with deleting account!")
                })
                break
            case 1:
                print("Cancelled")
            default:
                break
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
