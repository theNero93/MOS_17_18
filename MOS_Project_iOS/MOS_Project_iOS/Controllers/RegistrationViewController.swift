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
    
    let firebaseHelper = FirebaseHelper.shared
    
    struct KeychainConfiguration {
        static let serviceName = "TouchMeIn"
        static let accessGroup: String? = nil
    }
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var ageText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var passwordRepeateText: UITextField!
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var size: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var stepGoal: UITextField!
    
    
    let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
    let numberRegEx = "[0-9]"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordText.isSecureTextEntry = true
        passwordRepeateText.isSecureTextEntry = true


    }


    @IBAction func checkRegistration(_ sender: Any) {
        if !isValidRegEx(string: emailText.text!, regEx: emailRegEx){
            print("Email is not Valide")
            return
        }
        if !isMatching(stringOne: passwordText.text!, stringTwo: passwordRepeateText.text!) {
            print("Password is not matching")
            return
        }
        
        if !checkUserFields() {
            print("User Fields are not filled correctly")
            return
        }
        
        Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (user, error) in
            print("Create User")
            if user != nil {
                self.setupUserdata()
                print("User != nil")
                self.firebaseHelper.loginUser(email: self.emailText.text!, password: self.passwordText.text!){ (user, error) in
                    print("Sign In")
                    if error == nil {
                        print("Error == nil")
                        self.saveUserData(userID: user!.uid)
                        
                        self.performSegue(withIdentifier: self.mainScreenSegue, sender: self)
                    }
                    
                }
            }else {
                print(error?.localizedDescription ?? "Not an error")
            }
        }
    }
    
    private func saveUserData(userID: String) {
        let userData = UserData()
        userData.firstName = firstName.text!
        userData.lastName = lastName.text!
        userData.age = Int(ageText.text!) ?? 0
        userData.sex = gender.text!
        userData.size = Int(size.text!) ?? 0
        userData.weight = Int(weight.text!) ?? 0
        userData.stepGoal = Int(stepGoal.text!) ?? 0
        
        
        
        if firebaseHelper.saveUserData(userData: userData) {
            print("Save could have worked....")
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
    
    private func checkUserFields() -> Bool {
        if !firstName.hasText || !lastName.hasText {
            return false
        }
        if !ageText.hasText || !gender.hasText || !weight.hasText || !size.hasText{
            return false
        }/*else {
            if !isValidRegEx(string: ageText.text!, regEx: numberRegEx) {
                return false
            }
            if !isValidRegEx(string: gender.text!, regEx: numberRegEx) {
                return false
            }
            if !isValidRegEx(string: weight.text!, regEx: numberRegEx) {
                return false
            }
            if !isValidRegEx(string: size.text!, regEx: numberRegEx) {
                return false
            }*/
            return true
        //}
        
    }
    
    private func isValidRegEx(string: String, regEx: String) -> Bool {
        
        var returnValue = true
        
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = string as NSString
            let results = regex.matches(in: string, range: NSRange(location: 0, length: nsString.length))
            
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
    
    private func isMatching(stringOne: String, stringTwo: String) -> Bool{
        if stringOne == stringTwo {
            return true
        }
        return false
    }
}
