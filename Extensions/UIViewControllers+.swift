//
//  UIViewControllers+.swift
//  Organix
//
//  Created by Cordero Hernandez on 12/16/17.
//  Copyright © 2017 Cordero Hernandez. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func startSpinningIndicator() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func stopSpinningIndicator() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func hideNavigationBar() {
        
        guard let navigation = self.navigationController?.navigationBar else { return }
        
        navigation.isTranslucent = true
        navigation.setBackgroundImage(UIImage(), for: .default)
        navigation.shadowImage = UIImage()
        navigation.backgroundColor = UIColor.clear
    }
    
    func showNavigationBar() {
        
        guard let navigation = self.navigationController?.navigationBar else { return }
        navigation.isTranslucent = false
    }
}
