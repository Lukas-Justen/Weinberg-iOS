//
//  Operation.swift
//  Weinberg
//
//  Created by ema on 19.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import Foundation
import RealmSwift



/*
 * @author Lukas Justen
 * @email lukas.justen@th-bingen.de
 * @version 1.0
 *
 * The RealmObjectModel for an operation. It saves necessary information like the name
 * or startdate.
 */
class Operation: Object {
    
    
    
    // The name of the operation
    dynamic var name: String = ""
    // The startdate when the winegrower plans to start with his work
    dynamic var startdate: String?
    // The enddate when the winegrower expects the work to be done
    dynamic var enddate: String?
    // The amount of time you need for this work per hecktar
    dynamic var workingtime: String?
    // The area of fields that is already done
    dynamic var doneArea: Int = 0
    // The list of fields the winegrower still has to do
    var todo: List<Field> = List<Field>()
    // The list of fields which are already done
    var done: List<Field> = List<Field>()
    
    
    
    /*
     * Returns a string-representation of the start- and enddate.
     */
    static func getDateAsString(operation:Operation) -> String {
        var result = ""
        
        if (operation.startdate != nil && operation.startdate != "") {
            result += operation.startdate!
        }
        if (operation.enddate != nil && operation.enddate != "") {
            result += " - " + operation.enddate!
        }
        return result;
    }
    
}
