//
//  LoginViewController.swift
//  MOS_Project_iOS
//
//  Created by solvistas on 11.01.18.
//  Copyright © 2018 fhooe.mc. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    struct KeychainConfiguration {
        static let serviceName = "TouchMeIn"
        static let accessGroup: String? = nil
    }
    
    var passwordItems: [KeychainPasswordItem] = []
    
    let loginSuccessLogin = "loginSuccess"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailText.placeholder = NSLocalizedString("Email", comment: "Email")
        passwordText.placeholder = NSLocalizedString("Password", comment: "Password")
        passwordText.isSecureTextEntry = true
        

    }
    
    @IBAction func loginPressed(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (user, error) in
            if error == nil {
                self.setupUserdata()
                self.performSegue(withIdentifier: self.loginSuccessLogin, sender: self)
            }else {
                self.showLoginFailedAlert()
            }
        }
    }
    
    private func setupUserdata(){
        guard let newAccountName = emailText.text,
            let newPassword = passwordText.text,
            !newAccountName.isEmpty,
            !newPassword.isEmpty else {
                showLoginFailedAlert()
                return
        }
        let hasLoginKey = UserDefaults.standard.bool(forKey: "hasLoginKey")
        if !hasLoginKey && emailText.hasText {
            UserDefaults.standard.setValue(emailText.text, forKey: "username")
        }
        do {
            // This is a new account, create a new keychain item with the account name.
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: newAccountName,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            
            // Save the password for the new item.
            try passwordItem.savePassword(newPassword)
        } catch {
            fatalError("Error updating keychain - \(error)")
        }
        UserDefaults.standard.set(true, forKey: "hasLoginKey")
    }
    
    private func showLoginFailedAlert() {
        let alertView = UIAlertController(title: "Login Problem",
                                          message: "Wrong username or password.",
                                          preferredStyle:. alert)
        let okAction = UIAlertAction(title: "Foiled Again!", style: .default)
        alertView.addAction(okAction)
        present(alertView, animated: true)
    }
}



