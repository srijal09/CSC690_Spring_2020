//
//  CodeModel.swift
//  StudentProfessorApp
//
//  Created  on 5/11/20.
//  Copyright © 2020 Mac-6. All rights reserved.
//

import Foundation
import CoreData

@objc(Code)
public class Code: NSManagedObject {

}
extension Code {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Code> {
        return NSFetchRequest<Code>(entityName: "Code")
    }

    @NSManaged public var accesCode: String?
    @NSManaged public var byTeacher: String?

}
