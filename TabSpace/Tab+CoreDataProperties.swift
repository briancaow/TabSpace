//
//  Tab+CoreDataProperties.swift
//  TabSpace
//
//  Created by Brian Cao on 3/1/23.
//
//

import Foundation
import CoreData


extension Tab {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tab> {
        return NSFetchRequest<Tab>(entityName: "Tab")
    }

    @NSManaged public var urlPath: String?
    @NSManaged public var xPosition: Double
    @NSManaged public var yPosition: Double
    @NSManaged public var width: Double
    @NSManaged public var height: Double
    @NSManaged public var name: String?
    @NSManaged public var space: Space?

}

extension Tab : Identifiable {

}
