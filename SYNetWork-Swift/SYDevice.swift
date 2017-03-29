//
//  SYDevice.swift
//  SwiftLive
//
//  Created by sunny on 2017/3/23.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import UIKit
import AdSupport

class SYDevice: NSObject {
    
    
    let app_info_dictionary = Bundle.main.infoDictionary!
    /// 单例对象
    static let device = SYDevice()
    
    /// 获取设备 os 版本号
    ///
    /// - Returns: 10.000000
    func os_version() -> String! {
        let string = UIDevice.current.systemVersion
        let strArray = string.components(separatedBy: ".")
        let count = 6 - strArray[1].characters.count
        var str = ""
        for _ in 0..<count {
            str.append("0")
        }
        return "\(strArray.first!).\(strArray[1])\(str)"
    }
    
    
    /// 获取系统名称
    ///
    /// - Returns: iOS
    func sys_name() -> String {
        return UIDevice.current.systemName
    }
    
    /// 获取设备名称
    ///
    /// - Returns: iPhone7_1    -> 6p
    func device_name() -> String! {
        
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        return machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }/*.replacingOccurrences(of: ",", with: "_")*/
    }
    
    
    /// 系统内存
    ///
    /// - Returns: 
    func device_memory() -> Int {
        return Int(ProcessInfo.processInfo.physicalMemory)
    }
    
}

extension SYDevice {
    /// 获取 app 版本信息
    ///
    /// - Returns: 1.0.0
    func app_version() -> String! {
        return app_info_dictionary["CFBundleShortVersionString"] as! String!
    }
    
    
    /// 获取 app bundle id
    ///
    /// - Returns:
    func app_bundleId() -> String! {
        return Bundle.main.bundleIdentifier
    }
}

let QKUUID = "QK_UUID_SVAE";
extension SYDevice {
    
    /// 获取设备IDFA
    ///
    /// - Returns: IDFA string
    func idfaString() -> String! {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    /// 获取设备IDFV
    ///
    /// - Returns: IDFV string
    func idfvString() -> String! {
        return UIDevice.current.identifierForVendor?.uuidString
    }
    
    func uuid() -> String! {
        
        if (UserDefaults.standard.object(forKey: QKUUID) != nil) {
            return UserDefaults.standard.object(forKey: QKUUID) as! String
        } else {
            let uuid_ref = CFUUIDCreate(nil)
            let uuid_string_ref = CFUUIDCreateString(nil, uuid_ref)
            let uuid = String(describing: uuid_string_ref)
            UserDefaults.standard.set(uuid, forKey: QKUUID)
            return uuid
        }
        
    }
}

// MARK: - Layout
extension SYDevice {
    
    /// 是否横屏
    ///
    /// - Returns: 横屏返回 true
    func isHorizontal() -> Bool {
        return UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight
    }
}


/// 根据横屏状态获取屏幕高度
///
/// - Returns: 始终返回屏幕的高
func ScreenHeight() -> CGFloat {
    if SYDevice.device.isHorizontal() {
        return UIScreen.main.bounds.width
    }
    return UIScreen.main.bounds.height
}

func ScreenWidth() -> CGFloat {
    if SYDevice.device.isHorizontal() {
        return UIScreen.main.bounds.height
    }
    return UIScreen.main.bounds.width
}

