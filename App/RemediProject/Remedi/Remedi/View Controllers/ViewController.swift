//
//  ViewController.swift
//  Remedi
//
//  Created by Ngan Nguyen on 2019-10-28.
//  Copyright © 2019 Krystal Nguyen. All rights reserved.
//
//Programmers: Ngan Nguyen, David Song, Payam Partow, HuyThong Bui

import UIKit
import Firebase

class ViewController: UIViewController {
    
    //Connnect Buttons with main storyboard
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    //Function using to receive input from user
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //All the set up classes will be here
        setUpElements()
    }
    func setUpElements(){
        //Hide the error Label
        errorLabel.alpha = 0
        //Style all the textbox fields
        //Utilities.styleTextField(emailTextField)
        //Utilities.styleTextField(passwordTextField)
        //Utilities.styleFilledButton(signUpButton)
        //Utilities.styleHollowButton(loginButton)
    }

    @IBAction func signupTapped(_ sender: Any) {
        let signupViewController = self.storyboard?.instantiateViewController(identifier: "SignupVC") as? SignUpViewController
        self.view.window?.rootViewController = signupViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //Function using to check input of users with data on Firebase
    @IBAction func loginTapped(_ sender: Any) {
        //Validate Text Fields check if there is any errors if there are gotta show the message and not run the code below
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) {
            (result, error) in
            if error != nil{
                //Couldnt sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else{
                let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }

}

