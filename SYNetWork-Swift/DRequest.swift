//
//  DRequest.swift
//  SYNetWork-Swift
//
//  Created by sunny on 2017/3/29.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import Foundation

class DRequest: Request {
    /// 对服务器返回的数据进行解密
    ///
    /// - Parameter responseObject: 服务器返回的数据
    /// - Returns: 解密后的数据
    func decode(_ responseObject: Any!) -> Data {
        return responseObject as! Data
    }

    /// 拼接参数
    ///
    /// - Parameter params: 原始参数
    /// - Returns: 返回完整参数
    func remake(_ params: [String : Any]?) -> [String : Any] {
        return params!
    }

    var url: String!


    /// 根据返回的结构判断是否合法
    ///
    /// - Parameter response: 返回的结果
    /// - Returns: 是否合法
    func isIllegal(_ response: Response) -> Bool {
        return true
    }

    var request: NSMutableURLRequest? {
        return nil
    }

    var parameters: [String : Any] {
        return [:]
    }

    var cacheTimeInterval: Int {
        return 0
    }

    var requestType: RequestType {
        return .post
    }

    var path: String! {
        return ""
    }
}

