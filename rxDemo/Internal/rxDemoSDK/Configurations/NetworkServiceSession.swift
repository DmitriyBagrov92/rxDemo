//
//  NetowrkServiceSession.swift
//  rxDemo
//
//  Created by DmitriyBagrov on 04/09/2017.
//  Copyright © 2017 DmitriyBagrov. All rights reserved.
//

import Foundation

protocol NetworkServiceSession {
    var token: String { get }
    var httpHeaders: [String: String] { get }
}

