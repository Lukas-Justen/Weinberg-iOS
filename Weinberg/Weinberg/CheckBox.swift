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
                        OperationsViewController.currentOperation?.todo.remove(objectAtIndex: (OperationsViewController.currentOperation?.todo.index(of: field!))!)
                        OperationsViewController.currentOperation?.done.append(self.field!)
                        OperationsViewController.currentOperation?.doneArea += (field?.area)!
                    }
                }
            }else{
                self.setImage(#imageLiteral(resourceName: "checkbox-unchecked-th"), for: UIControlState.normal)
                
                if (field != nil && OperationsViewController.currentOperation != nil) {
                    try! realm.write {
                        OperationsViewController.currentOperation!.done.remove(objectAtIndex: (OperationsViewController.currentOperation!.done.index(of: field!))!)
                        OperationsViewController.currentOperation?.todo.append(self.field!)
                        OperationsViewController.currentOperation?.doneArea -= (field?.area)!
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
