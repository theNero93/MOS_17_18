//
//  SessionMainViewController.swift
//  MOS_Project_iOS
//
//  Created by solvistas on 30.01.18.
//  Copyright © 2018 fhooe.mc. All rights reserved.
//

import UIKit

class SessionMainViewController: UIViewController {
    let sessionCellReuseIdentifier = "sessionCell"
    
    let segueSessionDetailIdentifier = "sessionDetailSegue"
    
    var sessions = [Session]()
    
    var selectedSession = Session()

    @IBOutlet weak var lastSessionsTableView: UITableView!
    
    //border color
    var borderColor = UIColor(red:0.00, green:0.47, blue:0.60, alpha:1.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lastSessionsTableView.delegate = self
        lastSessionsTableView.dataSource = self
        
        //start sessoion button border color
//        self.butt.layer.borderColor = self.borderColor.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.title = "Session"
    }


}


extension SessionMainViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: sessionCellReuseIdentifier, for: indexPath) as! SessionTableViewCell
        cell.sessionDateLabel.text = "02.01.2018"
        cell.sessionTimeLabel.text = "01:04:54"
        
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

}

extension SessionMainViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSession = sessions[indexPath.row]
        performSegue(withIdentifier: segueSessionDetailIdentifier, sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifer = segue.identifier else {
            return
        }
        
        switch identifer {
        case segueSessionDetailIdentifier:
            guard let sessionDetailViewController = segue.destination as? SessionDetailViewController else {
                print("Not a Session Detail View Controller")
                return
            }
            sessionDetailViewController.session = selectedSession
        default:
            break
        }
       
    }
}

