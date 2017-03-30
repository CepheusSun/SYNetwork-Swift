//
//  SYResponse.swift
//  SYNetWork-Swift
//
//  Created by sunny on 2017/3/29.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import Foundation


public class Response: NSObject {
    
    var name: String?
    
    /// 原始数据
    var data: Data?
    var isCache: Bool?
    
    /// 解析后的数据
    var content: [String: Any]?
    
    convenience init(_ responseData: Data?, error: Error?){
        self.init()
        self.data = responseData
        self.isCache = false
        
        if (responseData != nil) {
            self.content = try? JSONSerialization.jsonObject(with: (responseData)!, options: .allowFragments) as! [String: Any]
        }
        
    }
    
    convenience init(_ responseData: Data) {
        self.init()
        self.data = responseData
        self.isCache = true
        self.content = try? JSONSerialization.jsonObject(with: (responseData), options: .allowFragments) as! [String: Any]
    }
}
