//
//  LoadingViewController.swift
//  MOS_Project_iOS
//
//  Created by solvistas on 17.01.18.
//  Copyright © 2018 fhooe.mc. All rights reserved.
//

import UIKit
import Firebase

class LoadingViewController: UIViewController {
    struct KeychainConfiguration {
        static let serviceName = "TouchMeIn"
        static let accessGroup: String? = nil
    }
    
    let loginSegueIdentifier = "loginSegue"
    let menuSegueIdentifier = "menuSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let hasLoginKey = UserDefaults.standard.bool(forKey: "hasLoginKey")
        if hasLoginKey {
            print("Has User Login")
            toLogin()
        }else {
            performSegue(withIdentifier: loginSegueIdentifier, sender: self)
            //toLogin()
            print("has no User Login")
        }
        

        // Do any additional setup after loading the view.
    }

    
    private func checkLogin(){
        //Check Login
        guard let username = UserDefaults.standard.value(forKey: "username") as? String else {
            print("No Username Stored -> toLogin")
            performSegue(withIdentifier: loginSegueIdentifier, sender: self)
            //toLogin()
            return
        }
        
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: username,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            let keychainPassword = try passwordItem.readPassword()
            print("Does it run?")
            Auth.auth().signIn(withEmail: username, password: keychainPassword) { (user, error) in
                if error == nil {
                    print("Username: \(username), Password: \(keychainPassword)")
                    self.performSegue(withIdentifier: self.menuSegueIdentifier, sender: self)
                }else {
                    
                    print("No Login Found -> To Login Controller")
                    self.performSegue(withIdentifier: self.loginSegueIdentifier, sender: self)
                    //self.toLogin()
                }
            }
        } catch {
            fatalError("Error reading password from keychain - \(error)")
        }
    }
    
    private func toLogin(){
        print("Perform Segue")
        performSegue(withIdentifier: loginSegueIdentifier, sender: self)
    }

}
