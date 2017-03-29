//
//  DRequest.swift
//  SYNetWork-Swift
//
//  Created by sunny on 2017/3/29.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import Foundation
import CoreTelephony

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
    func remake(_ params: [String : Any]!) -> [String : Any]! {
        
        var res = params
//        
//        return @{@"user_client_height"  :[NSNumber numberWithInt:kScreenH] ,
//            @"user_client_width"   : [NSNumber numberWithInt:kScreenW],
//            @"user_client_memory"  :[NSNumber numberWithLongLong:[NSProcessInfo processInfo].physicalMemory],
//            @"user_network"        :[QKService getDeviceNetworkType],
//            @"network"             :[QKService getDeviceNetworkType],
//            @"user_os"             :[[UIDevice currentDevice] systemName],
//            @"user_os_version"     :[[UIDevice currentDevice] systemVersion],
//            @"user_model"          :[NSObject objDeviceType],
//            @"user_client_operator":nettype,
//            @"user_channel"        :([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.zhqk.tvbee"] ? @"company": @"AppStore"),
//            @"channel"             :([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.zhqk.tvbee"] ? @"company": @"AppStore"),
//            @"version"             :[[UIDevice currentDevice] systemVersion],
//            @"device_id"           :[self UUID],
//            @"platform"            :@"1",
//            @"package"             :[[NSBundle mainBundle] bundleIdentifier]
//        }.mutableCopy;
//        
//        return @{@"user_client_height"  :[NSNumber numberWithInt:kScreenH] ,
//            @"user_client_width"   : [NSNumber numberWithInt:kScreenW],
//            @"user_client_memory"  :[NSNumber numberWithLongLong:[NSProcessInfo processInfo].physicalMemory],
//            @"user_network"        :[QKService getDeviceNetworkType],
//            @"network"             :[QKService getDeviceNetworkType],
//            @"user_os"             :[[UIDevice currentDevice] systemName],
//            @"user_os_version"     :[[UIDevice currentDevice] systemVersion],
//            @"user_model"          :[NSObject objDeviceType],
//            @"user_client_operator":nettype,
//            @"user_channel"        :([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.zhqk.tvbee"] ? @"company": @"AppStore"),
//            @"channel"             :([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.zhqk.tvbee"] ? @"company": @"AppStore"),
//            @"version"             :[[UIDevice currentDevice] systemVersion],
//            @"device_id"           :[self UUID],
//            @"platform"            :@"1",
//            @"package"             :[[NSBundle mainBundle] bundleIdentifier]
//        }.mutableCopy;
//        
        
        let networkInfo = CTTelephonyNetworkInfo()
        let carrier = networkInfo.subscriberCellularProvider
        let nettype = carrier?.carrierName ?? "无运营商"
        
        res?["user_client_height"] = ""
        res?["user_client_width"] = ""
        res?["user_client_memory"] = SYDevice.device.device_memory()
        res?["user_network"] = ""
        res?["network"] = ""
        res?["user_os"] = SYDevice.device.sys_name()
        res?["user_os_version"] = SYDevice.device.os_version()
        res?["user_model"] = SYDevice.device.device_name()
        res?["user_client_operator"] = nettype
#if DEBUG
        res?["user_channel"] = "company"
        res?["channel"] = "company"
#else
        res?["user_channel"] = "AppStore"
        res?["channel"] = "AppStore"
#endif
        res?["version"] = SYDevice.device.os_version()
        res?["device_id"] = SYDevice.device.uuid()
        res?["platform"] = "1"
        res?["package"] = SYDevice.device.app_bundleId()
        
        
        return res
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

