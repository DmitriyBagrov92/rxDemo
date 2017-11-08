
//
//  UIApplication+Rx.swift
//  RxCocoa
//
//  Created by Mads Bøgeskov on 18/01/16.
//  Copyright © 2016 Krunoslav Zaher. All rights reserved.
//
import Foundation

import RxSwift
import RxCocoa

extension Reactive where Base: UIApplication {
    
    public var isNetworkActivityIndicatorVisible: UIBindingObserver<Base, Bool> {
        return UIBindingObserver(UIElement: self.base) { application, active in
            application.isNetworkActivityIndicatorVisible = active
        }
    }
    
}
