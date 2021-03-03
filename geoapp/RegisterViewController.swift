//
//  RegisterViewController.swift
//  geoapp
//
//  Created by Quan Dao on 22.4.2020.
//  Copyright © 2020 team geo app. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self
        
        passwordTextField.autocorrectionType = .no
        usernameTextField.autocorrectionType = .no
        emailTextField.autocorrectionType = .no
        
        usernameTextField.textContentType = .oneTimeCode
        emailTextField.textContentType = .oneTimeCode
        passwordTextField.textContentType = .oneTimeCode
        
        updateSignUpButtonState()
        // Do any additional setup after loading the view.
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.accessibilityIdentifier == "username" && textField.text!.count >= 3) {
            AF.request("http://media.mw.metropolia.fi/wbma/users/username/" + textField.text!).responseJSON {
                response in
                let available = (response.value as! NSDictionary)["available"] as! NSNumber;
                if (available == 0) {
                    let alertTitle = NSLocalizedString("Not available", comment: "")
                    let alertMessage = NSLocalizedString("Username already exists", comment: "")
                    let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in
                        self.usernameTextField.becomeFirstResponder()
                    }))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let alert: UIAlertController
        let alertTitle = NSLocalizedString("Not allowed", comment: "")
        let alertMessage1 = NSLocalizedString("Username cannot be shorter than 3 characters.", comment: "")
        let alertMessage2 = NSLocalizedString("Password cannot be shorter than 5 characters.", comment: "")
        let alertMessage3 = NSLocalizedString("Invalid email.", comment: "")
        let alertMessage4 = NSLocalizedString("Field cannot be empty.", comment: "")
        if (textField.text?.count != 0) {
            let identifer = textField.accessibilityIdentifier
            if (identifer == "username" && textField.text!.count < 3) {
                alert = UIAlertController(title: alertTitle, message: alertMessage1, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                return false
            }
            else if (identifer == "password" && textField.text!.count < 5) {
                alert = UIAlertController(title: alertTitle, message: alertMessage2, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                return false
            }
            else if (identifer == "email" && !isValidEmail(textField.text!)) {
                alert = UIAlertController(title: alertTitle, message: alertMessage3, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                return false
            }
            
            textField.resignFirstResponder()
            updateSignUpButtonState()
            return true
        }
        
        alert = UIAlertController(title: alertTitle, message: alertMessage4, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true)
        return false
    }
    
    func updateSignUpButtonState() {
        guard let usernameText = usernameTextField.text, let passwordText = passwordTextField.text, let emailText = emailTextField.text else { return }
        signUpButton.isHidden = (usernameText.isEmpty || passwordText.isEmpty || emailText.isEmpty)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    @IBAction func signUp(_ sender: Any) {
        let signUpInfo = [
            "username": usernameTextField.text!,
            "password": passwordTextField.text!,
            "email": emailTextField.text!,
        ]
        
        AF.request("http://media.mw.metropolia.fi/wbma/users", method: .post, parameters: signUpInfo).validate().responseJSON {response in
            if (response.value != nil) {
                var loginInfo = signUpInfo
                loginInfo.removeValue(forKey: "email")
                Helpers.signIn(loginInfo: loginInfo, viewController: self)
            }
        }
    }
    /*
     
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
