//
//  BRouterNode.swift
//  lanjingtao
//
//  Created by mike on 2019/6/5.
//  Copyright © 2019 shiqianren. All rights reserved.
//

import UIKit

class BRouterNode {
    var name: String
    var subNodes = [String : BRouterNode]()
    var action: BRouter.Action?
    
    init(name:String) {
        self.name = name
    }
}
