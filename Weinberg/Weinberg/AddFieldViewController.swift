//
//  AddFieldViewController.swift
//  Weinberg
//
//  Created by Student on 14.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import RealmSwift

class AddFieldViewController: UIViewController {

    @IBOutlet weak var fabAdd: UIView!
    @IBOutlet weak var fieldName: UITextField!
    @IBOutlet weak var treament: UITextField!
    @IBOutlet weak var fruit: UITextField!
    @IBOutlet weak var area: UITextField!
    
    let realm = try! Realm()
    
    @IBAction func cancleAddOperation(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToField", sender: self)
        let newField : Field = Field()
        
        newField.name = fieldName.text!
        
        if(treament.text != ""){
            newField.treatment = treament.text!
        }
        if(fruit.text != ""){
            newField.fruit = fruit.text!
        }
        if(area.text != ""){
            newField.area = Double(area.text!)!
        }else{
            newField.area = 0
        }
        try! realm.write {
            realm.add(newField)
        }
        NotificationCenter.default.post(name: .update, object: nil)
    }
    
    @IBAction func fieldNameChanged(_ sender: UITextField) {
        if(sender.text == "") {
            fabAdd.isHidden = true
        } else {
            fabAdd.isHidden = false
        }
    }
}
