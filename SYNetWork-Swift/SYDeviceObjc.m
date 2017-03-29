//
//  SYDeviceObjc.m
//  SYNetWork-Swift
//
//  Created by sunny on 2017/3/29.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

#import "SYDeviceObjc.h"

@implementation SYDeviceObjc

+ (NSNumber *)getDeviceNetworkType {
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    NSNumber *netType;
    NSNumber * num = [dataNetworkItemView valueForKey:@"dataNetworkType"];
    if (num == nil)
    {
        netType = [NSNumber numberWithInt:0];
    }
    else
    {
        int n = [num intValue];
        if (n == 0)
        {
            netType = [NSNumber numberWithInt:0];
        }
        else if (n == 1)
        {
            netType = [NSNumber numberWithInt:1];
        }
        else if (n == 2)
        {
            netType = [NSNumber numberWithInt:2];
        }
        else if (n == 3)
        {
            netType = [NSNumber numberWithInt:3];
        }
        else
        {
            netType = [NSNumber numberWithInt:4];
        }
    }
    //0 - 无网络; 1 - 2G; 2 - 3G; 3 - 4G; 4 - WIFI
    return netType;
}

@end
