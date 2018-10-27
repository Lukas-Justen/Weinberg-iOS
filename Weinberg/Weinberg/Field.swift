//
//  Field.swift
//  Weinberg
//
//  Created by ema on 19.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import Foundation
import RealmSwift



/*
 * @author Johannes Strauß
 * @email johannes.a.strauss@th-bingen.de
 * @version 1.0
 *
 * The RealmObjectModel for a field. It saves necessary information like the name, the
 * fruit or the treatment.
 */
class Field: Object {
    
    
    
    // The name of the field
    dynamic var name: String = ""
    // The type of cultivation
    dynamic var treatment: String = ""
    // The fruit that grows in the field
    dynamic var fruit: String = ""
    // The area of the field in m^2
    dynamic var area: Int64 = 0
    // The list of vertexes of the field
    var boundaries:List<LatLng> = List<LatLng>()
    
}
