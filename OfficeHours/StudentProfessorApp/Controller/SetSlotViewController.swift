//
//  SetSlotViewController.swift
//  StudentProfessorApp
//
//  Created by Mac-6 on 12/05/20.
//  Copyright © 2020 Mac-6. All rights reserved.
//

import UIKit

class SetSlotViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet var slotTableView: UITableView!
    var list = [String]()
    var date = ""
    var time = "" 
    
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var timePicker: UIPickerView!
    
    var appointmentPickerIsSelected = true
    
    @IBOutlet var timePickerHeightConstrant: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        list = ["10 am - 12 pm", "12pm - 2pm", "2pm - 4pm", "4pm - 6pm"]
        timePicker.backgroundColor = .white
        datePicker.backgroundColor = .white

        self.title = "List of Access Code"
//          let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:  #selector(addSlotaction))
//          self.navigationItem.rightBarButtonItem  = barButtonItem

        // Do any additional setup after loading the view.
    }
    

    
    func setDate(_ sender: UIDatePicker) {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "MMMM dd, yyyy 'at' hh:mm:ss"
           self.date = dateFormatter.string(from: sender.date)
       }
    
    @IBAction func didSelectSetTime(_ sender: UIButton) {
        if appointmentPickerIsSelected == true {
            self.timePickerHeightConstrant.constant = 100
            self.timePicker.reloadAllComponents()
            self.appointmentPickerIsSelected = false
        }
        else if appointmentPickerIsSelected == false {
            self.timePickerHeightConstrant.constant = 0
            self.appointmentPickerIsSelected = true
        }
    }
    
    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        self.setDate(sender)
    }

    @IBAction func saveSlot(_ sender: UIButton) {
        
        CoreDataManager.sharedInstance.saveSlotAppointmenteinDatabase(date, time: time)
            self.showAlert(message: "Sucessefully Saved Slot")
        
    }
    
  // MARK: - UIPickerView Methods
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return list.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return list[row]
        }
       
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            timeLabel.text = list[row]
            time = list[row]
        }
    

    
}
