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
    @IBOutlet weak var warningLabel: UILabel!
    
    var newField:Field?
    let realm = try! Realm()
    
    @IBAction func cancleAddOperation(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToMap", sender: self)
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
        if(sender.text != "") {
            if(realm.objects(Field.self).filter("name = %@", fieldName.text!).count == 0){
                print("fab should be NOT hidden")
                print("warning should be hidden")
                fabAdd.isHidden = false
                warningLabel.isHidden = true
            }else{
                print("fab should be hidden")
                print("warning should be hidden")
                fabAdd.isHidden = true
                warningLabel.isHidden = false
            }
        } else {
            print("both shoud be hidden")
            fabAdd.isHidden = true
            warningLabel.isHidden = true
        }
    }
}
