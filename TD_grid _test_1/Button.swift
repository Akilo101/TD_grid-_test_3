//
// GOOD ONE
//  Button.swift
//  TD_grid _test_1
//
//  Created by ryan on 4/18/16.
//  Copyright © 2016 Indicane. All rights reserved.
//



import SpriteKit

enum ButtonType: Int, CustomStringConvertible {
    case Unknown = 0, Croissant, Cupcake, Danish, Donut, Macaroon, SugarCookie //These are the names of the button types
    
    var description: String {
        return spriteName
    }
    var spriteName: String { //These names are the names of the image files (Will change to button files)
        let spriteNames = [
            "Croissant",
            "Cupcake",
            "Danish",
            "Donut",
            "Macaroon",
            "SugarCookie"]
        
        return spriteNames[rawValue - 1]
        
    }
    
    var highlightedSpriteName: String { //This is the name of the highlighted image file (Might not be needed)
        return spriteName + "-Highlighted"
    }
}

class Button: CustomStringConvertible, Hashable {
    var hashValue: Int {
        return row*10 + column
    }
    var description: String {
        return "type:\(buttonType) square:(\(column),\(row))"
    }
    var column: Int
    var row: Int
    let buttonType: ButtonType
    var sprite: SKSpriteNode?
    
    init(column: Int, row: Int, buttonType: ButtonType) {
        self.column = column
        self.row = row
        self.buttonType = buttonType
    }
}
func ==(lhs: Button, rhs: Button) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row
}