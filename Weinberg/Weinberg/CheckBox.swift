//
//  CheckBox.swift
//  Weinberg
//
//  Created by Student on 14.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import RealmSwift

/*
 *
 *@autor Johannes Strauss
 *@email johannes.a.strauss@th-bingen.de
 *@version 1.0
 *
 * The Checkbox is CustomButton, that works just like a CheckBox.
 * It's used to display the status of a Field in the Fieldlist.
 * The class also handels the Database entry when a checkbox gets clicked.
 */

class CheckBox: UIButton {
    
    //The realmInstance
    let realm = try! Realm()
    //The Field related to the checkbox
    var field:Field?
    /*
     * Whenever the status isChecked changes the image of the button gets changed and the
     * DataBase gets update accordingly.
     */
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
    //awakes the nib.s
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)),for: UIControlEvents.touchUpInside)
        isChecked = false
    }
    
    //When the chickbox is clicked the checked status gets negate
    func buttonClicked(sender: UIButton){
        if sender == self{
            isChecked = !isChecked
        }
    }
    
}
