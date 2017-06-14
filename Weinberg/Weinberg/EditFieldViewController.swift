//
//  EditFieldViewController.swift
//  Weinberg
//
//  Created by Student on 14.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class EditFieldViewController: UIViewController {

    
    @IBOutlet weak var fabEdit: UIView!
    
    @IBAction func editFieldCancled(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToField", sender: self)
    }
    
    @IBAction func NameChange(_ sender: UITextField) {
        if(sender.text != ""){
            fabEdit.isHidden = false
        }else{
            fabEdit.isHidden = true
        }        
    }

}
