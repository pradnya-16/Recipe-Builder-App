//
//  CoreDataManager.swift
//  Final Project
//
//  Created by Pradnya Kadam on 3/11/25.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()

    lazy var persistentContainer: NSPersistentContainer = {
        // Match the name of your .xcdatamodeld file (e.g., "RecipeFinder")
        let container = NSPersistentContainer(name: "RecipeFinder")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error: \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Error saving context: \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func preloadDataIfNeeded() {
        let context = self.context
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        let count = (try? context.count(for: request)) ?? 0

        if count == 0 {
            let ingredientSalt = getOrCreateIngredient(named: "Salt")
            let ingredientEggs = getOrCreateIngredient(named: "Eggs")

            // ✅ Fix: Make sure ingredients are added
            let recipe1 = Recipe(context: context)
            recipe1.name = "Basic Pasta"
            recipe1.cookingTime = 15
            recipe1.imageName = "pasta"
            recipe1.instructions = """
            Boil a pot of water and add a pinch of salt.
            Add pasta and cook according to package instructions (8-12 minutes).
            Drain the pasta and save a small amount of pasta water.
            In a pan, heat olive oil or butter and add garlic (optional).
            Toss the pasta in the pan, add salt, pepper, and desired sauce (tomato, pesto, or alfredo).
            Mix well, adding pasta water if needed for consistency.
            Garnish with parmesan cheese and fresh basil.
            Serve hot and enjoy!
            """
            recipe1.isFavorite = true

            let ingredientPasta = getOrCreateIngredient(named: "Pasta")
            recipe1.addToIngredient(ingredientPasta)
            recipe1.addToIngredient(ingredientSalt)

            let recipe2 = Recipe(context: context)
            recipe2.name = "Scrambled Eggs"
            recipe2.cookingTime = 10
            recipe2.imageName = "eggs"
            recipe2.instructions = """
            Crack eggs into a bowl and whisk with a pinch of salt and pepper.
            Heat a non-stick pan on low-medium heat and melt some butter.
            Pour in the eggs and let them sit for a few seconds.
            Stir gently with a spatula, moving eggs from the edges to the center.
            Continue stirring until eggs are soft and slightly runny.
            Remove from heat (eggs will continue to cook from residual heat).
            Optional: Add cheese, herbs, or cooked veggies.
            Serve warm with toast or as a side dish.
            """
            recipe2.isFavorite = true

            recipe2.addToIngredient(ingredientEggs)
            recipe2.addToIngredient(ingredientSalt)

            // ✅ Print Recipes to Verify
            print("\n--- Preloaded Recipes ---")
            let recipes = [recipe1, recipe2]
            for recipe in recipes {
                let ingredientNames = (recipe.ingredient as? Set<Ingredient>)?.map { $0.name ?? "Unknown" } ?? []
                print("Recipe: \(recipe.name ?? "Unknown")")
                print("  Ingredients: \(ingredientNames)")
            }

            self.saveContext()
        }
    }

    
    func getOrCreateIngredient(named name: String) -> Ingredient {
        let request: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)

        if let existingIngredient = (try? context.fetch(request))?.first {
            return existingIngredient
        }

        let newIngredient = Ingredient(context: context)
        newIngredient.name = name
        return newIngredient
    }



}
