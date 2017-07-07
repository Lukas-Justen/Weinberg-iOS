//
//  OperationsVCRTableViewdelegate.swift
//  Weinberg
//
//  Created by ema on 30.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import RealmSwift



/*
 * @author Lukas Justen
 * @email lukas.justen@th-bingen.de
 * @version 1.0
 *
 * This extension for OperationsViewController handles swipe events in order to delete
 * or edit specific operations. Furthermore it returns the number of cells going to be
 * displayed or initializes the UIViews within the OperationDetailCell. Finally it handles
 * click-events on the cells.
 */
class OperationsVCRTableViewDelegate : NSObject, UITableViewDelegate, UITableViewDataSource {
    
    
    
    // The sum of the area of all fields
    var sumOfArea: String = ""
    // The RealmInstance in order to access the database
    let realm = try! Realm()
    // The list of all operations this UIViewController displays
    var operationList: Results<Operation>?
    // The navigationController for opening the EditOperationViewController
    let navbarController: UINavigationController
    // The tabbarController for switching to the map
    let tabbarController: UITabBarController
    
    
    
    /*
     * Initializes the DataSource, the NavigationController and the TabbarController in order to display all operations
     */
    init(operationList:Results<Operation>, navbarController: UINavigationController, tabbarController: UITabBarController) {
        self.operationList = operationList
        self.navbarController = navbarController
        self.tabbarController = tabbarController
    }
    
    /*
     * Returns the number of rows displayed by the UITableView.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        computeArea()
        if (operationList != nil) {
            return (operationList?.count)!
        }
        return realm.objects(Operation.self).count
    }
    
    /*
     * Creates an empty OperationDetailCell and fills the labels within the cell with the correct data.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let operation = operationList![indexPath.row]
        let cellIdentifier = "OperationDetailCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! OperationDetailCell
        
        cell.labelName.text = operation.name
        cell.labelDate.text = Operation.getDateAsString(operation:operation)
        
        if (operation.todo.count > 0) {
            cell.labelDone.text = String(format: "%.2f", Double(operation.doneArea) / 10000.0)
            cell.labelAll.text = sumOfArea
            cell.labelDone.isHidden = false
            cell.labelAll.isHidden = false
            cell.labelSlash.isHidden = false
            cell.imageDone.isHidden = true
        } else {
            cell.labelDone.isHidden = true
            cell.labelAll.isHidden = true
            cell.labelSlash.isHidden = true
            cell.imageDone.isHidden = false
        }
        cell.viewBackground.layer.shadowColor = UIColor.black.cgColor
        cell.viewBackground.layer.shadowOpacity = 0.2
        cell.viewBackground.layer.shadowOffset = CGSize.init(width: -1, height: 1)
        cell.viewBackground.layer.shadowRadius = 1
        cell.accessibilityIdentifier = "OperationCell"
        
        return cell
    }
    
    /*
     * Handles swipe-events and the editing or deleting of the selected operation.
     */
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Editieren", handler: {(action,indexPath) in
            let o:Operation = self.operationList![indexPath.row]
            let storyBoard: UIStoryboard = UIStoryboard(name:"Operation",bundle:nil)
            let editController : EditOperationViewController = storyBoard.instantiateViewController(withIdentifier: "EditOperation") as! EditOperationViewController
            editController.operation = o
            self.navbarController.pushViewController(editController, animated: true)
        })
        editAction.backgroundColor = UIColor.orange
        
        if (self.realm.objects(Operation.self).count > 1) {
            let deleteAction = UITableViewRowAction(style: .default, title: "Löschen", handler: {(action,indexPath) in
                try! self.realm.write {
                    let operation:Operation = self.operationList![indexPath.row]
                    if (DataManager.shared.currentOperation == operation) {
                        DataManager.shared.currentOperation = nil
                    }
                    self.realm.delete(operation)
                    DataManager.refreshOperation()
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
            })
            deleteAction.backgroundColor = UIColor.red
            return [deleteAction, editAction]
        }
        
        return [editAction]
    }
    
    /*
     * Handles clicks on the OperationDetailCell
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DataManager.shared.currentOperation = self.operationList![indexPath.row]
        self.tabbarController.selectedIndex = 1
    }
    
    /*
     * Computes the area of all fields and returns a string-representation
     */
    func computeArea() {
        let fields:Results<Field> = realm.objects(Field.self)
        var area:Int64 = 0
        for f in fields {
            area += f.area
        }
        sumOfArea = String(format:"%.2f", Double(area) / 10000.0)
    }

}
