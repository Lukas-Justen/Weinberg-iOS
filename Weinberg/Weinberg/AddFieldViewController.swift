//
//  AddFieldViewController.swift
//  Weinberg
//
//  Created by Student on 14.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import RealmSwift



/*
 *@autor Johannes Strauss
 *@email johannes.a.strauss@th-bingen.de
 *@version 1.0
 *
 * This class handels the adding of a new field. It appears after the User
 * marked the area of the field on the map. He has to enter a name that isn't
 * already used for the Field to finish the procedure.
 * Futher more he can add additional information about the Field suchs as it's Fruit
 * and Treament. 
 * the initional size is being calculated based on the marked area. If the area doesn't fit
 * it's actual size the user can change the size manually.
 */

class AddFieldViewController: UIViewController {

    
    
    // The floating action button that appears if the User entered a valid name
    @IBOutlet weak var fabAdd: UIView!
    // The textfields
    @IBOutlet weak var fieldName: UITextField!
    @IBOutlet weak var treament: UITextField!
    @IBOutlet weak var fruit: UITextField!
    @IBOutlet weak var area: UITextField!
    // The Warninglabel
    @IBOutlet weak var warningLabel: UILabel!
    
    // The instance of the new field
    var newField:Field?
    let realm = try! Realm()
    var button:UIButton?
    
    //When the View appears the displayed area is set to the calculated area of the field
    override func viewWillAppear(_ animated: Bool) {
        area.text = String(describing: newField!.area)
    }
    
    //Adds the field to the database and to the todoList of all operations.
    @IBAction func cancleAddOperation(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToMap", sender: self)
        
        newField?.name = fieldName.text!
        
        if(treament.text != ""){
            newField?.treatment = treament.text!
        }
        if(fruit.text != ""){
            newField?.fruit = fruit.text!
        }
        if(area.text != ""){
            newField?.area = Int64(area.text!)!
        }else{
            newField?.area = 0
        }
        try! realm.write {
            realm.add(newField!)
        }
        
        let operations:Results<Operation> = realm.objects(Operation.self)
        for o in operations {
            try! realm.write {
                o.todo.append(newField!)
            }
        }
    }
    
    //Displays the Folating action Button if a valid name got entered. If the Name is already used in the database a warning labebel is displayed.
    @IBAction func fieldNameChanged(_ sender: UITextField) {
        if(sender.text != "") {
            if(realm.objects(Field.self).filter("name = %@", fieldName.text!).count == 0){
                fabAdd.isHidden = false
                warningLabel.isHidden = true
            }else{
                fabAdd.isHidden = true
                warningLabel.isHidden = false
            }
        } else {
            fabAdd.isHidden = true
            warningLabel.isHidden = true
        }
    }
     
}



/*
 * Hides the keyboard if the return-key is pressed.
 */
extension AddFieldViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
}
