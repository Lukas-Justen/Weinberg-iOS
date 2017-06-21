//
//  Operation.swift
//  Weinberg
//
//  Created by ema on 19.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import Foundation
import RealmSwift

class Operation: Object {
    
    dynamic var name: String = ""
    dynamic var startdate: String?
    dynamic var enddate: String?
    dynamic var workingtime: String?
    let todo: List<Field> = List<Field>()
    let done: List<Field> = List<Field>()
    
    func getDateAsString() -> String {
        var result = ""
        
        if (startdate != nil && startdate != "") {
            result += startdate!
        }
        if (enddate != nil && enddate != "") {
            result += " - " + enddate!
        }
        return result;
    }
    
}
