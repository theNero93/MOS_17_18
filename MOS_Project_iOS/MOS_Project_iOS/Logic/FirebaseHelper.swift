//
//  FirebaseHelper.swift
//  MOS_Project_iOS
//
//  Created by solvistas on 31.01.18.
//  Copyright © 2018 fhooe.mc. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import Firebase


class FirebaseHelper {
    static let shared = FirebaseHelper()
    private var dbRef: DatabaseReference!
    private var user: User?
    private var isLogedIn = false
    
    
    let KEY_USERDATA = "userdata"
    let KEY_SESSIONS = "sessions"
    
    
    private init() {
        FirebaseApp.configure()
        dbRef = Database.database().reference()
    }
    
    
    func loginUser(email: String, password: String, completion: @escaping (User?, Error?)->Void){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil {
                self.user = user!
                self.isLogedIn = true
                completion(user, nil)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func saveUserData(userData: UserData) -> Bool {
        if isLogedIn {
            dbRef.child("\(KEY_USERDATA)/\(user!.uid)").setValue(userData.jsonRep())
            return true
        }else {
            return false
        }
        
    }
    
    func getUserData(completion: @escaping (UserData?, Bool)->Void){
        if isLogedIn {
            dbRef.child("\(KEY_USERDATA)/\(user!.uid)").observeSingleEvent(of: .value){ (snapshot) in
                let value = snapshot.value as? [String : Any]
                let userData = UserData(json: value!)
                completion(userData, true)
            }
        }else {
            completion(nil, false)
        }
        

    }
    
    func saveSession(session: Session) -> Bool {
        if isLogedIn {
            let timekey = String(session.timeStamp.timeIntervalSince1970).replacingOccurrences(of: ".", with: "")
            let childRef = dbRef.child("\(KEY_SESSIONS)/\(user!.uid)/\(timekey)")
            let locRef = childRef.child(Session.KEY_LOCATIONS)
            let hrRef = childRef.child(Session.KEY_HEARTRATE)
            childRef.setValue(session.dictRep())
            
            for location in session.locations {
                locRef.child(String(location.timeStamp.timeIntervalSince1970).replacingOccurrences(of: ".", with: "")).setValue(location.dictRep())
            }
            
            for hr in session.heartRate {
                hrRef.child(String(hr.time)).setValue(hr.dictRep())
            }
            
            return true
        }else {
            return false
        }
    }
    
    func getSession(completion: @escaping ([Session]?, Bool)->Void) {
        if isLogedIn {
            dbRef.child("\(KEY_SESSIONS)/\(user!.uid)").observe(.value) { snapshot in
                var sessions: [Session] = []
                
                for child in snapshot.children {
                    let sessionChild = child as! DataSnapshot
                    let dict = sessionChild.value as! [String:AnyObject]
                    sessions.append(Session(any: dict))
                }
                completion(sessions, true)
            }
        }
    }
    
}
