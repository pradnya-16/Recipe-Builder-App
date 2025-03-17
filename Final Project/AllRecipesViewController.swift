//
//  AllRecipesViewController.swift
//  Final Project
//
//  Created by Pradnya Kadam on 3/16/25.
//


import UIKit
import CoreData

class AllRecipesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var allRecipes: [Recipe] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRecipes()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RecipeCell")
        fetchRecipes()
    }

    // MARK: - Fetch Recipes from Core Data
    func fetchRecipes() {
        let context = CoreDataManager.shared.context
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()

        do {
            allRecipes = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("❌ Error fetching recipes: \(error)")
        }
    }

    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRecipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
        let recipe = allRecipes[indexPath.row]
        cell.textLabel?.text = recipe.name
        return cell
    }

    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowRecipeDetailFromAll", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let recipe = allRecipes[indexPath.row]

        //  Swipe Right to Favorite
        let favoriteAction = UIContextualAction(style: .normal, title: "Favorite") { _, _, completionHandler in
            recipe.isFavorite = true
            CoreDataManager.shared.saveContext()
            self.showPopupMessage("\(recipe.name ?? "Recipe") added to favorites!")
            completionHandler(true)
        }
        favoriteAction.backgroundColor = .systemGreen

        //  Swipe Left to Unfavorite
        let unfavoriteAction = UIContextualAction(style: .destructive, title: "Unfavorite") { _, _, completionHandler in
            recipe.isFavorite = false
            CoreDataManager.shared.saveContext()
            self.showPopupMessage("\(recipe.name ?? "Recipe") removed from favorites!")
            completionHandler(true)
        }
        unfavoriteAction.backgroundColor = .systemRed

        return UISwipeActionsConfiguration(actions: [favoriteAction, unfavoriteAction])
    }


    // MARK: - Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowRecipeDetailFromAll",
           let detailVC = segue.destination as? RecipeDetailViewController,
           let indexPath = sender as? IndexPath {
            detailVC.recipe = allRecipes[indexPath.row]
        }
    }
}

