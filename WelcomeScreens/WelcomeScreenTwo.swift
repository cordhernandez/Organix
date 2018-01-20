//
//  WelcomeScreenTwo.swift
//  Organix
//
//  Created by Cordero Hernandez on 1/4/18.
//  Copyright © 2018 Cordero Hernandez. All rights reserved.
//

import Archeota
import Foundation
import UIKit

class WelcomeScreenTwo: UIViewController {
    
    var delegate: WelcomeScreenDelegate?
    
    override func viewDidLoad() {
        
        LOG.info("Welcome Screen two loaded")
        hideNavigationBar()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        LOG.info("User tapped on screen, moving to welcome screen 3.")
        goToWelcomeScreenThree()
    }
}

//MARK: - Segues
extension WelcomeScreenTwo {
    
    func goToWelcomeScreenThree() {
        
        performSegue(withIdentifier: SegueKeys.toWelcomeScreenThree, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? WelcomeScreenThree {
            destination.delegate = self.delegate
        }
    }
}
