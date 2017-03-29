//
//  SYDeviceObjc.h
//  SYNetWork-Swift
//
//  Created by sunny on 2017/3/29.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

#import <UIKit/UIKit.h>

// 没办法,用swift 取秒挂
@interface SYDeviceObjc : NSObject

+ (NSNumber *)getDeviceNetworkType;
@end
