//
//  DataManager.swift
//  Weinberg
//
//  Created by ema on 23.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import RealmSwift
import CoreLocation



/*
 * @author Lukas Justen
 * @email lukas.justen@th-bingen.de
 * @version 1.0
 *
 * The class DataManager is a Singleton and shares the currentField and the currentOperation.
 */
class DataManager {
    
    
    
    // The operation the MapViewController and the FieldsViewController display.
    var currentOperation:Operation?
    // The map is going to zoom to this field
    var currentField:CLLocationCoordinate2D?
    
    // The connection for the realm-database
    static private let realm = try! Realm()
    // The shared instance of the singleton
    static let shared: DataManager = DataManager()
    
    
    
    // Initializes the currentOperation and currentField with defaultValues.
    private init() {
        self.currentOperation = DataManager.realm.objects(Operation.self).first
        
        let firstField = DataManager.realm.objects(Field.self).first
        if(firstField != nil){
            self.currentField = CLLocationCoordinate2D(latitude: (firstField?.boundaries.first?.lat)!, longitude: (firstField?.boundaries.first?.lng)!)
        }
    }
    
    // If the currentOperation is destroyed by the user a new currentOperations has to be set.
    static func refreshOperation() {
        shared.currentOperation = DataManager.realm.objects(Operation.self).first
    }
    
}
