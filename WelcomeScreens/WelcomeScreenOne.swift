//
//  WelcomeScreenOne.swift
//  Organix
//
//  Created by Cordero Hernandez on 1/4/18.
//  Copyright © 2018 Cordero Hernandez. All rights reserved.
//

import Archeota
import Foundation
import UIKit

class WelcomeScreenOne: UIViewController {
    
    var timer: Timer!
    var delegate: WelcomeScreenDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(goToWelcomeScreenTwo), userInfo: nil, repeats: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer.invalidate()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        goToWelcomeScreenTwo()
    }
}

//MARK: - Segues
extension WelcomeScreenOne {
    
    @objc func goToWelcomeScreenTwo() {
        
        performSegue(withIdentifier: SegueKeys.toWelcomeScreenTwo, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? WelcomeScreenTwo {
            destination.delegate = self.delegate
        }
    }
}

