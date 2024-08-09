//
//  SettingsVC.swift
//  InstaStories
//
//  Created by Sualp DANACI on 9.08.2024.
//

import UIKit
import Firebase
import FirebaseAuth

class SettingsVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func logoutClicked(_ sender: Any) {
        do {
                   try Auth.auth().signOut()
                   self.performSegue(withIdentifier: "toSignInVC", sender: nil)
               } catch {
                   
               }
    }
}
