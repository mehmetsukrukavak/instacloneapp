//
//  ViewController.swift
//  InstaCloneApp
//
//  Created by Mehmet Sukru Kavak on 27.03.2023.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }

    @IBAction func signInClicked(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != ""{
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {
                (authdata, error) in
                if error != nil {
                    
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                   
                } else{
                    self.performSegue(withIdentifier: "ToFeedVC", sender: nil)
                    
                }
            }
        } else{
            makeAlert(title: "Error", message: "Username/password?")
        }
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != ""{
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) {
                (authdata, error) in
                if error != nil {
                    
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                   
                } else{
                    self.performSegue(withIdentifier: "ToFeedVC", sender: nil)
                    
                }
            }
        } else{
            makeAlert(title: "Error", message: "Username/password?")
        }
        
    }
    
    func makeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}

