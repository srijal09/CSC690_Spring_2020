//
//  StudentViewController.swift
//  StudentProfessorApp
//
//  Created by Mac-6 on 11/05/20.
//  Copyright © 2020 Mac-6. All rights reserved.
//

import UIKit

class StudentViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    //MARK:- Table
    var code = ""
    var studArray = [Appointment]()
     var alertMessage = ""
    
    //MARK:- Table
    @IBOutlet var studentTableView: UITableView!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var heightConstant: NSLayoutConstraint!
    
    //MARK:- Table
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Appointment List"
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:  #selector(addRequestaction))
        self.navigationItem.rightBarButtonItem  = barButtonItem
        
        let barButtonItem1 = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(logOutAction))
        self.navigationItem.leftBarButtonItem  = barButtonItem1
        
        studentTableView.rowHeight = UITableView.automaticDimension
        studentTableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        studArray = fillAppointmentArray()
        studentTableView.reloadData()
        
        if let reasonMessage = CoreDataManager.sharedInstance.getReasonFromDatabase().filter( { $0.id == code } ).first {
            self.messageButton.isHidden = false
            print(reasonMessage)
            self.heightConstant.constant = 30.0
            self.messageButton.setTitle("Show Alert", for: .normal)
        } else {
             self.messageButton.isHidden = true
        }
    }
    @IBAction func alertButtonPressed(_ sender: UIButton) {
        self.messageButton.isHidden = true
        self.heightConstant.constant = 0.0;
        if let reasonMessage = CoreDataManager.sharedInstance.getReasonFromDatabase().filter( { $0.id == code } ).first {
            showAlert(message: reasonMessage.reason ?? "")
            CoreDataManager.sharedInstance.managedContext?.delete(reasonMessage)
            CoreDataManager.sharedInstance.saveContext()
        }
    }
    
    //MARK:- Table
    @objc func logOutAction() {
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let navVC = UINavigationController(rootViewController: loginVC)
        self.view.window?.rootViewController = navVC
        self.view.window?.makeKeyAndVisible()
    }
    
    @objc func addRequestaction(){
        let pvc = storyboard?.instantiateViewController(withIdentifier: "RequestViewController") as! RequestViewController
        pvc.id = code
        pvc.modalPresentationStyle = .fullScreen
        self.present(pvc, animated: true, completion: nil)
    }
    
    func fillAppointmentArray() -> [Appointment] {
        if let studList = CoreDataManager.sharedInstance.fetchEntities(entityName: "Appointment", predicate: code, predicateName: "id") as? [Appointment] {
            return studList
        }
        return []
    }
    
    //MARK:- Table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:StudentTableViewCell = self.studentTableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell") as! StudentTableViewCell
        cell.nameStud.text = studArray[indexPath.row].name
        
        
        let dateTimeStr = "\(studArray[indexPath.row].dateSlot ?? "") at \(studArray[indexPath.row].time ?? "")"
        cell.timeLabel.text = dateTimeStr
        
        if studArray[indexPath.row].appointmentStatus == "True" {
            cell.backgroundColor = .systemGroupedBackground
            cell.statusImg.image = UIImage(named: "CheckBoxImage")
        } else {
            cell.backgroundColor = .orange
            //  cell.statusImg.image = UIImage(named: "UncheckBox")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let seletedTask = self.studArray[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            if let appointmentList = CoreDataManager.sharedInstance.fetchEntities(entityName: "Appointment", predicate: nil, predicateName: "id") as? [Appointment] {
                let approvedAppointment = appointmentList.filter( { $0.id == seletedTask.id } ).first
                CoreDataManager.sharedInstance.managedContext?.delete(approvedAppointment!)
                CoreDataManager.sharedInstance.saveContext()
            }
            self.showSuccessPopup(label: "Delete Success")
            self.studArray = self.fillAppointmentArray()
            self.studentTableView.reloadData()
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
}
