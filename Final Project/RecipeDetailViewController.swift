//
//  RecipeDetailViewController.swift
//  Final Project
//
//  Created by Pradnya Kadam on 3/12/25.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    var recipe: Recipe? // set from Page 3
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var instructionsTextView: UITextView!
    @IBOutlet weak var cookingTimeLabel: UILabel!
    
    // Timer UI
    @IBOutlet weak var timerLabel: UILabel!
    var timer: Timer?
    var elapsedSeconds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        guard let recipe = recipe else { return }
        recipeNameLabel.text = recipe.name
        cookingTimeLabel.text = "\(recipe.cookingTime) min"
        instructionsTextView.text = recipe.instructions
        
        if let imageName = recipe.imageName, !imageName.isEmpty {
            recipeImageView.image = UIImage(named: imageName)
        } else {
            recipeImageView.image = UIImage(systemName: "photo") // Placeholder
        }
    }
    
    @IBAction func addToFavoritesTapped(_ sender: UIButton) {
        guard let recipe = recipe else { return }
        recipe.isFavorite = true
        CoreDataManager.shared.saveContext()
        
        showPopupMessage("Recipe added to favorites!")
    }

    
    // MARK: Timer
    @IBAction func startTimerTapped(_ sender: UIButton) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.elapsedSeconds += 1
            self.updateTimerLabel()
        }
    }
    
    @IBAction func pauseTimerTapped(_ sender: UIButton) {
        timer?.invalidate()
        timer = nil
    }
    
    @IBAction func stopTimerTapped(_ sender: UIButton) {
        timer?.invalidate()
        timer = nil
        elapsedSeconds = 0
        updateTimerLabel()
    }
    
    func updateTimerLabel() {
        let minutes = elapsedSeconds / 60
        let seconds = elapsedSeconds % 60
        timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    
    @IBAction func backToHomeTapped(_ sender: UIButton) {
        tabBarController?.selectedIndex = 0
    }
}

