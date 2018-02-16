//
//  SettingsViewController.swift
//  MOS_Project_iOS
//
//  Created by Nora Isabel Wokatsch on 01.02.18.
//  Copyright © 2018 fhooe.mc. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    let firebaseHelper = FirebaseHelper.shared
    
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var lastNameInput: UITextField!
    @IBOutlet weak var ageInput: UITextField!
    @IBOutlet weak var sexInput: UITextField!
    @IBOutlet weak var weightInput: UITextField!

    @IBOutlet weak var sizeInput: UITextField!
    @IBOutlet weak var stepGoalInput: UITextField!
    
    var user: UserData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    private func loadSettings(){
        firebaseHelper.getUserData(){(userData, success) in
            if success && userData != nil {
                self.user = userData
                self.setupView()
            }
        }
    }
    
    private func setupView(){
        if let mUser = user {
            nameInput.text = mUser.firstName
            lastNameInput.text = mUser.lastName
            ageInput.text = "\(mUser.age)"
            ageInput.keyboardType = .decimalPad
            sexInput.text = mUser.sex
            weightInput.text = "\(mUser.weight)"
            weightInput.keyboardType = .decimalPad
            sizeInput.text = "\(mUser.size)"
            stepGoalInput.text = "\(mUser.stepGoal)"
        }
        
    }
    
    private func saveSettings() {
        var mUser = UserData()
        if user != nil {
            mUser = user!
        }
        mUser.firstName = nameInput.text ?? ""
        mUser.lastName = lastNameInput.text ?? ""
        mUser.age = Int(ageInput.text ?? "0")!
        mUser.sex = sexInput.text ?? ""
        mUser.weight = Int(weightInput.text ?? "0")!
        mUser.size = Int(sizeInput.text ?? "0")!
        mUser.stepGoal = Int(stepGoalInput.text ?? "0")!
        if firebaseHelper.saveUserData(userData: mUser) {
            print("SavedSettings")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveSettings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.title = "Settings"
        loadSettings()
    }

}
