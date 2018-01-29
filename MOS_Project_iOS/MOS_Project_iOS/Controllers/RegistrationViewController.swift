//
//  RegistrationViewController.swift
//  MOS_Project_iOS
//
//  Created by solvistas on 11.01.18.
//  Copyright © 2018 fhooe.mc. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewController: UIViewController {
    let mainScreenSegue = "mainScreenSegue"
    struct KeychainConfiguration {
        static let serviceName = "TouchMeIn"
        static let accessGroup: String? = nil
    }
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var ageText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var passwordRepeateText: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailText.placeholder = NSLocalizedString("Email", comment: "Email")
        ageText.placeholder = NSLocalizedString("Age", comment: "Alter")
        passwordText.placeholder = NSLocalizedString("Password", comment: "Passwort")
        passwordText.isSecureTextEntry = true
        passwordRepeateText.placeholder = NSLocalizedString("Password Again", comment: "Password2")
        passwordRepeateText.isSecureTextEntry = true


    }


    @IBAction func checkRegistration(_ sender: Any) {
        if !isValidEmailAddress(emailAddressString: emailText.text!){
            print("Email is not Valide")
            return
        }
        if !isMatching(stringOne: passwordText.text!, stringTwo: passwordRepeateText.text!) {
            print("Password is not matching")
            return
        }
        Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (user, error) in
            print("Create User")
            if user != nil {
                self.setupUserdata()
                print("User != nil")
                Auth.auth().signIn(withEmail: self.emailText.text!,
                                   password: self.passwordText.text!){(user, error) in
                                    print("Sign In")
                                    if error == nil {
                                        print("Error == nil")
                                        self.performSegue(withIdentifier: self.mainScreenSegue, sender: self)
                                    }
                }
            }else {
                print(error?.localizedDescription ?? "Not an error")
            }
        }
    }
    private func setupUserdata(){
        guard let newAccountName = emailText.text,
            let newPassword = passwordText.text,
            !newAccountName.isEmpty,
            !newPassword.isEmpty else {
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
    
}


extension RegistrationViewController {
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    func isMatching(stringOne: String, stringTwo: String) -> Bool{
        if stringOne == stringTwo {
            return true
        }
        return false
    }
}
