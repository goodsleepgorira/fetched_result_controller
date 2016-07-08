//
//  Book+CoreDataProperties.swift
//

import Foundation
import CoreData

extension Book {

    @NSManaged var name: String?
    @NSManaged var price: NSNumber?
    @NSManaged var publisher: String?
    @NSManaged var releaseDate: NSDate?
    @NSManaged var approvalRate: NSNumber?

}
