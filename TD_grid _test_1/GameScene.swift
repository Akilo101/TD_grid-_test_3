// GOOD ONE
//  GameScene.swift
//  TD_grid _test_1
//
//  Created by ryan on 4/12/16.
//  Copyright (c) 2016 Indicane. All rights reserved.
//





//Current Errors:
//Cordinate planes of Enemies and Towers are not alligned
//Distance formula does not work due to unsycronized grid





import SpriteKit
import UIKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var level: Level!
    var enemyGroup = EnemyGroup()
    let TileWidth: CGFloat = 32.0
    let TileHeight: CGFloat = 32.0
    let tilesLayer = SKNode()
    let highlightedTilesLayer = SKNode()
    let gameLayer = SKNode()
    let towersLayer = SKNode()
    let buttonsLayer = SKNode()
    let enemiesLayer = SKNode()
    let buttonSpacesLayer = SKNode()
    var selectionSprite = SKSpriteNode()
    var selectedColumn: Int!
    var selectedRow: Int!
    var oldColumn: Int! = 1
    var oldRow: Int! = 3
    var legalTowerPlacement: Bool = false
    var legalTowerButtonTap: Bool = false
    var levelNumber: Int = 1
    var enemyPosition: CGPoint = CGPointMake(0, 0)
    
    let croissantB = ButtonType(rawValue: 1)
    let cupcakeB = ButtonType(rawValue: 2)
    let danishB = ButtonType(rawValue: 3)
    let donutB = ButtonType(rawValue: 4)
    
    let croissantT = TowerType(rawValue: 1)
    let cupcakeT = TowerType(rawValue: 2)
    let danishT = TowerType(rawValue: 3)
    let donutT = TowerType(rawValue: 4)
    
    var enemyGroupPosition: [CGPoint] = []
    var towerGroupPosition: [CGPoint] = []
    var distanceToEnemy: [Double] = []
    var leastDistanceToEnemy: [Double] = []
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    
    override init(size: CGSize) {
        super.init(size: size)
        let background = SKSpriteNode(imageNamed: "Background") //Load The background
        background.size = size
        
        addChild(background)
        
        
        let layerPosition = CGPoint(
            x: -TileWidth * CGFloat(NumColumns) / 2,
            y: -TileHeight * CGFloat(NumRows) / 2)
        
        buttonSpacesLayer.position = layerPosition //Adds the tiles array to the scene
        gameLayer.addChild(buttonSpacesLayer)
        
        buttonsLayer.position = layerPosition //Adds the buttons array to the scene
        gameLayer.addChild(buttonsLayer)
        
        tilesLayer.position = layerPosition //Adds the tiles array to the scene
        gameLayer.addChild(tilesLayer)
        
        highlightedTilesLayer.position = layerPosition //Adds the towers array to the scene
        gameLayer.addChild(highlightedTilesLayer)
        
        towersLayer.position = layerPosition //Adds the towers array to the scene
        gameLayer.addChild(towersLayer)
        
        enemiesLayer.position = layerPosition //Adds the towers array to the scene
        gameLayer.addChild(enemiesLayer)
        
        addChild(gameLayer)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    
    
    
    
    
    
    func convertPoint(point: CGPoint) -> (success: Bool, column: Int, row: Int) { //Converts a CGPoint to a column and row
        if point.x >= 0 && point.x < CGFloat(NumColumns)*TileWidth &&
            point.y >= 0 && point.y < CGFloat(NumRows)*TileHeight {
                return (true, Int(point.x / TileWidth), Int(point.y / TileHeight))
        } else {
            return (false, 0, 0)  // invalid location
        }
    }
    
    
    
    func pointForColumn(column: Int, row: Int) -> CGPoint { //Turns a column point into a CGPoint
        return CGPoint(
            x: CGFloat(column)*TileWidth + TileWidth/2,
            y: CGFloat(row)*TileHeight + TileHeight/2)
    }

    
    
    
    
    //////////////////////Buttons and Tiles////////////////////////////
    
    
    func addSpritesForTowers(towers: Set<Tower>) { //places an image in the spot of the tower
        for tower in towers {
            let sprite = SKSpriteNode(imageNamed: tower.towerType.spriteName)
            let position = pointForColumn(tower.column, row: tower.row)
            let x = position.x
            let y = position.y
            sprite.position = CGPoint(x: x + (TileWidth / 2), y: y + (TileHeight / 2))
            sprite.size = CGSize(width: TileWidth * 2, height: TileHeight * 2 )
            towersLayer.addChild(sprite)
            tower.sprite = sprite
        }
    }
    
    
    func addSpritesForButtons(buttons: Set<Button>) { //Places an image in the spot of the button
        buttonsLayer.hidden = false
        for button in buttons {
            let sprite = SKSpriteNode(imageNamed: button.buttonType.spriteName)
            sprite.position = pointForColumn(button.column, row: button.row)
            sprite.size = CGSize(width: TileWidth, height: TileHeight)
            buttonsLayer.addChild(sprite)
            button.sprite = sprite
        }
    }
    
    
    
    
    func addTiles() { //Adds images to all tile spots
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                if let tile = level.tileAtColumn(column, row: row) {
                    let tileNode = SKSpriteNode(imageNamed: "Tile")
                    tileNode.position = pointForColumn(column, row: row)
                    tileNode.size = CGSize(width: TileWidth, height: TileHeight)
                    tilesLayer.addChild(tileNode)
                }
            }
        }
    }
    
    
    
    
    func removeButtons() { //Removes button from the screen
        buttonsLayer.hidden = true
    }
    
    
    func highlight2x2(selectedColumn: Int, selectedRow: Int) { //Highlights a 2x2 area w/ bottom left being reference point
        let highlightedTile1 = SKSpriteNode(imageNamed: "HighlightedTile")
        let highlightedTile2 = SKSpriteNode(imageNamed: "HighlightedTile")
        let highlightedTile3 = SKSpriteNode(imageNamed: "HighlightedTile")
        let highlightedTile4 = SKSpriteNode(imageNamed: "HighlightedTile")
        highlightedTile1.position = pointForColumn(selectedColumn, row: selectedRow)
        highlightedTilesLayer.addChild(highlightedTile1)
        highlightedTile2.position = pointForColumn(selectedColumn + 1, row: selectedRow)
        highlightedTilesLayer.addChild(highlightedTile2)
        highlightedTile3.position = pointForColumn(selectedColumn + 1, row: selectedRow + 1)
        highlightedTilesLayer.addChild(highlightedTile3)
        highlightedTile4.position = pointForColumn(selectedColumn, row: selectedRow + 1)
        highlightedTilesLayer.addChild(highlightedTile4)
    }
    
    
    
    func is2x2Legal (selectedColumn: Int, selectedRow: Int) -> (Bool) { //Checks to see if a 2x2 is allowed
        let (success, column, row) = level.legalTileAtColumn(selectedColumn + 1, row: selectedRow)
        if success {
            let (success, column, row) = level.legalTileAtColumn(selectedColumn + 1, row: selectedRow + 1)
            if success {
                let (success, column, row) = level.legalTileAtColumn(selectedColumn, row: selectedRow + 1)
                if success {
                    return (true)
                }
                else {
                    return (false)
                }
            }
            else {
                return (false)
            }
        }
        else {
            return (false)
        }
    }
    
    
    
    
    //////////////////////////////////TOUCHES//////////////////////////////////////
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first as UITouch!
        let towerLocation = touch.locationInNode(towersLayer)
        let normalTile = SKSpriteNode(imageNamed: "Tile") //Load The highlighted tile
        
        var (success, column, row) = convertPoint(towerLocation)
        if success {
            if let tile = level.tileAtColumn(column, row: row) { //This checks to see if you tapped a tile
                if let tower = level.towerAtColumn(column, row: row) { //This checks to see if you tapped a tower
                    selectedColumn = column
                    selectedRow = row
                    highlightedTilesLayer.removeAllChildren()
                    highlightedTilesLayer.addChild(normalTile)
                    oldColumn = selectedColumn
                    oldRow = selectedRow
                    
                    legalTowerButtonTap = false

                    highlight2x2(selectedColumn, selectedRow: selectedRow)

                    removeButtons()
                }
                else { //Checks to see if there is an empty tile spot
                    selectedColumn = column
                    selectedRow = row
                    highlightedTilesLayer.removeAllChildren()
                    highlightedTilesLayer.addChild(normalTile)
                    oldColumn = selectedColumn
                    oldRow = selectedRow
                    legalTowerPlacement = false
                    legalTowerButtonTap = false
                    
                    
                    let (success) = is2x2Legal(selectedColumn, selectedRow: selectedRow)
                    if success {
                        legalTowerPlacement = true
                        legalTowerButtonTap = true
                        highlight2x2(selectedColumn, selectedRow: selectedRow)
                    }
                    
                    let buttons = level.createTowerButtons()
                    addSpritesForButtons(buttons)
                }
            }
            
        }

   
        let buttonLocation = touch.locationInNode(buttonsLayer)
        (success, column, row) = convertPoint(buttonLocation)
        if success {
            if let button = level.buttonAtColumn(column, row: row) { //This checks to see if you tapped a button
                var buttonType: ButtonType
                var towerType: TowerType
                var roundedColumn = round(Float(column - 1)/2) //Creates the sets of 2 buttons
                if roundedColumn <= 0 {
                    roundedColumn = 0
                }
                
                if row <= 1 { //Sets up the buttons in the bottom of the screen
                    for currentColumn in 0..<MaxRoundedColumns { //Arranges the buttons in sets of 2
                        if Int(roundedColumn) == Int(currentColumn) {
                            buttonType = ButtonType(rawValue: currentColumn + 1)!
                            
                            if buttonType == croissantB {
                                towerType = croissantT!
                                if legalTowerPlacement == true && legalTowerButtonTap == true {
                                    let newTower = level.placeTower(selectedColumn, row: selectedRow, towerType: towerType)
                                    addSpritesForTowers(newTower)
                                }
                            }
                            if buttonType == cupcakeB {
                                towerType = cupcakeT!
                                if legalTowerPlacement == true && legalTowerButtonTap == true {
                                    let newTower = level.placeTower(selectedColumn, row: selectedRow, towerType: towerType)
                                    addSpritesForTowers(newTower)
                                }
                            }
                            if buttonType == danishB {
                                towerType = danishT!
                                if legalTowerPlacement == true && legalTowerButtonTap == true {
                                    let newTower = level.placeTower(selectedColumn, row: selectedRow, towerType: towerType)
                                    addSpritesForTowers(newTower)
                                }
                            }
                            if buttonType == donutB {
                                towerType = donutT!
                                if legalTowerPlacement == true && legalTowerButtonTap == true {
                                    let newTower = level.placeTower(selectedColumn, row: selectedRow, towerType: towerType)
                                    addSpritesForTowers(newTower)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // If swipeFromColumn is nil then either the swipe began outside
        // the valid area or the game has already swapped the cookies and we need
        // to ignore the rest of the motion.
        
        let touch = touches.first as UITouch!
        let location = touch.locationInNode(towersLayer)
        let (success, column, row) = convertPoint(location) //We can use this to detect if a player has swipped on an existing tower
        if success {
            var towerType: TowerType
            
            
            //towerType = level.determineTowerType(column, row: row)
            //let newTower = level.placeTower(column, row: row, towerType: towerType) //Dont Want "PLACE TOWER" we need a move Tower function
            //addSpritesForTowers(newTower)
            hideSelectionIndicator()
            // Ignore the rest of this swipe motion from now on.
            
        }
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) { //Will be used to drop a tower
        if selectionSprite.parent != nil{
            hideSelectionIndicator()
        }
    }


    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        touchesEnded(touches!, withEvent: event)
    }

    
    
    
    
    
    
    /////////////////////////////////Random///////////////////////////////
    
    
    
    func distanceBetweenPoints(point1: CGPoint, point2: CGPoint) -> Double {
        let distanceX = (point2.x - point1.x) * (point2.x - point1.x)
        let distanceY = (point2.y - point1.y) * (point2.y - point1.y)
        //let distance = Double(pow(Float((distanceX + distanceY)), (0.5)))
        let distance = sqrt(Double(distanceX + distanceY))
        return distance
    }
    
    func showSelectionIndicatorForTower(tower: Tower) {
        if selectionSprite.parent != nil {
            selectionSprite.removeFromParent()
        }
    
        if let sprite = tower.sprite {
            let texture = SKTexture(imageNamed: tower.towerType.highlightedSpriteName)
            selectionSprite.size = texture.size()
            selectionSprite.runAction(SKAction.setTexture(texture))
        
            sprite.addChild(selectionSprite)
            selectionSprite.alpha = 1.0
        }
    }
    func hideSelectionIndicator() {
        selectionSprite.runAction(SKAction.sequence([
            SKAction.fadeOutWithDuration(0.3),
            SKAction.removeFromParent()]))
    }
    
    


    override func didMoveToView(view: SKView) {
        self.physicsWorld.contactDelegate = self
        createEnemies()
    }
    
    deinit{
        print("deinit called")
    }
    
    
    func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    func randomPointBetween(start:CGPoint, end:CGPoint)->CGPoint{//Helper method for spawning a point along the screen borders. This will not work for diagonal lines.
        return CGPoint(x: randomBetweenNumbers(start.x, secondNum: end.x), y: randomBetweenNumbers(start.y, secondNum: end.y))
    }
    
    
    
    
    
    
    
    
    
    
    
    ///////////////////////////////////////////ENEMIES////////////////////////////////////////////
    
    
    func createEnemies(){
        //Randomize spawning time.
        let wait = SKAction .waitForDuration(0.75, withRange: 0.1) //This will create a node every 0.75 +/- 0.1 seconds, means between 0.65 and 0.85 sec
        weak var  weakSelf = self //Use weakSelf to break a possible strong reference cycle
        let spawn = SKAction.runBlock({
            
            self.levelNumber = 1 //We will modify this select the level path
            var moveTo0 = CGPoint()
            var moveTo1 = CGPoint()
            var moveTo2 = CGPoint()
            var moveTo3 = CGPoint()
            var moveTo4 = CGPoint()
            var moveTo5 = CGPoint()
            var moveTo6 = CGPoint()
            var moveTo7 = CGPoint()
            var moveTo8 = CGPoint()
            var moveTo9 = CGPoint()
            var moveTo10 = CGPoint()
            var offset:CGFloat = 40
            switch self.levelNumber {

            case 1: //Level 1
                moveTo0 = CGPoint(x: -500, y: -230)
                moveTo1 = weakSelf!.randomPointBetween(CGPoint(x: -325, y: -230), end: CGPoint(x:-400, y: -270))
                moveTo2 = weakSelf!.randomPointBetween(CGPoint(x: -325, y: 200), end: CGPoint(x:-400, y: 240))
                moveTo3 = weakSelf!.randomPointBetween(CGPoint(x: -90, y: 200), end: CGPoint(x:-135, y: 190))
                moveTo4 = CGPoint(x: -90, y: 90)
                moveTo5 = weakSelf!.randomPointBetween(CGPoint(x: 100, y: 90), end: CGPoint(x: 75, y: 120))
                moveTo6 = weakSelf!.randomPointBetween(CGPoint(x: 100, y: 200), end: CGPoint(x:65, y: 240))
                moveTo7 = weakSelf!.randomPointBetween(CGPoint(x: 400, y: 200), end: CGPoint(x:450, y: 250))
                moveTo8 = weakSelf!.randomPointBetween(CGPoint(x: 400, y: -240), end: CGPoint(x:400, y: -140))
                moveTo9 = CGPoint(x: 40, y: -230)
                moveTo10 = CGPoint(x: 40, y: -300)
                
                
                break
            default:
                break
            }
            weakSelf!.spawnEnemyAtPosition(moveTo0,
                moveTo1: moveTo1,
                moveTo2: moveTo2,
                moveTo3: moveTo3,
                moveTo4: moveTo4,
                moveTo5: moveTo5,
                moveTo6: moveTo6,
                moveTo7: moveTo7,
                moveTo8: moveTo8,
                moveTo9: moveTo9,
                moveTo10: moveTo10)
            
        })
        let spawning = SKAction.sequence([wait,spawn])
        //self.runAction(spawning)
        self.runAction(SKAction.repeatActionForever(spawning), withKey:"spawning")
        //print("\(enemyPosition)")
        //return enemyPosition
    }
    
    
    
    
    func spawnEnemyAtPosition(moveTo0: CGPoint, moveTo1: CGPoint, moveTo2: CGPoint, moveTo3: CGPoint, moveTo4: CGPoint, moveTo5: CGPoint, moveTo6: CGPoint, moveTo7: CGPoint, moveTo8: CGPoint, moveTo9: CGPoint, moveTo10: CGPoint) {
        
        let enemy:Sombraro = Sombraro()
        enemyGroup.addEnemy(enemy)

        enemy.position = moveTo0
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.size)
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.dynamic = true
        enemy.physicsBody?.collisionBitMask = 0 // no collisions
        
        //Find the distances between every point
        let distance0 = distanceBetweenPoints(moveTo0, point2: moveTo1)
        let distance1 = distanceBetweenPoints(moveTo1, point2: moveTo2)
        let distance2 = distanceBetweenPoints(moveTo2, point2: moveTo3)
        let distance3 = distanceBetweenPoints(moveTo3, point2: moveTo4)
        let distance4 = distanceBetweenPoints(moveTo4, point2: moveTo5)
        let distance5 = distanceBetweenPoints(moveTo5, point2: moveTo6)
        let distance6 = distanceBetweenPoints(moveTo6, point2: moveTo7)
        let distance7 = distanceBetweenPoints(moveTo7, point2: moveTo8)
        let distance8 = distanceBetweenPoints(moveTo8, point2: moveTo9)
        let distance9 = distanceBetweenPoints(moveTo9, point2: moveTo10)
        
        
        //Move the enemy at a constant speed
        let move1 = SKAction.moveTo(moveTo1, duration: distance0 / 50)
        let move2 = SKAction.moveTo(moveTo2, duration: distance1 / 50)
        let move3 = SKAction.moveTo(moveTo3, duration: distance2 / 50)
        let move4 = SKAction.moveTo(moveTo4, duration: distance3 / 50)
        let move5 = SKAction.moveTo(moveTo5, duration: distance4 / 50)
        let move6 = SKAction.moveTo(moveTo6, duration: distance5 / 50)
        let move7 = SKAction.moveTo(moveTo7, duration: distance6 / 50)
        let move8 = SKAction.moveTo(moveTo8, duration: distance7 / 50)
        let move9 = SKAction.moveTo(moveTo9, duration: distance8 / 50)
        let move10 = SKAction.moveTo(moveTo10, duration: distance9 / 50)
        let delEnemy = SKAction.removeFromParent()
        
        let moveToSequence = SKAction.sequence([move1, move2, move3, move4, move5, move6, move7, move8, move9, move10, delEnemy])
        enemy.runAction(moveToSequence)
        
        self.addChild(enemy)
        
    }
    
    
    
    ////////////////////////////////ATTACK PHASE///////////////////////////////////////
    
    
    func findEnemyPositions() { //Finds the CGPoint of all enemies
        enemyGroupPosition.removeAll()
        for enemy in enemyGroup.enemies {
            enemyGroupPosition.append(enemy.position)
        }
    }
    
    
    
    
    func findTowerPositions() { //Finds the CGPoint of all towers
        towerGroupPosition.removeAll()
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                let towerLocation = pointForColumn(column, row: row)
                let (success, columnT, rowT) = convertPoint(towerLocation)
                if success {
                    if let tower = level.towerAtColumn(columnT, row: rowT) {
                        towerGroupPosition.append(towerLocation)
                    }
                }
            }
        }
    }



    func calculateDistanceToEnemy() { //Calculates the distances to each enemy and returns the enemies that must be attacked
        for tower in towerGroupPosition {
            distanceToEnemy.removeAll()
            leastDistanceToEnemy.removeAll()
            var index = 0
            var shortestDistance = 10000
            var shortestIndex = 0
            
            
            
            for enemy in enemyGroup.enemies {
                let distance = distanceBetweenPoints(tower, point2: enemy.position) //Finds the distances from the tower to the enemy
                if Int(distance) < shortestDistance {
                    shortestDistance = Int(distance)
                    shortestIndex = index
                    //print(shortestDistance)
                }
                index += 1
                print(enemy.position)
                
                
                
                distanceToEnemy.append(distance)
                //leastDistanceToEnemy.append(distance)
            }
            print("New")
            //print(shortestIndex)
            //print(enemyGroup.enemies)
            
            
            let targetEnemy = enemyGroup.enemies[shortestIndex]
            
            //print(targetEnemy.position)
            
            let sprite = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: 10, height: 10))
            sprite.position = targetEnemy.position
            addChild(sprite)
            
            
            /*
            leastDistanceToEnemy.sortInPlace() { (element1, element2) -> Bool in //Orders the array of distances to the current tower from least to most
                return element1 < element2
            }
            
            let least = leastDistanceToEnemy[0]
            
            for normal in distanceToEnemy {
                if least == normal {
                    let targetEnemy = distanceToEnemy.indexOf(least)
                    print(least)
                    print(leastDistanceToEnemy)
                    print(targetEnemy)
                    */
                    
                    
                    
                    
                    
                                //Check to see if it tracks the closest enemy
                    //let sprite = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: 10, height: 10))
                    //sprite.position = enemyGroupPosition[targetEnemy!]
                    //addChild(sprite)
              //  }
            //}
        }
    }
    
    
    
    ////////////////////////////////MAIN GAME LOOP/////////////////////////////////////////
    
    override func update(currentTime: NSTimeInterval) {
        
        // Finds all towers
        // Finds all enemies
        // Checks to see if an enemy is in range of the first one
        
        // Towers attack the closest
        // Enemies attack the tower
        // Enemies move
        
        
        findEnemyPositions()
        findTowerPositions()
        calculateDistanceToEnemy()
        
        
        
        
        
        
        
        //print(enemyGroup.enemies)
        
        
        
        /*let wait = SKAction.waitForDuration(0.1, withRange: 0.0)
        
        let enemyPosition = createEnemies()
        let x = Int(enemyPosition.x)
        let y = Int(enemyPosition.y)
        var enemyPos = 1
        
        enemyPos += 1
        
        
        
        
        let enemies = level.createEnemies(enemyPos, y: enemyPos)
        addSpritesForEnemies(enemies)
        print(enemyPos)
        runAction(wait)*/
    }

}
