//
//  SYLayout.swift
//  QKSwift
//
//  Created by sunny on 2017/3/29.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import UIKit

/// 基于 iPhone6 大小进行垂直方向的适配
///
/// - Parameter iPhone6: iPhone6 垂直方向的尺寸
/// - Returns: 其他型号设备的尺寸
func layoutVertical(iPhone6: CGFloat) -> CGFloat {
    
    var newHeight: CGFloat = 0
    switch iPhoneModel.getCurrentModel() {
    case .iPhone4:
        newHeight = iPhone6 * (480.0 / 667.0)
    case .iPhone5:
        newHeight = iPhone6 * (568.0 / 667.0)
    case .iPhone6:
        newHeight = iPhone6
    case .iPhone6p:
        newHeight = iPhone6 * (736.0 / 667.0)
    default:
        newHeight = iPhone6 * (1024 / 667.0 * 0.9)
    }
    return newHeight
}


/// 基于 iPhone6水平方向大小进行适配
///
/// - Parameter iPhone6: iPhone6 水平方向的尺寸
/// - Returns: 其他型号设备的尺寸
func layoutHorizontal(iPhone6: CGFloat) -> CGFloat {
    
    var newWidth: CGFloat = 0
    
    switch iPhoneModel.getCurrentModel() {
    case .iPhone4:
        newWidth = iPhone6 * (320.0 / 667.0)
    case .iPhone5:
        newWidth = iPhone6 * (320.0 / 375.0)
    case .iPhone6:
        newWidth = iPhone6
    case .iPhone6p:
        newWidth = iPhone6 * (414.0 / 375.0)
    default:
        newWidth = iPhone6 * (768.0 / 375.0 * 0.9)
    }
 
    return newWidth
}


/// 根据 iPhone6 字体进行屏幕的适配
///
/// - Parameter iPhone6: iPhone6 字体大小
/// - Returns: 其他型号设备字体大小
func layoutFont(iPhone6: CGFloat) -> CGFloat {
    
    var newFont: CGFloat = 0
    
    switch iPhoneModel.getCurrentModel() {
    case .iPhone4:
        newFont = iPhone6 * (320.0 / 375.0)
    case .iPhone5:
        newFont = iPhone6 * (320.0 / 375.0)
    case .iPhone6:
        newFont = iPhone6
    case .iPhone6p:
        newFont = iPhone6 * (414.0 / 375.0)
    default:
        newFont = iPhone6 * 1.2
    }
    
    return newFont
}


/// 屏幕宽度, 通过宽高比例判断是否横屏
let SCREEN_WIDTH = UIScreen.main.bounds.width >= UIScreen.main.bounds.height ? UIScreen.main.bounds.height : UIScreen.main.bounds.width

/// 屏幕高度, 通过宽高比例判断是否横屏
let SCREEH_HEIGHT = UIScreen.main.bounds.width >= UIScreen.main.bounds.height ? UIScreen.main.bounds.width : UIScreen.main.bounds.height


/// 手机型号的枚举
enum iPhoneModel {
    case iPhone4
    case iPhone5
    case iPhone6
    case iPhone6p
    case iPad
    
    
    /// 获取当前手机型号
    ///
    /// - Returns: 返回手机型号的枚举值
    static func getCurrentModel() -> iPhoneModel {
        switch  SCREEH_HEIGHT{
        case 480:
            return .iPhone4
        case 568:
            return .iPhone5
        case 667:
            return .iPhone6
        case 736:
            return .iPhone6p
        default:
            return .iPad
        }
    }
}

