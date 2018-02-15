//
//  SettingsViewController.swift
//  MOS_Project_iOS
//
//  Created by Nora Isabel Wokatsch on 01.02.18.
//  Copyright © 2018 fhooe.mc. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.title = "Settings"
    }

}
