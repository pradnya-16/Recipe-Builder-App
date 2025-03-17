//
//  Ingredient+CoreDataProperties.swift
//  Final Project
//
//  Created by Pradnya Kadam on 3/12/25.
//
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }

    @NSManaged public var name: String?
    @NSManaged public var quantity: Float

}

extension Ingredient : Identifiable {

}
