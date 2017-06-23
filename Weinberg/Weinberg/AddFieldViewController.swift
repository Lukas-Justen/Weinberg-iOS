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
    
    override func viewWillAppear(_ animated: Bool) {
        area.text = String(describing: newField!.area)
    }
    
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
            newField?.area = Int(area.text!)!
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
