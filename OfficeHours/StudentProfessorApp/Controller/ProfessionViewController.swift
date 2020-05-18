//
//  ProfessionViewController.swift
//  StudentProfessorApp
//
//  Created by Mac-6 on 10/05/20.
//  Copyright © 2020 Mac-6. All rights reserved.
//

import UIKit

class ProfessionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var teacherUsername = ""
    public var codeArray: [Code] = []
    
    @IBOutlet var dataTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fillCodeArray()
        
        self.navigationItem.setHidesBackButton(true, animated: false);
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.title = "List of Access Code"
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:  #selector(addAcessCodeaction))
        self.navigationItem.rightBarButtonItem  = barButtonItem
        
        let barButtonItem1 = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(logOutAction))
        self.navigationItem.leftBarButtonItem  = barButtonItem1
        // Do any additional setup after loading the view.
        
        dataTableView.reloadData()
    }
    
    //MARK:-
    func fillCodeArray()  {
        if let codeList = CoreDataManager.sharedInstance.fetchEntities(entityName: "Code", predicate: teacherUsername, predicateName: "byTeacher") as? [Code] {
            self.codeArray = codeList
        }
    }
    
    @objc func logOutAction() {
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let navVC = UINavigationController(rootViewController: loginVC)
        self.view.window?.rootViewController = navVC
        self.view.window?.makeKeyAndVisible()
    }
    
    @objc func addAcessCodeaction(){
        let alert = UIAlertController(title: "Create Access Code", message: "Enter a valid acces Code Below", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Code "
        }
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            if textField?.text != "" {
                CoreDataManager.sharedInstance.saveCodeinDatabase((textField?.text!)!, byTeacher: self.teacherUsername)
                self.fillCodeArray()
                self.dataTableView.reloadData()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return codeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = codeArray[indexPath.row].accesCode
        cell.backgroundColor = .systemGroupedBackground
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pvc = self.storyboard!.instantiateViewController(withIdentifier: "TeacherSlotViewController") as! TeacherSlotViewController
        pvc.code = codeArray[indexPath.row].accesCode!
        pvc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(pvc, animated: true)

    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let seletedTask = self.codeArray[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            
            if let codeList = CoreDataManager.sharedInstance.fetchEntities(entityName: "Code", predicate: self.teacherUsername, predicateName: "byTeacher") as? [Code] {
                let accessCode = codeList.filter( { $0.accesCode == seletedTask.accesCode } ).first
                CoreDataManager.sharedInstance.managedContext?.delete(accessCode!)
                CoreDataManager.sharedInstance.saveContext()
            }
            self.showSuccessPopup(label: "Delete Success")
            self.fillCodeArray()
            self.dataTableView.reloadData()
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
}
