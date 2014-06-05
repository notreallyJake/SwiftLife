//
//  Cell.swift
//  SwiftLife
//
//  Created by Jan Willem de Birk on 6/5/14.
//  Copyright (c) 2014 notreallyJake. All rights reserved.
//

import Foundation

struct Cell {
    var x:Int = 0
    var y:Int = 0
    var alive:Bool = false
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}