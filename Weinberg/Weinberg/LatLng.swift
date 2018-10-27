//
//  LatLng.swift
//  Weinberg
//
//  Created by ema on 22.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import Foundation
import RealmSwift



/*
 * @author Lukas Justen
 * @email lukas.justen@th-bingen.de
 * @version 1.0
 *
 * The RealmObjectModel for an coordinate on the MKMapView. It saves the
 * latitude and longitude as Double
 */
class LatLng: Object {
    
    
    
    // The latitude
    dynamic var lat:Double = 0.0
    // The longitude
    dynamic var lng:Double = 0.0
    
}
