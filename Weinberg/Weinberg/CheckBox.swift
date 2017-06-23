//
//  CheckBox.swift
//  Weinberg
//
//  Created by Student on 14.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import RealmSwift

class CheckBox: UIButton {
    
    let realm = try! Realm()
    var field:Field?
    
    var isChecked: Bool = false{
        didSet{
            if isChecked {
                self.setImage(#imageLiteral(resourceName: "check-mark-8-xxl"), for: UIControlState.normal)
                
                if(field != nil) {
                    try! realm.write {
                        DataManager.shared.currentOperation?.todo.remove(objectAtIndex: (DataManager.shared.currentOperation?.todo.index(of: field!))!)
                        DataManager.shared.currentOperation?.done.append(self.field!)
                        DataManager.shared.currentOperation?.doneArea += (field?.area)!
                    }
                }
            }else{
                self.setImage(#imageLiteral(resourceName: "checkbox-unchecked-th"), for: UIControlState.normal)
                
                if (field != nil && DataManager.shared.currentOperation != nil) {
                    try! realm.write {
                        DataManager.shared.currentOperation!.done.remove(objectAtIndex: (DataManager.shared.currentOperation!.done.index(of: field!))!)
                        DataManager.shared.currentOperation?.todo.append(self.field!)
                        DataManager.shared.currentOperation?.doneArea -= (field?.area)!
                    }
                }
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
