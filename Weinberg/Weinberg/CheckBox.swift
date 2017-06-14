//
//  CheckBox.swift
//  Weinberg
//
//  Created by Student on 14.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    
    var isChecked: Bool = false{
        didSet{
            if isChecked {
                self.setImage(#imageLiteral(resourceName: "check-mark-8-xxl"), for: UIControlState.normal)
            }else{
                self.setImage(#imageLiteral(resourceName: "checkbox-unchecked-th"), for: UIControlState.normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)),for: UIControlEvents.touchUpInside)
        isChecked = false
    }
    
    func buttonClicked(sender: UIButton){
        if sender == self{
            isChecked = !isChecked
        }
    }
}
