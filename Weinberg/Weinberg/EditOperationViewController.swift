//
//  EditOperationViewController.swift
//  Weinberg
//
//  Created by Student on 13.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class EditOperationViewController: UIViewController {

    @IBAction func cancleAddOperation(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToOperation", sender: self)
        print("Klappt")
    }
    
}
