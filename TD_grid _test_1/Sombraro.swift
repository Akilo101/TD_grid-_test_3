//
//  Sombraro.swift
//  TD_grid _test_1
//
//  Created by jeremy on 5/23/16.
//  Copyright © 2016 Indicane. All rights reserved.
//

import UIKit
import SpriteKit

class Sombraro: Enemy {
    override init() {
        super.init()
        damageToPlayer = 5
        var image = SKTexture(imageNamed: "Enemy") //Needs to override the image in Enemy.swift
        
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
