//
//  AppointmentViewController.swift
//  StudentProfessorApp
//
//  Created by Mac-6 on 11/05/20.
//  Copyright © 2020 Mac-6. All rights reserved.
//

import UIKit

class AppointmentViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var aapointmentTableView: UITableView!
    public var appArray: [Appointment] = []
    var accessCode = ""
    var name = ""
    
    @IBOutlet var statusImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "List of Student Request"
        
        self.fillAppointmentArray()
        aapointmentTableView.rowHeight = UITableView.automaticDimension
        aapointmentTableView.estimatedRowHeight = UITableView.automaticDimension
        aapointmentTableView.reloadData()
    }
    
    func fillAppointmentArray() {
        if let codeList = CoreDataManager.sharedInstance.fetchEntities(entityName: "Appointment", predicate: accessCode, predicateName: "id") as? [Appointment] {
            self.appArray = codeList.filter( { $0.appointmentStatus != "True" } )
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:AppointmentTableViewCell = self.aapointmentTableView.dequeueReusableCell(withIdentifier: "AppointmentTableViewCell") as! AppointmentTableViewCell
        cell.studName.text = appArray[indexPath.row].name
        cell.timeLabel.text = appArray[indexPath.row].time
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let seletedTask = self.appArray[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            if let appointmentList = CoreDataManager.sharedInstance.fetchEntities(entityName: "Appointment", predicate: nil, predicateName: "id") as? [Appointment] {
                let approvedAppointment = appointmentList.filter( { $0.id == seletedTask.id } ).first
                CoreDataManager.sharedInstance.managedContext?.delete(approvedAppointment!)
                CoreDataManager.sharedInstance.saveContext()
            }
            self.showSuccessPopup(label: "Delete Success")
            self.fillAppointmentArray()
            self.aapointmentTableView.reloadData()
        }
        
        deleteAction.backgroundColor = .red
        self.aapointmentTableView.reloadData()
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let alert = UIAlertController(title: "Appointment Request", message: "Please Accept or Reject", preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: "Accept", style: .default) { (_) in
            CoreDataManager.sharedInstance.updateEntity(entityName: "Appointment", predicate: self.appArray[indexPath.row].name, predicateName: "name", metaInfo: ["appointmentStatus" : "True"])
            CoreDataManager.sharedInstance.saveContext()
            self.fillAppointmentArray()
            self.aapointmentTableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Reject", style: .cancel) { (_) in
            
            let reasonAlert = UIAlertController(title: "Reason", message: "Please Give reject Reason", preferredStyle: .alert)
            reasonAlert.addTextField { (textField) in
                textField.placeholder = "Enter Reason"
            }
            let sendAction = UIAlertAction(title: "Send", style: .default) { (_) in
                if let textField = reasonAlert.textFields?[0] {
                    CoreDataManager.sharedInstance.saveReasonInDatabase(self.appArray[indexPath.row].id ?? "", reason: textField.text ?? "")
                    
                    if let appointmentList = CoreDataManager.sharedInstance.fetchEntities(entityName: "Appointment", predicate: nil, predicateName: "id") as? [Appointment] {
                        let approvedAppointment = appointmentList.filter( { $0.id == self.appArray[indexPath.row].id } ).first
                        CoreDataManager.sharedInstance.managedContext?.delete(approvedAppointment!)
                        CoreDataManager.sharedInstance.saveContext()
                        self.fillAppointmentArray()
                        self.aapointmentTableView.reloadData()
                    }
                }
            }
            reasonAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            reasonAlert.addAction(sendAction)
            self.present(reasonAlert, animated: true, completion: nil)
        }
        alert.addAction(acceptAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
       
    }
}
/*
 if appArray[indexPath.row].appointmentStatus == "True" {
 CoreDataManager.sharedInstance.updateEntity(entityName: "Appointment", predicate: appArray[indexPath.row].name, predicateName: "name", metaInfo: ["appointmentStatus" : "False"])
 cell.statusImage.image = UIImage(named: "UncheckBox")
 CoreDataManager.sharedInstance.saveContext()
 } else {
 CoreDataManager.sharedInstance.updateEntity(entityName: "Appointment", predicate: appArray[indexPath.row].name, predicateName: "name", metaInfo: ["appointmentStatus" : "True"])
 cell.statusImage.image = UIImage(named: "CheckBoxImage")
 CoreDataManager.sharedInstance.saveContext()
 }
 */
