//
//  Integers+.swift
//  Organix
//
//  Created by Cordero Hernandez on 11/1/17.
//  Copyright © 2017 Cordero Hernandez. All rights reserved.
//

import Foundation

extension Int {
    
    var bytes: Int { return self }
    var kb: Int { return bytes * 1024 }
    var mb: Int { return kb * 1024 }
}
