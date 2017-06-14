//
//  EditOperationViewController.swift
//  Weinberg
//
//  Created by Student on 13.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class EditOperationViewController: UIViewController {

    @IBOutlet weak var fabEdit: UIView!
    
    @IBAction func cancleEditOperation(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToOperation", sender: self)
    }
    
    @IBAction func nameOfOperationChanged(_ sender: UITextField) {
        if (sender.text != "") {
            fabEdit.isHidden = false
        } else {
            fabEdit.isHidden = true
        }
    }
    
}
