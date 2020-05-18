//
//  AppointmentModel.swift
//  StudentProfessorApp
//
//  Created on 5/11/20.
//  Copyright © 2020 Mac-6. All rights reserved.
//

import Foundation
import CoreData

@objc(Appointment)
public class Appointment: NSManagedObject {

}

extension Appointment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Appointment> {
        return NSFetchRequest<Appointment>(entityName: "Appointment")
    }

    @NSManaged public var appointmentStatus: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var time: String?
    @NSManaged public var dateSlot: String?
}
