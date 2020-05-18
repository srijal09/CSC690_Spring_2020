//
//  AppointmentModel.swift
//  StudentProfessorApp
//
//  Created  on 5/11/20.
//  Copyright © 2020 Mac-6. All rights reserved.
//

import Foundation
import CoreData

@objc(SlotAppointment)
public class SlotAppointment: NSManagedObject {

}

extension SlotAppointment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SlotAppointment> {
        return NSFetchRequest<SlotAppointment>(entityName: "SlotAppointment")
    }

    @NSManaged public var date: String?
    @NSManaged public var timeSlot: String?

}
