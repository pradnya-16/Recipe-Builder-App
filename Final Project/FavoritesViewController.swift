//
//  FavoritesViewController.swift
//  Final Project
//
//  Created by Pradnya Kadam on 3/12/25.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var favoriteRecipes: [Recipe] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavorites()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchFavorites()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FavoriteCell")

    }
    
    func fetchFavorites() {
        let context = CoreDataManager.shared.context
        let request = Recipe.fetchRequest() as NSFetchRequest<Recipe>
        request.predicate = NSPredicate(format: "isFavorite == true") //  Filter only favorite recipes

        do {
            favoriteRecipes = try context.fetch(request)

            // 🛠 Debugging: Print all fetched favorite recipes
            print("\n--- Favorite Recipes in Core Data ---")
            if favoriteRecipes.isEmpty {
                print(" No favorite recipes found.")
            } else {
                for recipe in favoriteRecipes {
                    print("Recipe: \(recipe.name ?? "Unknown") | isFavorite: \(recipe.isFavorite)")
                }
            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print(" Error fetching favorite recipes: \(error)")
        }
    }

    
    // MARK: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath)
        let recipe = favoriteRecipes[indexPath.row]
        
        cell.textLabel?.text = recipe.name

        print("Displaying Favorite: \(recipe.name ?? "Unknown Recipe")") // Debugging

        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let recipe = favoriteRecipes[indexPath.row]

        //  Swipe Left to Remove from Favorites
        let removeAction = UIContextualAction(style: .destructive, title: "Unfavorite") { _, _, completionHandler in
            recipe.isFavorite = false
            CoreDataManager.shared.saveContext()
            self.fetchFavorites() // Reloads list after unfavorite
            self.showPopupMessage("\(recipe.name ?? "Recipe") removed from favorites!")
            completionHandler(true)
        }
        removeAction.backgroundColor = .systemRed

        return UISwipeActionsConfiguration(actions: [removeAction])
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    @IBAction func unfavoriteTapped(_ sender: UIButton) {
        // If you have a selected row or some logic to pick a recipe
        // recipe.isFavorite = false
        // CoreDataManager.shared.saveContext()
        // fetchFavorites()
    }
    
    @IBAction func backToHomeTapped(_ sender: UIButton) {
        tabBarController?.selectedIndex = 0
    }

}

