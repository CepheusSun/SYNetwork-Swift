//
//  SYRequest.swift
//  SYNetWork-Swift
//
//  Created by sunny on 2017/3/29.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import Foundation

/// 请求响应状态
///
/// - success: 响应成功  - 成功
/// - unusual: 响应异常  - 例如:
/// - failure: 请求错误  - 例如: 网络错误
enum ResponseStatus: Int {
    case success = 0
    case unusual = 1
    case failure = 3
}

public enum RequestType {
    case get
    case post
}



/// request 协议, 为每个 api 提供相对应的内容
public protocol Request {
    
    var url:String! { get }
    var path: String! { get }
    var requestType: RequestType { get }
    var cacheTimeInterval: Int { get }
    var parameters:[String: Any] { get }
    var request:URLRequest? { get }

    /// 根据返回的结构判断是否合法
    ///
    /// - Parameter response: 返回的结果
    /// - Returns: 是否合法
    func isIllegal(_ response: Response) -> Bool
    
    /// 拼接参数
    ///
    /// - Parameter params: 原始参数
    /// - Returns: 返回完整参数
    func remakeParam() -> [String: Any]!
    
    
    /// 对服务器返回的数据进行解密
    ///
    /// - Parameter responseObject: 服务器返回的数据
    /// - Returns: 解密后的数据
    func decode(_ responseObject: Any!) -> Data
}


