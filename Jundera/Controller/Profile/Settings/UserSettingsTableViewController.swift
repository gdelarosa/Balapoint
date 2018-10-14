//
//  UserSettingsTableViewController.swift
//  Jundera
//
//  Created by Gina De La Rosa on 8/19/18.
//  Copyright © 2018 Gina De La Rosa. All rights reserved.
//

import UIKit

protocol UserSettingTableViewControllerDelegate {
    func updateUserSettings()
}

class UserSettingsTableViewController: UITableViewController {
    
     var delegate: UserSettingTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }


}
