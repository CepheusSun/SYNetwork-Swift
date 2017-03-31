//
//  SYHTTPManager.swift
//  SYNetWork-Swift
//
//  Created by sunny on 2017/3/29.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import Foundation
import Alamofire
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
            if request.cacheTimeInterval > 0 {
                let data = Cache.shared.fetch(for: request)
                if data != nil {
                    observer.onNext(Response(data, fromcache: true))
                    print("fetched from cache")
                    observer.onCompleted()
                    // 获取到缓存， 取消请求
                    return Disposables.create{}
                }
            }
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
                        if response.error != nil {
                            observer.onError(response.error!)
                            observer.onCompleted()
                        }
                        let resp = Response(response.data!, fromcache: false)
                        if (resp.error != nil) {
                            observer.onError(resp.error!)
                        } else {
                            DispatchQueue.main.async {
                                Cache.shared.save(Response.init(response.data, fromcache: false).data, for: request)
                                observer.onNext(resp)
                                observer.onCompleted()
                            }
                        }
                    })
            } else {
                req = Alamofire.request("\(request.url!)\(request.path!))",
                                      method: method,
                                      parameters: request.remakeParam())
                    .response(completionHandler: { (response) in
                        
                        if response.error != nil {
                            observer.onError(response.error!)
                            observer.onCompleted()
                        }
                        let resp = Response(response.data!, fromcache: false)
                        if (resp.error != nil) {
                            observer.onError(resp.error!)
                        } else {
                            DispatchQueue.main.async {
                                Cache.shared.save(response.data, for: request)
                                observer.onNext(resp)
                                observer.onCompleted()
                            }
                        }
                    })
            }
            return Disposables.create{
                req?.cancel()
            }
        })
    }
}

extension HTTPManager {
    public class func cleanAllCache() {
        Cache.shared.clean()
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
}
