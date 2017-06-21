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
    
    // The name of the operation
    dynamic var name: String = ""
    // The startdate when the winegrower plans to start with his work
    dynamic var startdate: String?
    // The enddate when the winegrower expects the work to be done
    dynamic var enddate: String?
    // The amount of time you need for this work per hecktar
    dynamic var workingtime: String?
    // The list of fields the winegrower still has to do
    let todo: List<Field> = List<Field>()
    // The list of fields which are ready
    let done: List<Field> = List<Field>()
    
    
    /*
     * Returns a representation of the start- and enddate
     */
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
