//
//  SYHTTPManager.swift
//  SYNetWork-Swift
//
//  Created by sunny on 2017/3/29.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import Foundation
import ReachabilitySwift

// 网络状态的枚举
enum ReachabilityStatus {
    case NotReachable
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
    
    
    /// 监听是否联网
    fileprivate(set) var isReachability: Bool = false
    
    /// 监听网络连接状态
    fileprivate(set) var connectionState: ReachabilityStatus = .NotReachable
    
    public func start(_ request: Request!) {
        
        // 1.寻找本地缓存。
        // DO: 有缓存的情况
        // 在这里发起请求
        if (request.request != nil) {
            
        }
        
        
    }
    
}

// MARK: - 网络监听
private extension HTTPManager {
    func startMonitor() {
        let reachability = Reachability()!
        reachability.whenReachable = {[weak self] reachability in
            self?.isReachability = true
            DispatchQueue.main.async {
                if reachability.isReachableViaWiFi {
                    self?.connectionState = .WIFI
                } else {
                    self?.connectionState = .Cellular
                }
            }
        }
        reachability.whenUnreachable = {[weak self] reachability in
            self?.isReachability = false
            DispatchQueue.main.async {
                self?.connectionState = .NotReachable
            }
        }
        do {
            try reachability.startNotifier()
        } catch {}
    }
}
