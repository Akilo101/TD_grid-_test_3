//
// GOOD ONE
//  GameViewController.swift
//  Cookie Crunch
//
//  Created by jeremy on 3/3/16.
//  Copyright (c) 2016 Indicane. All rights reserved.
//

//De-Cookied

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    var scene: GameScene!
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        level = Level(filename: "Level_1")
        scene.level = level
        scene.addTiles()
        skView.presentScene(scene)
        beginGame()
    }
    func beginGame() { //Need to add a Set<buttons> in level        
        //let newButtons = level.createButtons()
        //scene.addSpritesForButtons(newButtons)
    }
    var level: Level!
    
}