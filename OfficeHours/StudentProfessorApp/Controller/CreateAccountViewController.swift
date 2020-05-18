//
//  CreateAccountViewController.swift
//  StudentProfessorApp
//
//  Created by Mac-6 on 10/05/20.
//  Copyright © 2020 Mac-6. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {
    
    //MARK:-
    @IBOutlet var nameTextField: CustomTextField!
    @IBOutlet var usernameTextField: CustomTextField!
    @IBOutlet var passwordTextField: CustomTextField!
  
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.placeholderText = "Username"
        passwordTextField.placeholderText = "Password"
        nameTextField.placeholderText = "Enter Your Name"
    }
    
    //MARK:-
    @IBAction func didSelectCreateAccount(_ sender: UIButton) {
        if usernameTextField.text != nil && passwordTextField.text != "" && nameTextField.text != "" {
            CoreDataManager.sharedInstance.saveTaskInDatabase(usernameTextField.text!, password: passwordTextField.text!, name: nameTextField.text!)
            let pvc = self.storyboard!.instantiateViewController(withIdentifier: "ProfessionViewController") as! ProfessionViewController
            pvc.teacherUsername = usernameTextField.text!
            
            self.showSuccessPopup(label: "Sign Up Success")
            
            let nav = UINavigationController(rootViewController: pvc)
            self.view.window?.rootViewController = nav
            self.view.window?.makeKeyAndVisible()
        } else {
            self.showAlert(message: "Enter all the fields")
        }
    }

    @IBAction func didSelectLogIn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
}

extension UIViewController {
    func showAlert(title: String = "", message: String)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showSuccessPopup(label: String) {
        let viewToShowHUDOn = UIApplication.shared.windows.last?.rootViewController?.view
        let hud = HKProgressHUD.show(addedToView: viewToShowHUDOn!, animated: true)
        hud.mode = .customView
        hud.customView = UIImageView(image: #imageLiteral(resourceName: "Checkmark"))
        hud.isSquare = true
        hud.label?.text = NSLocalizedString(label, comment: "hud done title")
        hud.hide(animated: true, afterDelay: 1.0)
    }
}
