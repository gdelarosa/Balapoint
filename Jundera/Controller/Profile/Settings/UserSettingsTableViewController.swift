//
//  UserSettingsTableViewController.swift
//  Jundera
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
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }



}
