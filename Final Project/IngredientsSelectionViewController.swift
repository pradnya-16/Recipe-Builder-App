//
//  IngredientsSelectionViewController.swift
//  Final Project
//
//  Created by Pradnya Kadam on 3/12/25.
//

import UIKit

class IngredientsSelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var allIngredients: [Ingredient] = []
    var selectedIngredients: Set<Ingredient> = [] // or store just names
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "IngredientCell")
        fetchIngredients()
        tableView.reloadData()
    }
    
    func fetchIngredients() {
        let context = CoreDataManager.shared.context
        let request = Ingredient.fetchRequest()
        do {
            allIngredients = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Error fetching ingredients: \(error)")
        }
    }
    
    // MARK: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Reuse Identifier set in storyboard
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        let ingredient = allIngredients[indexPath.row]
        cell.textLabel?.text = ingredient.name
        
        // If you want checkboxes:
        cell.accessoryType = selectedIngredients.contains(ingredient) ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ingredient = allIngredients[indexPath.row]
        if selectedIngredients.contains(ingredient) {
            selectedIngredients.remove(ingredient)
        } else {
            selectedIngredients.insert(ingredient)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let ingredient = allIngredients[indexPath.row]

        //  Swipe Left to Delete Ingredient
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completionHandler in
            let context = CoreDataManager.shared.context
            context.delete(ingredient)
            CoreDataManager.shared.saveContext()
            self.fetchIngredients() // Reloads UI after deletion
            self.showPopupMessage("\(ingredient.name ?? "Ingredient") deleted!")
            completionHandler(true)
        }
        deleteAction.backgroundColor = .systemRed

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }


    
    @IBAction func seeAllRecipe(_ sender: UIButton) {
        // Perform segue to Page 2
        performSegue(withIdentifier: "SeeAllRecipe", sender: nil)
    }
    
    @IBAction func searchRecipeTapped(_ sender: UIButton) {
        // Perform segue to Page 3
        tabBarController?.selectedIndex = 5
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowRecipeMatchSegue" {
            if let matchVC = segue.destination as? RecipeMatchViewController {
                // pass selectedIngredients
                matchVC.selectedIngredients = Array(selectedIngredients)
            }
        }
    }
}

