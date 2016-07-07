//
//  Book+CoreDataProperties.swift
//  TestFetchRequest
//
//  Created by 齋藤緒 on 2016/07/07.
//  Copyright © 2016年 TestOrganization. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Book {

    @NSManaged var name: String?
    @NSManaged var price: NSNumber?
    @NSManaged var publisher: String?

}
