//
//  Recipe+CoreDataProperties.swift
//  Final Project
//
//  Created by Pradnya Kadam on 3/12/25.
//
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var name: String?
    @NSManaged public var instructions: String?
    @NSManaged public var cookingTime: Double
    @NSManaged public var imageName: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var ingredient: NSSet?

}

extension Recipe {

    @objc(addIngredientObject:)
    @NSManaged public func addToIngredient(_ value: Ingredient)

    @objc(removeIngredientObject:)
    @NSManaged public func removeFromIngredient(_ value: Ingredient)

    @objc(addIngredient:)
    @NSManaged public func addToIngredient(_ values: NSSet)

    @objc(removeIngredient:)
    @NSManaged public func removeFromIngredient(_ values: NSSet)

}

extension Recipe : Identifiable {

}
