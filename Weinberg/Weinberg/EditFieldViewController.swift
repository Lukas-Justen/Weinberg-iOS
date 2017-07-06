//
//  EditFieldViewController.swift
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
 * This class handels the editing of a field.
 * Appart from displaying alread prsent information it works just like the addField
 * ViewController.
 */

class EditFieldViewController: UIViewController {

    
    @IBOutlet weak var labelWarning: UILabel!
    @IBOutlet weak var nameEdit: UITextField!
    @IBOutlet weak var fabEdit: UIView!
    @IBOutlet weak var treamentEdit: UITextField!
    @IBOutlet weak var fruitEdit: UITextField!
    @IBOutlet weak var areaEdit: UITextField!
    
    let realm = try! Realm()
    var field : Field?
    
    override func viewDidLoad() {
        if(field != nil){
            nameEdit.text = field!.name
            treamentEdit.text = field!.treatment
            fruitEdit.text = field!.fruit
            areaEdit.text = "\(field!.area)"
        }
    }
    
    
    @IBAction func editFieldCancled(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToField", sender: self)
        try! realm.write {
            field?.name = nameEdit.text!
            field?.treatment = treamentEdit.text!
            field?.fruit = fruitEdit.text!
            let results = realm.objects(Operation.self)
            for operation in results {
                if (operation.done.contains(field!)) {
                    operation.doneArea += -(field?.area)! + Int64(areaEdit.text!)!
                }
            }
            field?.area = Int64(areaEdit.text!)!
        }
    }
    
    @IBAction func NameChange(_ sender: UITextField) {
        if (sender.text != "") {
            if (realm.objects(Field.self).filter("name = %@", nameEdit.text!).count == 0 || field?.name == nameEdit.text) {
                fabEdit.isHidden = false
                labelWarning.isHidden = true
            } else {
                fabEdit.isHidden = true
                labelWarning.isHidden = false
            }
        } else {
            fabEdit.isHidden = true
            labelWarning.isHidden = true
        }
    }
}



/*
 * Hides the keyboard if the return-key is pressed.
 */
extension EditFieldViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
}
