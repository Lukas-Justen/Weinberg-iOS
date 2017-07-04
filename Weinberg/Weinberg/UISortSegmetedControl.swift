//
//  UISortSegmetedControl.swift
//  Weinberg
//
//  Created by ema on 28.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit



/*
 * @author Lukas Justen
 * @email lukas.justen@th-bingen.de
 * @version 1.0
 *
 * The UISortSegmentedControl recognizes touch-Events on an already selected segment
 * in order to sort the tableView by the given criteria reverse.
 */
class UISortSegmentedControl : UISegmentedControl {
    
    
    
    // Saves the current sortDirection
    var direction: Bool = true
    
    
    
    // Handles taps on the segments of the UISortSegmentedControl
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let oldValue:Int = self.selectedSegmentIndex
        super.touchesBegan(touches, with: event)
        if (oldValue == self.selectedSegmentIndex) {
            direction = !direction
            sendActions(for: UIControlEvents.valueChanged)
        } else {
            if (self.selectedSegmentIndex == 0) {
                direction = true
            } else {
                direction = false
            }
        }
    }
    
}
