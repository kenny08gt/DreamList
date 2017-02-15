//
//  ItemType+CoreDataProperties.swift
//  DreamLister
//
//  Created by LionMane Software on 2/15/17.
//  Copyright © 2017 LionMane Software. All rights reserved.
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType");
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
