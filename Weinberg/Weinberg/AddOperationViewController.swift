//
//  AddOperationViewController.swift
//  Weinberg
//
//  Created by Student on 09.06.17.
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
 * The class AddOperationViewController handles the user-interaction in order to add a new
 * operation. The class recognizes wether the user has entered a name for the operation. Thus,
 * the class hides or shows the FloatingActionButton in order to save the new operation.
 */
class AddOperationViewController: UIViewController {

    // The UIElements
    @IBOutlet weak var fabAdd: UIView!
    @IBOutlet weak var startdate: UILabel!
    @IBOutlet weak var workingTime: UILabel!
    @IBOutlet weak var enddate: UILabel!
    @IBOutlet weak var operationName: UITextField!
    @IBOutlet weak var labelWarning: UILabel!
    
    let formatter = DateFormatter()
    
    // The RealmInstance in order to access the database
    let realm = try! Realm()
    
    
    /*
     * Performs an unwind-segue to the OperationsViewController.
     */
    @IBAction func cancleAddOperation(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToOperation", sender: self)
        let newOperation: Operation = Operation()
        newOperation.name = operationName.text!
        newOperation.startdate = (startdate.text?.hasPrefix("z.B."))! ? nil : startdate.text!
        newOperation.enddate = (enddate.text?.hasPrefix("z.B."))! ? nil : enddate.text!
        newOperation.workingtime = (workingTime.text?.hasPrefix("z.B."))! ? nil : workingTime.text!
        try! realm.write {
            realm.add(newOperation)
        }
        NotificationCenter.default.post(name: .update, object: nil)
    }
    
    /*
     * Recognizes changes in the UITextField for the name of the operation and hides or shows
     * the FloatingActionButton
     */
    @IBAction func nameOfOperationChanged(_ sender: UITextField) {
        if (sender.text != "") {
            if (realm.objects(Operation.self).filter("name = %@", operationName.text!).count == 0) {
                fabAdd.isHidden = false
                labelWarning.isHidden = true
            } else {
                fabAdd.isHidden = true
                labelWarning.isHidden = false
            }
        } else {
            fabAdd.isHidden = true
            labelWarning.isHidden = true
        }
    }
    
    /*
     * Shows a DatePickerDialog in order to give the user the opportunity of choosing a new startdate for the operation he is creating right now.
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
     * Shows a DatePickerDialog in order to give the user the opportunity of choosing a new enddate for the operation he is creating right now.
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
