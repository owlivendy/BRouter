//
//  BRouter_Pageable.swift
//  lanjingtao
//
//  Created by mike on 2019/6/5.
//  Copyright © 2019 shiqianren. All rights reserved.
//

import UIKit

// MARK: - 扩展了BRouter， 使其对视图的路由简单化
public extension BRouter {
    fileprivate static let PageKey = "controller"
    
    static func map<Controller>(url string: URLConvertiable, page:Controller.Type) where Controller: PageRouterable {
        BRouter.register(url: string) { (query, extend, callback) in
            let vc = page.init()
            vc.setParamters(query: query, extendParam: extend)
            callback?([PageKey:vc])
        }
    }
    
    static func open(url string: URLConvertiable, extened parameters: [String : Any]? = nil, from nav: UINavigationController?) {
        guard let tnav = nav else {
            return
        }
        BRouter.handle(url: string, extened: parameters) { (userInfo) in
            if let vc = userInfo[PageKey] as? UIViewController {
                tnav.pushViewController(vc, animated: true)
            }
        }
    }
}
