//
//  SYResponse.swift
//  SYNetWork-Swift
//
//  Created by sunny on 2017/3/29.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import Foundation


public class Response: NSObject {
    
//    var name: String?
    
    /// 原始数据
    var data: Data?
    var isCache: Bool?
    /// 解析后的数据
    var content: Any?
    var error: Error?
    convenience init(_ responseData: Data?, fromcache: Bool){
        self.init()
        self.data = responseData
        self.isCache = fromcache
        self.content = try? JSONSerialization.jsonObject(with: (responseData)!, options: .allowFragments)
        if self.content == nil {
            // 数据解析失败
            let err = NSError(domain: "the data is not in the correct format", code: -1001, userInfo: nil)
            self.error = err
        }
    }
}
