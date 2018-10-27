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
    
    // The sort and search criteria
    var sortOperationsBy: Int = 0
    var sortDirection:Bool = true
    var searchForOperations: String = ""
    // Fills the UITableView with its data
    var tableDelegate:OperationsVCRTableViewDelegate?
    
    // The RealmInstance in order to access the database
    let realm = try! Realm()
    
    // The list of ∞all operations this UIViewController displays
    var operationList: Results<Operation>?
    
    
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
                realm.add(Operation(value: ["name" : "Spritzen 4", "startdate": "21.06.2017", "enddate":"26.06.2017"]))
                realm.add(Operation(value: ["name" : "Spritzen 5", "startdate": "21.06.2017", "enddate":"26.06.2017"]))
                realm.add(Operation(value: ["name" : "Spritzen 6", "startdate": "21.06.2017", "enddate":"26.06.2017"]))
                realm.add(Operation(value: ["name" : "Spritzen 7", "startdate": "21.06.2017", "enddate":"26.06.2017"]))
                realm.add(Operation(value: ["name" : "Spritzen 8", "startdate": "21.06.2017", "enddate":"26.06.2017"]))
            }
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        operationList = realm.objects(Operation.self).sorted(byKeyPath: "name", ascending: true)
        tableDelegate = OperationsVCRTableViewDelegate(operationList: operationList!, navbarController: self.navigationController!, tabbarController: self.tabBarController!)
        operationTable.delegate = tableDelegate
        operationTable.dataSource = tableDelegate
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
        tableDelegate?.operationList = operationList
        operationTable.reloadData()
    }
    
    /*
     * If this ViewController will appear the sum of area of all fields will be updated and
     * the UITableView updates all cells.
     */
    override func viewWillAppear(_ animated: Bool) {
        updateTableView()
    }
    
}



/*
 * Checks the input of the searchBar and updates the UITableView when the text within the
 * searchbar has been changed. Furthermore it hides the keyboard if the searchbutton is pressed.
 */
extension OperationsViewController: UISearchBarDelegate,UITextFieldDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchForOperations = searchText
        updateTableView()
        if (searchText.characters.count == 0) {
            self.perform(#selector(hideKeyboardWithSearchBar), with: searchBar, afterDelay: 0)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    
    func hideKeyboardWithSearchBar(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
