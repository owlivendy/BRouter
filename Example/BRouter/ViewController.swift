//
//  ViewController.swift
//  BRouter
//
//  Created by owliVendy on 06/13/2019.
//  Copyright (c) 2019 owliVendy. All rights reserved.
//

import UIKit
import BRouter

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///注册页面跳转，跳转的页面DetailController 需要实现PageRouterable 用来接收参数
        BRouter.map(url: "appscheme://item/detail", page: DetailController.self)
        
        ///自定义，方式注册
        BRouter.register(url: "appscheme://user/getUserInfo") { (query, extend, callback) in
            //打印参数
            print(query)
            print(extend)
            //query, extend, callback
            //模拟网络请求
            DispatchQueue.global().async {
                sleep(2)
                DispatchQueue.main.async {
                    callback?(["result":"success"])
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func customRouter(sender:UIButton) {
        BRouter.handle(url: "appscheme://user/getUserInfo?userId=121", extened: ["Image":1]) { (paramters) in
            ///回调结果参数
            print("请求结果 \(paramters)")
        }
    }
    
    //页面跳转
    @IBAction func pageRouter(sender:UIButton) {
        BRouter.open(url: "appscheme://item/detail?id=1&name=小飞", from: self.navigationController)
    }
    
}

