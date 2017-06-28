//
//  DataManager.swift
//  Weinberg
//
//  Created by ema on 23.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

class DataManager {
    
    // The operation the MapViewController and the FieldsViewController display
    var currentOperation:Operation?
    var currentcoordinates:CLLocationCoordinate2D?
    
    static private let realm = try! Realm()
    
    static let shared: DataManager = DataManager()
    
    private init() {
        self.currentOperation = DataManager.realm.objects(Operation.self).first
        
        let firstField = DataManager.realm.objects(Field.self).first
        if(firstField != nil){
            self.currentcoordinates = CLLocationCoordinate2D(latitude: (firstField?.boundaries.first?.lat)!, longitude: (firstField?.boundaries.first?.lng)!)
        }
    }
}
