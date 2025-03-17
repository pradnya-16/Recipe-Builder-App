//
//  AddIngredientViewController.swift
//  Final Project
//
//  Created by Pradnya Kadam on 3/12/25.
//

import UIKit

class AddIngredientViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var allIngredients: [Ingredient] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        fetchIngredients()
    }
    
    func fetchIngredients() {
        let context = CoreDataManager.shared.context
        let request = Ingredient.fetchRequest()
        do {
            allIngredients = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Error: \(error)")
        }
    }
    
    
    
    @IBAction func saveIngredientTapped(_ sender: UIButton) {
        guard let name = ingredientTextField.text, !name.isEmpty else { return }
        
        let context = CoreDataManager.shared.context
        let newIngredient = Ingredient(context: context)
        newIngredient.name = name
        
        CoreDataManager.shared.saveContext()
        ingredientTextField.text = ""
        
        // Reload table
        fetchIngredients()
        showPopupMessage("Ingredient added!")

    }
    
    // MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllIngredientsCell", for: indexPath)
        cell.textLabel?.text = allIngredients[indexPath.row].name
        return cell
    }
    
    @IBAction func scanButtonTapped(_ sender: UIButton) {
        // Implementation later
    }
    
    @IBAction func backToHomeTapped(_ sender: UIButton) {
        tabBarController?.selectedIndex = 0
    }
}

