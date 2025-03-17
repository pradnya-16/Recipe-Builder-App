//
//  AddCustomRecipeViewController.swift
//  Final Project
//
//  Created by Pradnya Kadam on 3/12/25.
//

import UIKit

class AddCustomRecipeViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cookingTimeTextField: UITextField!
    @IBOutlet weak var instructionsTextView: UITextView!
    @IBOutlet weak var ingredientsTextField: UITextField!
    
    @IBAction func saveRecipeTapped(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty else {
            showPopupMessage("Please enter a recipe name!")
            return
        }

        let context = CoreDataManager.shared.context

        let newRecipe = Recipe(context: context)
        newRecipe.name = name
        newRecipe.instructions = instructionsTextView.text
        newRecipe.cookingTime = Double(cookingTimeTextField.text ?? "0") ?? 0
        newRecipe.isFavorite = false

        if let ingredientsText = ingredientsTextField.text, !ingredientsText.isEmpty {
            let ingredientNames = ingredientsText.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }

            for ingredientName in ingredientNames {
                if !ingredientName.isEmpty {
                    let ingredient = CoreDataManager.shared.getOrCreateIngredient(named: ingredientName)
                    newRecipe.addToIngredient(ingredient)
                }
            }
        }

        CoreDataManager.shared.saveContext()

        showPopupMessage("Recipe added successfully!")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.tabBarController?.selectedIndex = 0
        }
    }



    
    @IBAction func addToFavoritesTapped(_ sender: UIButton) {
        showPopupMessage("Recipe added to favorites!")
    }
    
    @IBAction func backToHomeTapped(_ sender: UIButton) {
        tabBarController?.selectedIndex = 0 
    }


}

