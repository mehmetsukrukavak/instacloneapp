//
//  SettingsViewController.swift
//  InstaCloneApp
//
//  Created by Mehmet Sukru Kavak on 28.03.2023.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signOutClicked(_ sender: Any) {
        
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "ToViewController", sender: nil)
        }catch {
            print("Error")
        }
        
    }
    

}
