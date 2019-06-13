//
//  Routerable.swift
//  lanjingtao
//
//  Created by mike on 2019/6/5.
//  Copyright © 2019 shiqianren. All rights reserved.
//

import UIKit

public protocol PageRouterable where Self: UIViewController {
    func setParamters(query:[String : String]?, extendParam: [String : Any]?)
}

public extension PageRouterable where Self: UIViewController {
    func setParamters(query:[String : String]?, extendParam: [String : Any]?) {
    }
}
