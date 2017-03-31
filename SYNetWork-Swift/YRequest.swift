//
//  YRequest.swift
//  SYNetWork-Swift
//
//  Created by sunny on 2017/3/30.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import Foundation

class YRequest: Request {
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
    func remake(_ params: [String : Any]!) -> [String : Any]! {
        var res = parameters
        
        res["gps_info"] = SYLocationTool.shared.gps_info_string()
        res["loc_info"] = SYLocationTool.shared.loc_info_string()
        res["cv"] = "IK\(SYDevice.device.app_version()!)_Iphone"
        res["idfv"] = SYDevice.device.idfvString()
        res["idfa"] = SYDevice.device.idfaString()
        res["osversion"] = "ios_\(SYDevice.device.os_version()!)"
        res["imsi"] = ""
        res["imei"] = ""
        res["ua"] = SYDevice.device.device_name()
        res["uid"] = "17800399"
        res["count"] = "5"
        return res
    }

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
        return 1000
    }
    
    var requestType: RequestType {
        return .get
    }

    var path: String! {
        return "live/ticker"
    }

    var url: String! {
        return "http://service.ingkee.com/api/"
    }

    
    
}
