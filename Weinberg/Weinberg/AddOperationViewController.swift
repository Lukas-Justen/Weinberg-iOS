//
//  AddOperationViewController.swift
//  Weinberg
//
//  Created by Student on 09.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class AddOperationViewController: UIViewController {

    @IBOutlet weak var fabAdd: UIView!
    
    @IBAction func cancleAddOperation(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToOperation", sender: self)
    }
    
    @IBAction func nameOfOperationChanged(_ sender: UITextField) {
        if (sender.text != "") {
            fabAdd.isHidden = false
        } else {
            fabAdd.isHidden = true
        }
    }
    
}
