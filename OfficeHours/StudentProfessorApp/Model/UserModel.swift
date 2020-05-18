//
//  UserModel.swift
//  StudentProfessorApp
//
//  Created  on 5/11/20.
//  Copyright © 2020 Mac-6. All rights reserved.
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {

}


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var username: String?

}
