//
//  OperationTableViewController.swift
//  Weinberg
//
//  Created by Student on 02.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import RealmSwift



/*
 * @author Lukas Justen
 * @email lukas.justen@th-bingen.de
 * @version 1.0
 *
 * The class OperationsViewController is responsible for filling the cells of the UITableView with
 * operations. The user has the opportunity to search for specific operations or sort the list of
 * operations by the name or their status. Furthermore, by clicking on a cell the ViewController
 * switches to the MapViewController and presents the operation graphically. You can edit or delete
 * operations by swiping over the cell.
 */
class OperationsViewController: UIViewController {


    
    // The UITableView which shows all operations
    @IBOutlet weak var operationTable: UITableView!
    // The searchBar for searching specific operations
    @IBOutlet weak var operationSearchBar: UISearchBar!
    
    // The RealmInstance in order to access the database
    let realm = try! Realm()
    
    // The list of all operations this UIViewController displays
    var operationList: Results<Operation>?
    // The sort and search criteria
    var sortOperationsBy: Int = 0
    var sortDirection:Bool = true
    var searchForOperations: String = ""
    // The sum of the area of all fields
    var sumOfArea: String = ""

    
    
    /*
     * Creates an empty UIView for the header and footer in the UITableView. Furthermore, it fills the list
     * of operations when starting the app for the first time.
     */
    override func viewDidLoad() {
        operationTable.tableHeaderView = UIView()
        operationTable.tableFooterView = UIView()
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if !launchedBefore {
            try! realm.write {
                realm.add(Operation(value: ["name" : "Grubbern 3", "startdate": "21.06.2017", "enddate":"26.06.2017"]))
                realm.add(Operation(value: ["name" : "Grubbern 4", "startdate": "21.06.2017", "enddate":"26.06.2017"]))
                realm.add(Operation(value: ["name" : "Grubbern 5", "startdate": "21.06.2017", "enddate":"26.06.2017"]))
                realm.add(Operation(value: ["name" : "Heften 1", "startdate": "21.06.2017", "enddate":"26.06.2017"]))
                realm.add(Operation(value: ["name" : "Heften 2", "startdate": "21.06.2017", "enddate":"26.06.2017"]))
                realm.add(Operation(value: ["name" : "Heften 3", "startdate": "21.06.2017", "enddate":"26.06.2017"]))
                realm.add(Operation(value: ["name" : "Laub schneiden", "startdate": "21.06.2017", "enddate":"26.06.2017"]))
                realm.add(Operation(value: ["name" : "Schneiden", "startdate": "21.06.2017", "enddate":"26.06.2017"]))
                realm.add(Operation(value: ["name" : "Spritzen 1", "startdate": "21.06.2017", "enddate":"26.06.2017"]))
                realm.add(Operation(value: ["name" : "Spritzen 2", "startdate": "21.06.2017", "enddate":"26.06.2017"]))
                realm.add(Operation(value: ["name" : "Spritzen 3", "startdate": "21.06.2017", "enddate":"26.06.2017"]))
                realm.add(Operation(value: ["name" : "Ausbessern", "startdate": "21.06.2017", "enddate":"26.06.2017"]))
                realm.add(Operation(value: ["name" : "Ausbrechen 1", "startdate": "21.06.2017", "enddate":"26.06.2017"]))
                realm.add(Operation(value: ["name" : "Ausbrechen 2", "startdate": "21.06.2017", "enddate":"26.06.2017"]))
                realm.add(Operation(value: ["name" : "Ausheben", "startdate": "21.06.2017", "enddate":"26.06.2017"]))
                realm.add(Operation(value: ["name" : "Biegen", "startdate": "21.06.2017", "enddate":"26.06.2017"]))
                realm.add(Operation(value: ["name" : "Drähte runter legen", "startdate": "21.06.2017", "enddate":"26.06.2017"]))
                realm.add(Operation(value: ["name" : "Entlauben 1", "startdate": "21.06.2017", "enddate":"26.06.2017"]))
                realm.add(Operation(value: ["name" : "Entlauben 2", "startdate": "21.06.2017", "enddate":"26.06.2017"]))
                realm.add(Operation(value: ["name" : "Grubbern 1", "startdate": "21.06.2017", "enddate":"26.06.2017"]))
                realm.add(Operation(value: ["name" : "Grubbern 2", "startdate": "21.06.2017", "enddate":"26.06.2017"]))
                realm.add(Operation(value: ["name" : "Spritzen 4", "startdate": "21.06.2017", "enddate":"26.06.2017"]))
                realm.add(Operation(value: ["name" : "Spritzen 5", "startdate": "21.06.2017", "enddate":"26.06.2017"]))
                realm.add(Operation(value: ["name" : "Spritzen 6", "startdate": "21.06.2017", "enddate":"26.06.2017"]))
                realm.add(Operation(value: ["name" : "Spritzen 7", "startdate": "21.06.2017", "enddate":"26.06.2017"]))
                realm.add(Operation(value: ["name" : "Spritzen 8", "startdate": "21.06.2017", "enddate":"26.06.2017"]))
            }
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        operationList = realm.objects(Operation.self).sorted(byKeyPath: "name", ascending: true)
    }
        
    /*
     * This segue closes the EditOperation- or AddOperationViewController.
     */
    @IBAction func unwindToOperation(segue:UIStoryboardSegue) {}
    
    /*
     * Tries to sort the list of operation by the given criteria and updates the UITableView.
     */
    @IBAction func sortOperations(_ sender: UISortSegmentedControl) {
        sortOperationsBy = sender.selectedSegmentIndex
        sortDirection = sender.direction
        updateTableView()
    }
    
    /*
     * Updates the content which is displayed by the UITableView and reloads the data to the UITableView.
     */
    func updateTableView() -> Void {
        operationList = realm.objects(Operation.self)
        if (sortOperationsBy == 0) {
            operationList = operationList?.sorted(byKeyPath: "name", ascending: sortDirection)
        } else {
            operationList = operationList?.sorted(byKeyPath: "doneArea", ascending: sortDirection)
        }
        operationList = operationList?.filter("name contains '" + searchForOperations + "'")
        operationTable.reloadData()
    }
    
    /*
     * If this ViewController will appear the sum of area of all fields will be updated and
     * the UITableView updates all cells.
     */
    override func viewWillAppear(_ animated: Bool) {
        let fields:Results<Field> = realm.objects(Field.self)
        var area:Int = 0
        for f in fields {
            area += f.area
        }
        sumOfArea = String(format:"%.2f", Double(area) / 10000.0)
        updateTableView()
    }
    
}



/*
 * This extension for OperationsViewController handles swipe events in order to delete
 * or edit specific operations. Furthermore it returns the number of cells going to be
 * displayed or initializes the UIViews within the OperationDetailCell. Finally it handles
 * click-events on the cells.
 */
extension OperationsViewController : UITableViewDataSource, UITableViewDelegate {
    
    /*
     * Returns the number of rows displayed by the UITableView.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            self.navigationController?.pushViewController(editController, animated: true)
        })
        editAction.backgroundColor = UIColor.orange
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Löschen", handler: {(action,indexPath) in
            try! self.realm.write {
                let operation:Operation = self.operationList![indexPath.row]
                if (DataManager.shared.currentOperation == operation) {
                    DataManager.refreshOperation()
                }
                self.realm.delete(operation)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        })
        deleteAction.backgroundColor = UIColor.red
        
        return [deleteAction, editAction]
    }
    
   
    /*
     * Handles clicks on the OperationDetailCell
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DataManager.shared.currentOperation = self.operationList![indexPath.row]
        self.tabBarController?.selectedIndex = 1
    }
    
}



/*
 * Checks the input of the searchBar and updates the UITableView when the text within the 
 * searchbar has been changed.
 */
extension OperationsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchForOperations = searchText
        updateTableView()
    }
    
}
