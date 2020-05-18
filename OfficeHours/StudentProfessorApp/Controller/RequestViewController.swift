//
//  RequestViewController.swift
//  StudentProfessorApp
//
//  Created by Mac-6 on 12/05/20.
//  Copyright © 2020 Mac-6. All rights reserved.
//

import UIKit

class RequestViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    //MARK:-
    @IBOutlet var nameStudent: CustomTextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var timePickerView: UIPickerView!
    @IBOutlet var timePickerHeightConstraint: NSLayoutConstraint!
    
    
    //MARK:-
    public var dateSelected = ""
    public var id = ""
    public var timeSelected = ""
    var slotList = [String]()
    var appointmentPickerIsSelected = false
    public var slotListArray: [Appointment] = []
    
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        nameStudent.placeholderText = "Enter Name"
        datePicker.backgroundColor = .white
        timePickerView.backgroundColor = .white
        slotList = ["10:30 am - 11:00 am", "11:00 am - 11:30 am", "11:30 am - 12:00 pm", "12:00 pm - 12:30 pm", "1:00 pm - 1:30 pm", "1:30 pm - 2:00 pm", "2:00 pm - 2:30 pm", "2:30 pm - 3:00 pm", "3:00 pm - 3:30 pm", "3:30 pm - 4:00 pm", "4:00 pm - 4:30 pm", "4:30 pm - 5:00 pm", "5:00 pm - 5:30 pm", "5:30 pm - 6:00 pm"]
        slotListArray = fillslotListArray()
        
    }
    
    func fillslotListArray() -> [Appointment] {
        if let slotList = CoreDataManager.sharedInstance.fetchEntities(entityName: "Appointment", predicate: self.dateSelected, predicateName: "dateSlot") as? [Appointment] {
            return slotList
        }
        return []
    }
    
    //MARK:-
    @IBAction func datePicherAction(_ sender: UIDatePicker) {
        setDate(sender)
        slotListArray = fillslotListArray()
    }
    
    @IBAction func didSelectRequestApp(_ sender: UIButton) {
        setDate(datePicker)
        
        if slotListArray.contains(where: { $0.time == timeSelected }) {
            self.showAlert(message: "Slot is Already Booked")
        } else {
            if nameStudent.text != ""  {
                CoreDataManager.sharedInstance.saveAppointmentInDatabase(nameStudent.text!, id: id, status: "False", time: timeSelected, date: dateSelected)
                self.showSuccessPopup(label: "Added")
                self.dismiss(animated: true, completion: nil)
            } else {
                showAlert(message: "Both field are required.")
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didSlectSlotAction(_ sender: UIButton) {
        
        if appointmentPickerIsSelected == true {
            self.timePickerHeightConstraint.constant = 100
            self.timePickerView.reloadAllComponents()
            self.appointmentPickerIsSelected = false
        }
        else if appointmentPickerIsSelected == false {
            self.timePickerHeightConstraint.constant = 0
            self.appointmentPickerIsSelected = true
        }
    }
    
    //MARK:-
    func setDate(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd yyyy"
        self.dateSelected = dateFormatter.string(from: sender.date)
    }
    
    // MARK: - UIPickerView Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return slotList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return slotList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        timeLabel.text = slotList[row]
        timeSelected = slotList[row]
    }
}
