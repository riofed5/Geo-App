//
//  ViewController.swift
//  geoapp
//
//  Created by team geo app on 10/04/2020.
//  Copyright © 2020 team geo app. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import GoogleSignIn

class LoginViewController: UIViewController, UITextFieldDelegate, GIDSignInDelegate {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var googleSignInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        //style the sign in page
        usernameLabel.textColor = UIColor(red: 0.11, green: 0.21, blue: 0.34, alpha: 1.00)
        passwordLabel.textColor = UIColor(red: 0.11, green: 0.21, blue: 0.34, alpha: 1.00)
        
        signInButton.layer.cornerRadius = 8
        signInButton.backgroundColor = UIColor(red: 0.11, green: 0.21, blue: 0.34, alpha: 1.00)
        
        googleSignInBtn.layer.cornerRadius = 20
        
        textLabel.textColor = UIColor(red: 0.90, green: 0.22, blue: 0.27, alpha: 1.00)

        usernameTextField.autocorrectionType = .no
        passwordTextField.autocorrectionType = .no
        
        usernameTextField.textContentType = .oneTimeCode
        passwordTextField.textContentType = .oneTimeCode
    
        updateSignInButtonState()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let alert: UIAlertController
        let alertTitle = NSLocalizedString("Not allowed", comment: "")
        let alertMessage1 = NSLocalizedString("Username cannot be shorter than 3 characters.", comment: "")
        let alertMessage2 = NSLocalizedString("Password cannot be shorter than 5 characters.", comment: "")
        let alertMessage3 = NSLocalizedString("Field cannot be empty.", comment: "")
        if (textField.text?.count != 0) {
            let identifer = textField.accessibilityIdentifier
            if (identifer == "username" && textField.text!.count < 3) {
                alert = UIAlertController(title: alertTitle, message: alertMessage1, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                return false
            }
            else if (identifer == "password" && textField.text!.count < 5) {
                alert = UIAlertController(title: alertTitle, message: alertMessage2 , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                return false
            }
            
            textField.resignFirstResponder()
            updateSignInButtonState()
            return true
        }
        alert = UIAlertController(title: alertTitle, message: alertMessage3, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

        self.present(alert, animated: true)
        return false
    }

    @IBAction func signInCustom(_ sender: Any) {
        let loginInfo = [
            "username": usernameTextField.text!,
            "password": passwordTextField.text!,
        ]
        Helpers.signIn(loginInfo: loginInfo, viewController: self)
    }
    
    @IBAction func signInWithGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
          if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
            print("The user has not signed in before or they have since signed out.")
          } else {
            print("\(error.localizedDescription)")
          }
          return
        }else{
            // Perform any operations on signed in user here.
            let idToken = user.authentication.idToken! // Safe to send to the server
            let usernameGG = user.profile.givenName!
            print("name is :", usernameGG)
            
            //Save data to CoreData
            Helpers.setNewUserInfo(token: idToken, username: usernameGG)
            
            //Navigate to Home screen
            Helpers.showHomeView(self)
        }
    }
    
    func updateSignInButtonState() {
        guard let usernameText = usernameTextField.text, let passwordText = passwordTextField.text else { return }
        signInButton.isHidden = (usernameText.isEmpty || passwordText.isEmpty)
    }
}

