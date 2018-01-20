//
//  WelcomeScreenThree.swift
//  Organix
//
//  Created by Cordero Hernandez on 1/11/18.
//  Copyright © 2018 Cordero Hernandez. All rights reserved.
//

import Archeota
import Foundation
import UIKit

class WelcomeScreenThree: UIViewController {
    
    @IBOutlet weak var vegetarianButton: UIButton!
    @IBOutlet weak var veganButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    fileprivate var eitherOneSelected: Bool {
        
        return UserPreferences.instance.showVeganBusinesses ||
               UserPreferences.instance.showVegetarianBusinesses
    }
    
    var delegate: WelcomeScreenDelegate?
    
    override func viewDidLoad() {
        
        updateButtons()
    }
    
    @IBAction func vegetarianButtonTapped(sender: Any?) {
        
        UserPreferences.instance.showVegetarianBusinesses = !UserPreferences.instance.showVegetarianBusinesses
        updateButtons()
    }
    
    @IBAction func veganButtonTapped(sender: Any?) {
        
        UserPreferences.instance.showVeganBusinesses = !UserPreferences.instance.showVeganBusinesses
        updateButtons()
    }
    
    @IBAction func nextButtonTapped(sender: Any?) {
        
        if eitherOneSelected {
            
            goToWelcomeScreenFour()
        }
    }
}

//MARK: - Segues
extension WelcomeScreenThree {
    
    func goToWelcomeScreenFour() {
        
        performSegue(withIdentifier: SegueKeys.toWelcomeScreenFour, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? WelcomeScreenFour {
            destination.delegate = self.delegate
        }
    }
}

//MARK: UI Setup
extension WelcomeScreenThree {
    
    private var neitherSelected: Bool {
        
        return !UserPreferences.instance.showVeganBusinesses &&
            !UserPreferences.instance.showVegetarianBusinesses
    }
    
    func updateButtons() {
        
        if UserPreferences.instance.showVeganBusinesses {
            selectVeganButton()
        }
        else {
            deselectVeganButton()
        }
        
        if UserPreferences.instance.showVegetarianBusinesses {
            selectVegetarianButton()
        }
        else {
            deselectVegetarianButton()
        }
        
        if neitherSelected {
            disableNextButton()
        }
        else {
            enableNextButton()
        }
    }
    
    func deselectVeganButton() {
        
        let animations = {
            
            self.veganButton.backgroundColor = UIColor.clear
        }
        
        animate(withView: self.veganButton, animations: animations)
    }
    
    func selectVeganButton() {
        
        let animations = {
            
            self.veganButton.backgroundColor = UIColor(red: 77, green: 150, blue: 156, alpha: 1.0)
        }
        
        animate(withView: self.veganButton, animations: animations)
    }
    
    func selectVegetarianButton() {
        
        let animations = {
            
            self.vegetarianButton.backgroundColor = UIColor(red: 77, green: 150, blue: 156, alpha: 1.0)
        }
        
        animate(withView: self.vegetarianButton, animations: animations)
    }
    
    func deselectVegetarianButton() {
        
        let animations = {
            
            self.vegetarianButton.backgroundColor = UIColor.clear
        }
        
        animate(withView: self.vegetarianButton, animations: animations)
    }
    
    func enableNextButton() {
        
        self.nextButton.isEnabled = true
        self.nextButton.alpha = 1.0
    }
    
    func disableNextButton() {
        
        self.nextButton.isEnabled = false
        self.nextButton.alpha = 0.0
    }
    
    func animate(withView view: UIView, animations: @escaping () -> ()) {
        
        UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve, animations: animations, completion: nil)
    }
}
