//
//  RecipeMatchViewController.swift
//  Final Project
//
//  Created by Pradnya Kadam on 3/12/25.
//

import UIKit
import CoreData

class RecipeMatchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedIngredients: [Ingredient] = []
    var matchingRecipes: [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RecipeCell")
            
        fetchMatchingRecipes()
    }
    
    // MARK: - Fetch & Filter Recipes
    func fetchMatchingRecipes() {
        let context = CoreDataManager.shared.context
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()

        do {
            let allRecipes = try context.fetch(request)

            print("\n--- All Recipes in Core Data ---")
            for recipe in allRecipes {
                let ingredientNames = (recipe.ingredient as? Set<Ingredient>)?.map { $0.name ?? "Unknown" } ?? []
                print("Recipe: \(recipe.name ?? "Unknown")")
                print("  Ingredients: \(ingredientNames)")
            }

            print("\n--- Selected Ingredients ---")
            let selectedIngredientNames = selectedIngredients.map { $0.name ?? "Unknown" }
            print(selectedIngredientNames)

            matchingRecipes = allRecipes.filter { recipe in
                guard let recipeIngredients = recipe.ingredient as? Set<Ingredient> else { return false }

                // ✅ Fix: Ensure all selected ingredients exist in the recipe
                let recipeIngredientNames = recipeIngredients.map { $0.name ?? "" }
                let allIngredientsMatch = selectedIngredientNames.allSatisfy { recipeIngredientNames.contains($0) }

                if allIngredientsMatch {
                    print("\n Match Found: \(recipe.name ?? "Unknown")")
                    print("  Matching Ingredients: \(recipeIngredientNames)")
                }

                return allIngredientsMatch
            }

            print("\n--- Matched Recipes for Selected Ingredients ---")
            print(matchingRecipes.map { $0.name ?? "Unknown" })

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

        } catch {
            print("Error fetching recipes: \(error)")
        }
    }




    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)

        let recipe = matchingRecipes[indexPath.row]
        cell.textLabel?.text = recipe.name ?? "Unknown Recipe"  

        print("Displaying in Table View: \(recipe.name ?? "Unknown Recipe")")
        
        return cell
    }

    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        // Perform segue to detail page
        performSegue(withIdentifier: "ShowRecipeDetailSegue", sender: indexPath)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowRecipeDetailSegue",
           let detailVC = segue.destination as? RecipeDetailViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            detailVC.recipe = matchingRecipes[indexPath.row]
        }
    }

    
    // MARK: - IBActions
    @IBAction func addCustomRecipeTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowAddCustomRecipeSegue", sender: nil)
    }
    
    @IBAction func seeFavoritesTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowFavoritesSegue", sender: nil)
    }
}
