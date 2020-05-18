//
//  Reason.swift
//  StudentProfessorApp
//
//  Created  on 5/13/20.
//  Copyright © 2020 Mac-6. All rights reserved.
//

import Foundation
import CoreData

@objc(Reason)
public class Reason: NSManagedObject {

}

extension Reason {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reason> {
        return NSFetchRequest<Reason>(entityName: "Reason")
    }

    @NSManaged public var id: String?
    @NSManaged public var reason: String?

}
