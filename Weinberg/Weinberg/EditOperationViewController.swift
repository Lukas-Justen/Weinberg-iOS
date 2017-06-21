//
//  EditOperationViewController.swift
//  Weinberg
//
//  Created by Student on 13.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import DatePickerDialog
import RealmSwift

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
    
    // The UIElements
    @IBOutlet weak var fabEdit: UIView!
    @IBOutlet weak var operationName: UITextField!
    @IBOutlet weak var startdate: UILabel!
    @IBOutlet weak var enddate: UILabel!
    @IBOutlet weak var workingTime: UILabel!
    @IBOutlet weak var labelWarning: UILabel!
    
    let formatter = DateFormatter()
    
    // The RealmInstance in order to access the database
    let realm = try! Realm()
    var operation: Operation?
    
    /*
     * Initializes the inputFields with the values of the operation the user wants to edit
     */
    override func viewDidLoad() {
        operationName.text = operation?.name
        if (operation?.startdate != nil && operation?.startdate != "") {
            startdate.text = operation?.startdate
            startdate.textColor = UIColor.darkText
        }
        if (operation?.enddate != nil && operation?.enddate != "") {
            enddate.text = operation?.enddate
            enddate.textColor = UIColor.darkText
        }
        if (operation?.workingtime != nil && operation?.workingtime != "") {
            workingTime.text = operation?.workingtime
            workingTime.textColor = UIColor.darkText
        }
    }
    
    /*
     * Performs an unwind-segue to the OperationsViewController and saves the changes in the realm-database.
     */
    @IBAction func cancleEditOperation(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToOperation", sender: self)
        try! realm.write {
            operation?.name = operationName.text!
            operation?.startdate = (startdate.text?.hasPrefix("z.B."))! ? nil : startdate.text!
            operation?.enddate = (enddate.text?.hasPrefix("z.B."))! ? nil : enddate.text!
            operation?.workingtime = (workingTime.text?.hasPrefix("z.B."))! ? nil : workingTime.text!
        }
        NotificationCenter.default.post(name: .update, object: nil)
    }
    
    /*
     * Recognizes changes in the UITextField for the name of the operation and hides or shows
     * the FloatingActionButton.
     */
    @IBAction func nameOfOperationChanged(_ sender: UITextField) {
        if (sender.text != "") {
            if (realm.objects(Operation.self).filter("name = %@", operationName.text!).count == 0 || operation?.name == operationName.text) {
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
    
    /*
     * Shows a DatePickerDialog in order to give the user the opportunity of choosing a new startdate for the operation he is editing right now.
     */
    @IBAction func startdateTapped(_ sender: Any) {
        DatePickerDialog().show(title: "Startdatum auswählen", doneButtonTitle: "Fertig", cancelButtonTitle: "Abbrechen", datePickerMode: .date) {
            (date) -> Void in
            self.formatter.dateFormat = "dd.MM.yyyy"
            self.startdate.text = self.formatter.string(from: date!)
            self.startdate.textColor = UIColor.darkText
        }
    }
    
    /*
     * Shows a DatePickerDialog in order to give the user the opportunity of choosing a new enddate for the operation he is editing right now.
     */
    @IBAction func enddateTapped(_ sender: Any) {
        DatePickerDialog().show(title: "Enddatum auswählen", doneButtonTitle: "Fertig", cancelButtonTitle: "Abbrechen", datePickerMode: .date) {
            (date) -> Void in
            self.formatter.dateFormat = "dd.MM.yyyy"
            self.enddate.text = self.formatter.string(from: date!)
            self.enddate.textColor = UIColor.darkText
        }
    }
    
    /*
     * Shows a DatePickerDialog in order to give the user the opportunity of choosing a new workingTime for the operation he is creating right now.
     * The user can select hours and minutes.
     */
    @IBAction func workingTimeTapped(_ sender: Any) {
        DatePickerDialog().show(title: "WorkingTime auswählen", doneButtonTitle: "Fertig", cancelButtonTitle: "Abbrechen", datePickerMode: .countDownTimer) {
            (time) -> Void in
            self.formatter.dateFormat = "HH:mm"
            self.workingTime.text = self.formatter.string(from: time!)
            self.workingTime.textColor = UIColor.darkText
        }
    }
    
}
