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
 * The class OperationsViewController is responsible for filling the operation data into the 
 * UITableView. Furthermore, it handles clickevents on the OperationDetailCells. Editing, deleting
 * or adding new operations is also possible.
 */
class OperationsViewController: UIViewController {

    // The list of all operations which are displayed by the UITableView
    var ops: Results<Operation>?
    // The UITableView which shows the operations
    @IBOutlet weak var operationTable: UITableView!
    // The complete area the winery has to cultivate
    let all:String = "15.5"
    // The RealmInstance in order to access the database
    let realm = try! Realm()
    // The searchBar for searching specific operations
    @IBOutlet weak var searchForOperation: UISearchBar!
    // The order and search criteria
    var sortBy: Int = 0
    var searchFor: String = ""
    
    /*
     * Fills the list of operations with data and creates an empty UIView for the header and footer in the UITableView
     */
    override func viewDidLoad() {
        operationTable.tableHeaderView = UIView()
        operationTable.tableFooterView = UIView()
        
        // Add Operations to the Realm inside a transaction
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
        ops = realm.objects(Operation.self).sorted(byKeyPath: "name", ascending: true)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: .update, object: nil)
    }
        
    /*
     * This segue closes the EditOperation- or AddOperationViewController
     */
    @IBAction func unwindToOperation(segue:UIStoryboardSegue) {}
    
    @IBAction func sortOperations(_ sender: UISegmentedControl) {
        sortBy = sender.selectedSegmentIndex
        updateTableView()
    }
    
    func updateTableView() -> Void {
        ops = realm.objects(Operation.self)
        if (sortBy == 0) {
            ops = ops?.sorted(byKeyPath: "name", ascending: true)
        } else {
            ops = ops?.sorted(byKeyPath: "name", ascending: false)
        }
        ops = ops?.filter("name contains '" + searchFor + "'")
        operationTable.reloadData()
    }
    
}



/*
 * The extensions for OperationsViewController handle all tasks which relate to the UITableView
 */
extension OperationsViewController : UITableViewDataSource, UITableViewDelegate {
    
    /*
     * Returns the number of rows displayed by the UITableView
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (ops != nil) {
            return (ops?.count)!
        }
        return realm.objects(Operation.self).count
    }
    
    /*
     * Creates an empty OperationDetailCell and fills the labels with the correct data
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let operation = ops![indexPath.row]
        let cellIdentifier = "OperationDetailCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! OperationDetailCell
        let gesture:UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleOperationTap))
        
        if (operation.todo.count > 0) {
            cell.labelName.text = operation.name
            cell.labelDate.text = operation.getDateAsString()
            cell.labelDone.text = String(operation.done.count)
            cell.labelAll.text = String(operation.todo.count)
        } else {
            cell.labelName.text = operation.name
            cell.labelDate.text = operation.getDateAsString()
            cell.labelDone.isHidden = true
            cell.labelAll.isHidden = true
            cell.labelSlash.isHidden = true
            cell.imageDone.isHidden = false
        }
        cell.viewBackground.layer.shadowColor = UIColor.black.cgColor
        cell.viewBackground.layer.shadowOpacity = 0.2
        cell.viewBackground.layer.shadowOffset = CGSize.init(width: -1, height: 1)
        cell.viewBackground.layer.shadowRadius = 1
        cell.addGestureRecognizer(gesture)
            
        return cell
    }
    
    /*
     * Creates the opportunity for the user to edit or delete a row in the UITableView
     */
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Editieren", handler: {(action,indexPath) in
            let storyBoard: UIStoryboard = UIStoryboard(name:"Operation",bundle:nil)
            let editController : EditOperationViewController = storyBoard.instantiateViewController(withIdentifier: "EditOperation") as! EditOperationViewController
            self.navigationController?.pushViewController(editController, animated: true)
        })
        editAction.backgroundColor = UIColor.orange
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Löschen", handler: {(action,indexPath) in
            try! self.realm.write {
                self.realm.delete(self.ops![indexPath.row])
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        })
        deleteAction.backgroundColor = UIColor.red
        
        return [deleteAction, editAction]
    }
    
    /*
     * Handles all clicks on a OperationDetailCell
     */
    func handleOperationTap() -> Void {
        self.tabBarController?.selectedIndex = 1
    }
    
}

extension OperationsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchFor = searchText
        updateTableView()
    }
    
}

extension Notification.Name {
    static let update = Notification.Name("update")
}
