//
//  LoginViewController.swift
//  StudentProfessorApp
//
//  Created by Mac-6 on 10/05/20.
//  Copyright © 2020 Mac-6. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK:-
    @IBOutlet var UsernameTextField: CustomTextField!
    @IBOutlet var passwordTextField: CustomTextField!
    @IBOutlet var accessCodeTextView: CustomTextField!
    
    //MARK:- Variables
    public var userList: [User] = []
    public var codeList: [Code] = []
    var username = ""
    var passString = ""
    var checkRecord = false
    var profession = ""
    var acessCode = ""
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        UsernameTextField.placeholderText = "Enter Username"
        passwordTextField.placeholderText = "Enter Password"
        accessCodeTextView.placeholderText = "Enter Access Code"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getTaskDetails()
        getAcessCodes()
    }
    
    //MARK:-
    func getTaskDetails() {
        self.userList = CoreDataManager.sharedInstance.getTaskFromDatabase()
        
    }
    func getAcessCodes() {
        self.codeList = CoreDataManager.sharedInstance.getAcessCodeFromDatabase()
    }
    
    //MARK:-
    @IBAction func didSelectLoginButton(_ sender: UIButton) {
        for users in self.userList {
            username = users.value(forKeyPath: "username") as! String
            passString = users.value(forKeyPath: "password") as! String
            if username == UsernameTextField.text && passwordTextField.text == passString {
                checkRecord = true
                break
            } else {
                checkRecord = false
            }
        }
        
        if checkRecord == true {
            let pvc = self.storyboard!.instantiateViewController(withIdentifier: "ProfessionViewController") as! ProfessionViewController
            pvc.teacherUsername = username
            
            self.showSuccessPopup(label: "Login Successfully")
            
            let nav = UINavigationController(rootViewController: pvc)
            self.view.window?.rootViewController = nav
            self.view.window?.makeKeyAndVisible()
        } else  {
            self.showAlert(message: "No User Found. Please enter correct credentials")
        }
    }
    
    @IBAction func didSelectCreateAccount(_ sender: UIButton) {
        let pvc = storyboard?.instantiateViewController(withIdentifier: "CreateAccountViewController") as! CreateAccountViewController
        pvc.modalPresentationStyle = .fullScreen
        self.present(pvc, animated: true, completion: nil)
    }
    
    @IBAction func didSelectAccessCodeButton(_ sender: UIButton) {
        for users in self.codeList {
            acessCode = users.value(forKeyPath: "accesCode") as! String
            if acessCode == accessCodeTextView.text {
                checkRecord = true
                break
            } else {
                checkRecord = false
            }
        }
        
        if checkRecord == true {
            let pvc = self.storyboard!.instantiateViewController(withIdentifier: "StudentViewController") as! StudentViewController
            pvc.code = acessCode
            let navController = UINavigationController(rootViewController: pvc)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated:true, completion: nil)
        } else {
            self.showAlert(message: "No User Found. Please enter correct credentials")
        }
    }
}
