//
// GOOD ONE
//  Tower.swift
//  Cookie Crunch
//
//  Created by jeremy on 3/3/16.
//  Copyright © 2016 Indicane. All rights reserved.
//

//De cookied

import SpriteKit

enum TowerType: Int, CustomStringConvertible {
    case Unknown = 0, Croissant, Cupcake, Danish, Donut, Macaroon, SugarCookie //These are the names of the image files
    
    var description: String {
        return spriteName
    }
    var spriteName: String { //These names are the names of the image files
        let spriteNames = [
            "Turret1",
            "Croissant-Highlighted", //Need to change these names to change the towers
            "Cupcake-Highlighted",
            "Danish-Highlighted",
            "Donut-Highlighted",
            "Macaroon-Highlighted",
            "SugarCookie-Highlighted"]
        
        return spriteNames[rawValue - 1]
        
    }
    
    var highlightedSpriteName: String { //This is the name of the highlighted image file (Might not be needed)
        return spriteName + "-Highlighted"
    }
}

class Tower: CustomStringConvertible, Hashable {
    var hashValue: Int {
        return row*10 + column
    }
    var description: String {
        return "type:\(towerType) square:(\(column),\(row))"
    }
    var column: Int
    var row: Int
    let towerType: TowerType
    var sprite: SKSpriteNode?
    var damage: Int
    var range: Int
    
    init(column: Int, row: Int, towerType: TowerType, damage: Int, range: Int) {
        self.column = column
        self.row = row
        self.towerType = towerType
        self.damage = damage
        self.range = range
    }
}
func ==(lhs: Tower, rhs: Tower) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row
}