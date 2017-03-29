//
//  SYHTTPManager.swift
//  SYNetWork-Swift
//
//  Created by sunny on 2017/3/29.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import Foundation
import Alamofire
import RxCocoa
import RxSwift
// 网络状态的枚举

enum ReachabilityStatus {
    case NotReachable
    case NotKnown
    case Cellular
    case WIFI
}


final class HTTPManager: NSObject {
    
    /// 单例方法
    static let shared = HTTPManager()
    
    private override init() {
        super.init()
        self.startMonitor()
    }
    
    /// 监听网络连接状态
    fileprivate(set) var connectionState: ReachabilityStatus = .NotKnown
    
    public func start(_ request: Request!) -> Observable<Response>{
        
        return Observable.create({ [weak self] (observer) -> Disposable in
            
            // 1.寻找本地缓存。
            // TO: 有缓存的情况
            // 在这里发起请求
            if self?.connectionState == .NotReachable {// 网络不可用
                // 返回失败的 error
                observer.onError(NSError(domain: "网络不可用", code: -1024, userInfo: nil))
            }
            var method: HTTPMethod = .get
            switch request.requestType {
            case .get:
                method = .get
            case .post:
                method = .post
            }
            let req: DataRequest?
            if (request.request != nil) {
                req = Alamofire.request(request.request! as! URLRequestConvertible)
                    .response(completionHandler: { (response) in
                        // 解码
                        
                    })
            } else {
                req = Alamofire.request(request.url,
                                      method: method,
                                      parameters: request.parameters)
                    .response(completionHandler: { (response) in
                        // 解码
                        
                    })

            }
            return Disposables.create{
                req?.cancel()
            }
        })
    }
}

// MARK: - 网络监听
private extension HTTPManager {
    func startMonitor() {
        
        let manager = NetworkReachabilityManager.init()
        manager?.listener = { [weak self] status in
            switch status {
            case .unknown:
                self?.connectionState = .NotKnown
            case .notReachable:
                self?.connectionState = .NotReachable
            case .reachable(let inStatus):
                switch inStatus {
                case .ethernetOrWiFi:
                    self?.connectionState = .WIFI
                case .wwan:
                    self?.connectionState = .Cellular
                }
            }
        }
        manager?.startListening()
    }
    
    
    /*
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
     */
    
//    func deviceNetworkType() -> Void {
//        let application = UIApplication.shared
//        let subviews = ((application.value(forKey: "statusBar") as! UIView).value(forKey: "foregroundView") as! UIView).subviews
//        
//        let dataNetworkItemView = subviews.filter { (subview) -> Bool in
//            
//        }
//        
//    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
