# BRouter

<!--[![CI Status](https://img.shields.io/travis/owliVendy/BRouter.svg?style=flat)](https://travis-ci.org/owliVendy/BRouter)
[![Version](https://img.shields.io/cocoapods/v/BRouter.svg?style=flat)](https://cocoapods.org/pods/BRouter)
[![License](https://img.shields.io/cocoapods/l/BRouter.svg?style=flat)](https://cocoapods.org/pods/BRouter)
[![Platform](https://img.shields.io/cocoapods/p/BRouter.svg?style=flat)](https://cocoapods.org/pods/BRouter) -->


## Overview

一个用来做组件之间通信的Router， 开发思路来自MGJRouter。 感谢蘑菇街的开源代码。 
此库提供的功能： 
- 可以自由的注册Url 和 对应的响应方法
- 使用协议的方式，简化控制器之间的跳转，注册。

## Usage

### 自定义注册

```Swift
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

///处理 url
BRouter.handle(url: "appscheme://user/getUserInfo?userId=121", extened: ["Image":1]) { (paramters) in
    ///回调结果参数
    print("请求结果 \(paramters)")
}
```


### 页面注册

```Swift
///注册页面跳转，跳转的页面YourViewController 需要实现PageRouterable 用来接收参数
BRouter.map(url: "appscheme://item/detail", page: YourViewController.self)

///拿到配置的url， 跳转到匹配的页面
let url = "appscheme://item/detail?id=1&name=小飞"
BRouter.open(url: url, from: self.navigationController)
```

## Requirements

- Xcode 10.2+
- Swift 5.0+ (for latest release)

## Installation
 
BRouter is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BRouter'
```

## Author

owliVendy, 446200660@qq.com

## License

BRouter is available under the MIT license. See the LICENSE file for more info.
