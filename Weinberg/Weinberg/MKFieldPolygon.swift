//
//  MKFieldPolygon.swift
//  Weinberg
//
//  Created by ema on 28.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import Foundation
import MapKit



/*
 * @author Lukas Justen
 * @email lukas.justen@th-bingen.de
 * @version 1.0
 *
 * The MKFieldPolygon is a custom overlay for the MKMapView and saves further 
 * information to the polygon.
 */
class MKFieldPolygon : MKPolygon {
    
    
    
    // The field which is going to be displayed by this polygon
    var field: Field?
    // todo means red and done means green
    var status: String = ""
    
}
