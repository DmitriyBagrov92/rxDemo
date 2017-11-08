//: Playground - noun: a place where people can play

import UIKit
import RxSwift
import RxCocoa

let one = 1
let two = 2
let three = 3

var obsevable: Observable<Int>?
let keyboardObserver = NotificationCenter.default.addObserver(forName: .UIKeyboardDidChangeFrame, object: nil, queue: nil) { (notification) in
    print("hopa")
}

obsevable?.subscribe(onNext: { (next) in
    print(next)
}, onError: { (error) in
    print("error")
}, onCompleted: {
    print("complete")
}) {
    print("dispose")
}

obsevable = Observable<Int>.of(one, two, three)
