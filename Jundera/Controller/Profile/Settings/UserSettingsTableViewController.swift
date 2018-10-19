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
        setBackButton()
    }
    
    func setBackButton() {
        //Back buttion
        let btnLeftMenu: UIButton = UIButton()
        btnLeftMenu.setImage(UIImage(named: "back"), for: UIControlState())
        btnLeftMenu.addTarget(self, action: #selector(UserSettingsTableViewController.onClickBack), for: UIControlEvents.touchUpInside)
        btnLeftMenu.frame = CGRect(x: 0, y: 0, width: 33/2, height: 27/2)
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func onClickBack()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }



}
