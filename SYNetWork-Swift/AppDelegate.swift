//
//  AppDelegate.swift
//  SYNetWork-Swift
//
//  Created by sunny on 2017/3/29.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let bag = DisposeBag()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        HTTPManager.shared.start(DRequest()).asObservable()
            .map({ (response) -> Response in
                response.name = "aaa"
                return response
            }).subscribe(
                onNext: {
                    (response) in
                    print("success\(response.name ?? "no name")")
            },onError: {
                (error) in
                print("error")
            },onCompleted: {
                print("complete")
            },onDisposed:{
                print("disposed")
            }).addDisposableTo(bag)
        return true
    }

}

