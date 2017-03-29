//
//  SYHTTPManager.swift
//  SYNetWork-Swift
//
//  Created by sunny on 2017/3/29.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import Foundation
import ReachabilitySwift
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
                    .responseJSON{ (response) in
                        // 自定义了 request 的情况
                        print(request.decode(response))
                }
            } else {
                req = Alamofire.request(request.url,
                                      method: method,
                                      parameters: request.parameters,
                                      headers: nil)
                    .responseJSON(completionHandler: { (response) in
                        print(request.decode(response))
                    })
            }
            return Disposables.create{
                req?.cancel()
            }
        })
    }
}


private extension HTTPManager {
//    func handle(_ response: DataResponse<Any>, observer: Observable<E>) {
//        
//    }
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
        
//        let reachability = Reachability()!
//        reachability.whenReachable = {[weak self] reachability in
//            self?.isReachability = true
//            DispatchQueue.main.async {
//                if reachability.isReachableViaWiFi {
//                    self?.connectionState = .WIFI
//                } else {
//                    self?.connectionState = .Cellular
//                }
//            }
//        }
//        reachability.whenUnreachable = {[weak self] reachability in
//            self?.isReachability = false
//            DispatchQueue.main.async {
//                self?.connectionState = .NotReachable
//            }
//        }
//        do {
//            try reachability.startNotifier()
//        } catch {}
    }
}
