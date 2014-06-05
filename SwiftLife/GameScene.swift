//
//  GameScene.swift
//  SwiftLife
//
//  Created by Jan Willem de Birk on 6/4/14.
//  Copyright (c) 2014 notreallyJake. All rights reserved.
//

import SpriteKit

extension CGPoint : Hashable {
    var hashValue: Int { get {
        return Int(x) * 10000 + Int(y)
    }}
}

class GameScene: SKScene {
    
    var cells: Array<CGPoint> = []
    var lastGenerationTime: NSTimeInterval = NSTimeIntervalSince1970
    let nodeSize: Float = 32.0
    
    override func didMoveToView(view: SKView) {
        
        // an example (stable) pattern.
        self.addCell(CGPoint(x: 12, y: 15))
        self.addCell(CGPoint(x: 13, y: 14))
        self.addCell(CGPoint(x: 13, y: 13))
        self.addCell(CGPoint(x: 12, y: 12))
        self.addCell(CGPoint(x: 11, y: 14))
        self.addCell(CGPoint(x: 11, y: 13))
    
        // render and pause (until a touch occurs)
        self.renderGeneration()
        self.paused = true
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        for aTouch : AnyObject in touches {
            let touch = aTouch as UITouch // I'm sure I can do this differently, no idea how.
            
            // see what position has been touched.
            let location = touch.locationInNode(self)
            let point = locationToPoint(location)
            
            self.addCell(point)
            self.renderCell(point)
        }
        
        self.paused = false;
    }
   
    override func update(currentTime: CFTimeInterval) {
        
        if self.lastGenerationTime != NSTimeIntervalSince1970 && !self.paused {
            if (currentTime - self.lastGenerationTime >= 0.25) {
                self.simulateGeneration()
                self.renderGeneration()
                self.lastGenerationTime = currentTime
            }
        } else {
            self.lastGenerationTime = currentTime
        }
    }
    
    // ** game logic ** //
    
    func locationToPoint(location: CGPoint) -> CGPoint {
        let x = Int(floorf(location.x / nodeSize))
        let y = Int(floorf(location.y / nodeSize))
        
        return CGPoint(x: x, y: y)
    }
    
    func addCell(point: CGPoint) {
        cells.append(point)
    }
    
    func renderCell(cell: CGPoint) {
        var node: SKSpriteNode = SKSpriteNode(color: UIColor.greenColor(), size: CGSize(width: nodeSize, height: nodeSize))
        node.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        node.position = CGPoint(x: (nodeSize * Float(cell.x)), y: (nodeSize * Float(cell.y)))
        self.addChild(node)
    }
    
    func neighbors(cell: CGPoint) -> Array<CGPoint> {
        var neighbors: Array<CGPoint> = []
        for x in (-1...1) {
            for y in (-1...1) {
                if x != 0 || y != 0 {
                    neighbors.append(CGPoint(x: cell.x + Float(x), y: cell.y + Float(y)))
                }
            }
        }
        
        return neighbors
    }
    
    func simulateGeneration() {
        
        var simulatedCells: Array<CGPoint> = []
        
        // create a dictionary with relationships between cells and neighbors.
        var relationships:Dictionary<CGPoint, Int> = [:]
        for cell in cells{
            relationships[cell] = 0
        }
        
        // go over the cells to count the neighbors.
        for cell in cells {
            for neighbour in self.neighbors(cell) {
                if let currentCount = relationships[neighbour]{
                    relationships[neighbour] = currentCount + 1
                } else {
                    relationships[neighbour] = 1
                }
            }
        }
        
        // decide if cells need to remain alive
        for cell in cells {
            var count:Int? = relationships.removeValueForKey(cell)
            if count && (count == 2 || count == 3){
                simulatedCells.append(cell)
            }
        }
        
        // decide if neighbors need to be revived
        for (cell, count) in relationships {
            if count == 3 {
                simulatedCells.append(cell)
            }
        }
        
        self.cells = simulatedCells
    }
    
    func renderGeneration() {
        self.removeAllChildren()
        
        // loop through cells to see what needs to be drawn.
        for cell : CGPoint in cells {
            self.renderCell(cell)
        }
    }
}
