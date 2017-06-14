//
//  AddFieldViewController.swift
//  Weinberg
//
//  Created by Student on 14.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class AddFieldViewController: UIViewController {

    @IBOutlet weak var fabAdd: UIView!
    
    @IBAction func cancleAddOperation(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToField", sender: self)
    }
    
    @IBAction func fieldNameChanged(_ sender: UITextField) {
        if(sender.text == "") {
            fabAdd.isHidden = true
        } else {
            fabAdd.isHidden = false
        }
    }
    
}
