//
//  Space+CoreDataProperties.swift
//  TabSpace
//
//  Created by Brian Cao on 3/1/23.
//
//

import Foundation
import CoreData


extension Space {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Space> {
        return NSFetchRequest<Space>(entityName: "Space")
    }

    @NSManaged public var name: String?
    @NSManaged public var tabs: NSSet?

}

// MARK: Generated accessors for tabs
extension Space {

    @objc(addTabsObject:)
    @NSManaged public func addToTabs(_ value: Tab)

    @objc(removeTabsObject:)
    @NSManaged public func removeFromTabs(_ value: Tab)

    @objc(addTabs:)
    @NSManaged public func addToTabs(_ values: NSSet)

    @objc(removeTabs:)
    @NSManaged public func removeFromTabs(_ values: NSSet)

}

extension Space : Identifiable {

}
