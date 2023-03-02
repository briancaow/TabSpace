//
//  Tab+CoreDataProperties.swift
//  TabSpace
//
//  Created by Brian Cao on 3/2/23.
//
//

import Foundation
import CoreData


extension Tab {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tab> {
        return NSFetchRequest<Tab>(entityName: "Tab")
    }

    @NSManaged public var urlPath: String?
    @NSManaged public var xPosition: Int16
    @NSManaged public var yPosition: Int16
    @NSManaged public var width: Int16
    @NSManaged public var height: Int16
    @NSManaged public var name: String?
    @NSManaged public var space: Space?

}

extension Tab : Identifiable {

}
