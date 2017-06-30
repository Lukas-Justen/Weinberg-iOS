//
//  Field.swift
//  Weinberg
//
//  Created by ema on 19.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import Foundation
import RealmSwift

class Field: Object {
    
    dynamic var name: String = ""
    dynamic var treatment: String = ""
    dynamic var fruit: String = ""
    dynamic var area: Int64 = 0
    var boundaries:List<LatLng> = List<LatLng>()
    
}
