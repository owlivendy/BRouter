//
//  BRouter.swift
//  lanjingtao
//
//  Created by mike on 2019/6/5.
//  Copyright © 2019 mike. All rights reserved.
//

import UIKit

/*
 该类可以用于组件之间通信， 统一使用 url这种方式 exp. "appscheme://path/action?key1=value&key2=value"
*/
public class BRouter {
    public typealias URLConvertiable = String
    public typealias CallBack = (_ userInfo: [String: Any]) -> Void
    public typealias Action = (_ query: [String : String]?, _ extenedParameters: [String : Any]?, _ didCallback: CallBack?)->Void
    
//    public enum BRouterURLError: Error {
//        ///非法的url
//        case invalidURL
//        ///url没有包含scheme
//        case noneScheme
//    }
    
    ///单例
    public static let `default` = BRouter()
    
    fileprivate var nodes = [String: BRouterNode]()
}

public extension BRouter {
    /// 注册url
    ///
    /// - Parameters:
    ///   - string: url
    ///   - action: 动作
    static func register(url string: URLConvertiable, action: @escaping Action) {
        BRouter.default.register(url: string, action: action)
    }
    
    
    /// handle url
    ///
    /// - Parameters:
    ///   - url: url
    ///   - extenedParameters: 扩展属性
    ///   - didCallback: 会不会执行回调看register的时候有没有调用
    static func handle(url: URLConvertiable?, extened parameters: [String : Any]? = nil,  didCallback:CallBack? = nil) {
        BRouter.default.handle(url: url, extened: parameters, didCallback: didCallback)
    }
}

private extension BRouter {
    func handle(url: URLConvertiable?, extened parameters: [String : Any]? = nil,  didCallback:CallBack? = nil) {
        guard let urlString = url else {
            return
        }
        
        let encodedUrl = urlString.encodeUrl()
        guard let curl = URL.init(string: encodedUrl),
              let scheme = curl.scheme else {
                return
        }
        var paths = curl._paths
        guard paths.count > 0 else {
            return
        }
        guard let schemeNode = nodes[scheme] else {
            return
        }
        guard let tailNode = findTailNode(next: schemeNode, paths: &paths, index: 0) else {
            return
        }
        //do action~
        tailNode.action?(curl.query?.decodeQuery(), parameters, didCallback)
    }
    
    func register(url string: URLConvertiable, action: @escaping Action) {
        guard let url = URL.init(string: string) else {
            assertionFailure("BRouter invalid url!")
            return
        }
        guard let scheme = url.scheme else {
            assertionFailure("BRouter url must be have scheme")
            return
        }
        var paths = url._paths
        guard paths.count > 0 else {
            assertionFailure("BRouter url must be have path")
            return
        }
        
        if nodes[scheme] == nil {
            let schemeNode = BRouterNode(name: scheme)
            nodes[scheme] = schemeNode
        }
        let schemeNode = nodes[scheme]!
        let tailNode = parse(next: schemeNode, paths: &paths, index: 0)
        if tailNode.action != nil {
            assertionFailure("BRouter url had been added")
        }
        tailNode.action = action
    }
    
    ///创建节点
    func parse(next: BRouterNode, paths: inout [String], index: Int) -> BRouterNode {
        let component = paths[index]
        var nextNode: BRouterNode! = next.subNodes[component]
        if nextNode == nil {
            nextNode = BRouterNode(name: component)
            next.subNodes[component] = nextNode!
        }
        
        if index == paths.count - 1 {
            return nextNode
        }
        
        return parse(next: nextNode, paths: &paths, index: index + 1)
    }
    
    ///找尾节点
    func findTailNode(next: BRouterNode, paths: inout [String], index: Int) -> BRouterNode? {
        let component = paths[index]
        guard let nextNode = next.subNodes[component] else {
            return nil
        }
        
        if index == paths.count - 1 {
            return nextNode
        }
        
        return findTailNode(next: nextNode, paths: &paths, index: index + 1)
    }
    
}

fileprivate extension String {
    func encodeUrl() -> String {
        guard let find = self.firstIndex(of: Character.init("?")) else {
            return self
        }
        let pre = String(self[self.startIndex..<find])
        let query = String(self[self.index(find, offsetBy: 1)..<self.endIndex])
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        return "\(pre)?\(encodedQuery ?? "")"
    }

    
    func decodeQuery() -> [String : String] {
        let comps = self.components(separatedBy: "&").reduce(into: [String : String]()) { (accu, item) in
            let comps = item.components(separatedBy: "=")
            if comps.count == 2, let value = comps[1].removingPercentEncoding {
                accu[comps[0]] = value
            }
        }
        return comps
    }
}

fileprivate extension URL {
    var _paths: [String] {
        var paths = self.path.components(separatedBy: "/").filter({ $0.count > 0 })
        if let thost = self.host {
            paths.insert(thost, at: 0)
        }
        return paths
    }
}
