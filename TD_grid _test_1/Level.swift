//
// GOOD ONE
//  level.swift
//  TD_grid _test_1
//
//  Created by ryan on 4/12/16.
//  Copyright © 2016 Indicane. All rights reserved.
//

import Foundation


let NumColumns = 32
let NumRows = 24
let MaxRoundedColumns = 5

let croissantT = TowerType(rawValue: 1)
let cupcakeT = TowerType(rawValue: 2)
let danishT = TowerType(rawValue: 3)
let donutT = TowerType(rawValue: 4)

class Level {
    
    private var towers = Array2D<Tower>(columns: NumColumns, rows: NumRows)
    private var tiles = Array2D<Tile>(columns: NumColumns, rows: NumRows)
    private var buttons = Array2D<Button>(columns: NumColumns, rows: NumRows)
    private var buttonSpaces = Array2D<ButtonSpace>(columns: NumColumns, rows: NumRows)
    
    func towerAtColumn(column: Int, row: Int) -> Tower? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return towers[column, row]
    }
    
    
    func buttonAtColumn(column: Int, row: Int) -> Button? { //Detects if there is a button space
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return buttons[column, row]
    }
    
    /*func determineTowerType(column: Int, row: Int) -> TowerType {
        var towerType: TowerType
        towerType = towers[column, row]!.towerType //This piece does not work //////////////////////////////////////
        return towerType 
    }*/
    
    init(filename: String) {
        
        // 1
        if let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename) {
            // 2
            if let tilesArray: AnyObject = dictionary["tiles"] {
                // 3
                for (row, rowArray) in (tilesArray as! [[Int]]).enumerate() {
                    // 4
                    let tileRow = NumRows - row - 1
                    // 5
                    for (column, value) in rowArray.enumerate() {
                        if value == 0 { //A tower can not be placed
                            
                        }
                        if value == 1 { //A Tile for a tower
                            tiles[column, tileRow] = Tile()
                        }
                        if value == 2 { //A Button
                            buttonSpaces[column, tileRow] = ButtonSpace()
                        }
                        if value == 3 { //A Button
                            buttonSpaces[column, tileRow] = ButtonSpace()
                        }
                    }
                }
            }
        }
    }
    
    func placeTower(column: Int, row: Int, towerType: TowerType) -> Set<Tower> {
        var set = Set<Tower>()
        if tiles[column, row] != nil {
            
            var damage: Int = 0
            var range: Int = 0
            if towerType == croissantT {
                damage = 150
                range = 70
            }
            if towerType == cupcakeT {
                damage = 100
                range = 100
            }
            if towerType == danishT {
                damage = 80
                range = 120
            }
            if towerType == donutT {
                damage = 120
                range = 80
            }
            
            
            
            let tower = Tower(column: column, row: row, towerType: towerType, damage: damage, range: range)
            towers[column, row] = tower
            towers[column + 1, row] = tower
            towers[column + 1, row + 1] = tower
            towers[column, row + 1] = tower
            set.insert(tower)
        }
        return set
    }
    
    
    
    func drawTowerButtons(column: Int, row: Int, buttonType: ButtonType) -> Button { //Draws the buttons
        let button = Button(column: column, row: row, buttonType: buttonType)
        buttons[column, row] = button
        return button
    }
    
    
    func createTowerButtons() -> Set<Button> {
        var set = Set<Button>()
        
        // Loop through the rows and columns of the 2D array. Note that column 0,
        // row 0 is in the bottom-left corner of the array.
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                
                // Only make a new button if there is a tile at this spot.
                if buttonSpaces[column, row] != nil {
                    var buttonType: ButtonType
                    
                    var roundedColumn = round(Float(column - 1)/2) //Creates the sets of 2 buttons
                    if roundedColumn <= 0 {
                        roundedColumn = 0
                    }
                    if row <= 1 { //Sets up the buttons in the bottom of the screen
                        for currentColumn in 0..<MaxRoundedColumns { //Places the buttons in sets of 2
                            if Int(roundedColumn) == Int(currentColumn) {
                                buttonType = ButtonType(rawValue: currentColumn + 1)!
                                let button = self.drawTowerButtons(column, row: row, buttonType: buttonType)
                                set.insert(button)
                            }
                        }
                    }
                }
            }
        }
        return set
    }
    
    
    
    func buttonSpaceAtColumn(column: Int, row: Int) -> ButtonSpace? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return buttonSpaces[column, row]
    }
    
    
    func tileAtColumn(column: Int, row: Int) -> Tile? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return tiles[column, row]
    }
    
    func legalTileAtColumn(column: Int, row: Int) -> (success: Bool, column: Int, row: Int) {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        if (tiles[column, row] != nil) {
            return (true, column, row)
        }
        else{
            return (false, column, row)
        }
    }
    
    
    
    
    
}