//
//  ViewController.swift
//  SYNetWork-Swift
//
//  Created by sunny on 2017/3/29.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cleanBUtton .addTarget(self, action: #selector(clean), for: .touchUpInside)
    }
    
    func clean() {
        HTTPManager.cleanAllCache()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    let bag = DisposeBag()

    @IBOutlet weak var cleanBUtton: UIButton!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        HTTPManager.shared.start(YRequest()).asObservable()
            .map({ (response) -> Response in
                // 在这儿做模型转换
                return response
            })
            .throttle(5, scheduler: MainScheduler.instance)
            .subscribe(
                onNext: {
                    (response) in
                    print("success\(response.content!)")
            },onError: {
                (error) in
                print("error\(error.localizedDescription)")
            },onCompleted: {
                print("complete")
            },onDisposed:{
                print("disposed")
            }).disposed(by: bag)
        
    }

}

