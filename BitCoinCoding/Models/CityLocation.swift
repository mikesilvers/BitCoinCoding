//
//  CityLocation.swift
//  BitCoinCoding
//
//  Created by Mike Silvers on 5/29/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import RealmSwift
import Foundation

class CityLocation: Object {
    @objc dynamic var id        = 0
    @objc dynamic var name      = ""
    @objc dynamic var country   = ""
    @objc dynamic var latitude  = 0.0
    @objc dynamic var longitude = 0.0
}
