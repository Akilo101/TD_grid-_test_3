//
//  Enemy.swift
//  TD_grid _test_1
//
//  Created by jeremy on 5/23/16.
//  Copyright © 2016 Indicane. All rights reserved.
//

import UIKit
import SpriteKit

class Enemy: SKSpriteNode {
    var health: Int = 10000
    var damageToPlayer: Int = 10
    
    init() {
        var image = SKTexture(imageNamed: "rsz_sombraro")
        super.init(texture: image, color: UIColor.clearColor(), size:image.size())
    }
    
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
