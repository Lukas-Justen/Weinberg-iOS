//
//  DataManager.swift
//  Weinberg
//
//  Created by ema on 23.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import Foundation
import RealmSwift

class DataManager {
    
    // The operation the MapViewController and the FieldsViewController display
    var currentOperation:Operation?
    
    static private let realm = try! Realm()
    
    static let shared: DataManager = DataManager()
    
    private init() {
        self.currentOperation = DataManager.realm.objects(Operation.self).first
    }
    
}
