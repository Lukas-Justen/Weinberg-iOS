//
//  UISortSegmetedControl.swift
//  Weinberg
//
//  Created by ema on 28.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import Foundation
import UIKit

class UISortSegmentedControl : UISegmentedControl {
    
    var direction: Bool = true
    
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
