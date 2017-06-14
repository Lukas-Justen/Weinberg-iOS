//
//  EditOperationViewController.swift
//  Weinberg
//
//  Created by Student on 13.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

/*
 * @author Lukas Justen
 * @email lukas.justen@th-bingen.de
 * @version 1.0
 *
 * The class EditOperationViewController handles the user-interaction in order to edit an
 * operation. The class recognizes wether the user has entered a name for the operation. Thus,
 * the class hides or shows the FloatingActionButton in order to save the changes for the operation.
 */
class EditOperationViewController: UIViewController {
    
    // The FloatingActionButton for saving the input
    @IBOutlet weak var fabEdit: UIView!
    
    /*
     * Performs an unwind-segue to the OperationsViewController.
     */
    @IBAction func cancleEditOperation(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToOperation", sender: self)
    }
    
    /*
     * Recognizes changes in the UITextField for the name of the operation and hides or shows
     * the FloatingActionButton.
     */
    @IBAction func nameOfOperationChanged(_ sender: UITextField) {
        if (sender.text != "") {
            fabEdit.isHidden = false
        } else {
            fabEdit.isHidden = true
        }
    }
}
