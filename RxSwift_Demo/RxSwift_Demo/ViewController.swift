//
//  ViewController.swift
//  RxSwift_Demo
//
//  Created by company_2 on 2019/7/22.
//  Copyright © 2019 dyoung. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textFiled: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!

    let disposeBag = DisposeBag()
    var person = Person()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupScrollView()
        setupTextField()
        setupBtn()
        setupGesture()
        
//        setKVO()
//        setupNotify()
//        setTimer()
//        setupNextwork()

        //
        basicToSubscribe()

        
    }
    
    //控件测试类。
    //1-1:scrollView
    func setupScrollView() {
         scrollView.rx.contentOffset
            .subscribe(onNext: {(content) in
                print("移动距离为：\(content.y)")
            })
            .disposed(by:disposeBag)
    }
    //1-2。textField
    func setupTextField(){
        textFiled.rx.text.subscribe(onNext: { (context) in
            print("当前字 == \(String(describing: context))")
        }).disposed(by: disposeBag)
    }
    //1-3。button
    func setupBtn() {
        button.rx.tap.subscribe(onNext: { (content) in
            print("点击了按钮\(content)");//content为空。
        })
        .disposed(by: disposeBag)
        
        button.rx.controlEvent(UIControl.Event.touchUpInside)
            .subscribe(onNext: { (content) in
                print("自定义手势事件")
            })
        .disposed(by: disposeBag)
    }
    //1-4。手势
    func setupGesture() {
        let tap = UITapGestureRecognizer()
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        tap.rx.event.subscribe(onNext: { (tap) in
//            print(tap.view ?? default value)
        })
            .disposed(by: disposeBag)
    }
    
    
    //2-1 KVO
    func setKVO() {
        person.rx.observeWeakly(String.self, "name")
            .subscribe(onNext: { (content) in
                print(content as Any)
            })
           .disposed(by: disposeBag)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        person.name = "\(person.name) 88 "
    }
    
    
    //2-2 notification
    func setupNotify(){
        //监听键盘弹出。
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .subscribe(onNext: { (noti) in
                print("键盘弹出啦：\(noti)")
            })
            .disposed(by: disposeBag)
    }
    
    //2-3 定时器
    func setTimer() {
        var timer: Observable<Int>!
        timer = Observable<Int>.interval(2, scheduler: MainScheduler.instance)
        timer.subscribe(onNext: { (num) in
            print(num)
        }).disposed(by: disposeBag);
    }
    //2-4 网络请求
    func setupNextwork() {
//        let url = URL(string: "http://api.avatardata.cn/Weather/Query?key=e6c9652f6dda418686f7be8c7e2002ca&cityname=武汉")
        let url = URL(string: "https://www.baidu.com")
        URLSession.shared.rx.response(request: URLRequest(url: url!))
            .subscribe(onNext: { (response,data) in
                print("请求下来的数据是：")
            }).disposed(by: disposeBag)
    }
    
    
    //3-1 实现原理探究。
    func basicToSubscribe()  {
        
        // UI -> target - event
        // 1:创建序列
        // AnonymousObservable -> producer.subscriber -> run
        // 保存闭包  - 函数式 保存 _subscribeHandler
        let ob = Observable<Any>.create { (obserber) -> Disposable in
            // 3:发送信号
            obserber.onNext("发送了信息")
            obserber.onCompleted()
            //            obserber.onError(NSError.init(domain: "coocieeror", code: 10087, userInfo: nil))
            return Disposables.create()
        }
        
        // 2:订阅信号
        // AnonymousObserver  - event .next -> onNext()
        // _eventHandler
        // AnonymousObservable._subscribeHandler(observer)
        // 销毁
        let _ = ob.subscribe(onNext: { (text) in
            print("订阅到:\(text)")
        }, onError: { (error) in
            print("error: \(error)")
        }, onCompleted: {
            print("完成")
        }) {
            print("销毁")
        }
    }
}


