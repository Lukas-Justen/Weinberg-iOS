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
    
    static var formatter = DateFormatter()
    
    dynamic var name: String = ""
    dynamic var startdate: NSDate?
    dynamic var enddate: NSDate?
    let workingtime: Double = 0.0
    let todo: List<Field> = List<Field>()
    let done: List<Field> = List<Field>()
    
    func getDateAsString() -> String {
        var result = ""
        
        Operation.formatter.dateFormat = ("dd.MM.yyy")
        if (startdate != nil) {
            result += Operation.formatter.string(from: startdate! as Date)
        }
        if (enddate != nil) {
            result += " - " + Operation.formatter.string(from: enddate! as Date)
        }
        return result;
    }
    
}
