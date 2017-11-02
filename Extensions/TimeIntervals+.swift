//
//  TimeIntervals+.swift
//  Organix
//
//  Created by Cordero Hernandez on 11/1/17.
//  Copyright © 2017 Cordero Hernandez. All rights reserved.
//

import Foundation

extension TimeInterval {
    
    var seconds: Double { return self }
    var minutes: Double { return self * 60 }
    var hours: Double { return minutes * 60 }
    var days: Double { return hours * 24 }
}
