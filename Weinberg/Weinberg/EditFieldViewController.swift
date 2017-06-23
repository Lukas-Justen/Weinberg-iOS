//
//  EditFieldViewController.swift
//  Weinberg
//
//  Created by Student on 14.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import RealmSwift

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
            field?.treatment = nameEdit.text!
            field?.fruit = fruitEdit.text!
            field?.area = Int(areaEdit.text!)!
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
