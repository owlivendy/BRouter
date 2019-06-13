//
//  DetailController.swift
//  BRouter_Example
//
//  Created by mike on 2019/6/13.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import BRouter

class DetailController: UIViewController, PageRouterable {
    
    var id: Int?
    var name: String?
    
    var nameLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        nameLabel.text = "欢迎~\(name ?? "guest")"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = UIColor.black
        
        view.addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
    }
    
}

extension DetailController {
    func setParamters(query: [String : String]?, extendParam: [String : Any]?) {
        if let idstr = query?["id"] {
            id = Int(idstr)
        }
        if let tname = query?["name"] {
            name = tname
        }
    }
}
