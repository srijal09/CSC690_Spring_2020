//
//  TeacherSlotViewController.swift
//  StudentProfessorApp
//
//  Created by Mac-6 on 12/05/20.
//  Copyright © 2020 Mac-6. All rights reserved.
//

import UIKit

class TeacherSlotViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var code = ""
    var approvedAppointmentList = [Appointment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getApprovedAppointmentList()
    }
    
    @IBAction func openHoursdidSlect(_ sender: Any) {
        let pvc = self.storyboard!.instantiateViewController(withIdentifier: "SetSlotViewController") as! SetSlotViewController
        pvc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(pvc, animated: true)
    }
    
    @IBAction func approveOrCancelDidSelect(_ sender: UIButton) {
        let pvc = self.storyboard!.instantiateViewController(withIdentifier: "AppointmentViewController") as! AppointmentViewController
        pvc.accessCode = code
        pvc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(pvc, animated: true)
    }
    
    func getApprovedAppointmentList() {
        if let appointmentList = CoreDataManager.sharedInstance.fetchEntities(entityName: "Appointment", predicate: nil, predicateName: "id") as? [Appointment] {
            approvedAppointmentList = appointmentList.filter( { $0.appointmentStatus == "True" } )
        }
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return approvedAppointmentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = approvedAppointmentList[indexPath.row].name
        cell?.textLabel?.textColor = .black
        cell?.backgroundColor = .white
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let seletedTask = self.approvedAppointmentList[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            if let appointmentList = CoreDataManager.sharedInstance.fetchEntities(entityName: "Appointment", predicate: nil, predicateName: "id") as? [Appointment] {
                let approvedAppointment = appointmentList.filter( { $0.id == seletedTask.id } ).first
                CoreDataManager.sharedInstance.managedContext?.delete(approvedAppointment!)
                CoreDataManager.sharedInstance.saveContext()
            }
            self.showSuccessPopup(label: "Delete Success")
            self.getApprovedAppointmentList()
            self.tableView.reloadData()
        }
        
        deleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50.0
    }
    
    
}
