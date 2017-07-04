//
//  FieldsTableViewController.swift
//  Weinberg
//
//  Created by Student on 02.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation

/*
 *@autor Johannes Strauss
 *@email johannes.a.strauss@th-bingen.de
 *
 *The class FieldsViewController is reponsible for creating Cells of the UITableView with
 *the content of Fields. The List can be sorted, by name or size of the field. A search
 *functionality is also part of the view. A checkbox inside the cell marks, if the Field
 *is done in relation to the currently chosen operation. The user can check or uncheck.
 *By clicking on the cell the ViewController switches to the map, and moves to the excapt location
 *of the Field. You can edit or delete the Field by swiping over the cell.
 *
 */

class FieldsViewController: UIViewController {

    var fields: Results<Field>?
    let realm = try! Realm()
    
    @IBOutlet weak var fieldTable: UITableView!
    let all:String = "15.5"
    var sortBy: Int = 0
    var sortDirection: Bool = true
    var searchFor: String = ""
    var createNewField:Bool = false
    var tableDelegate:FieldsVCRTableViewDelegate?
    
    override func viewDidLoad() {
        fieldTable.tableHeaderView = UIView()
        fieldTable.tableFooterView = UIView()
        
        fields = realm.objects(Field.self).sorted(byKeyPath: "name", ascending: true)
        tableDelegate = FieldsVCRTableViewDelegate(fields: fields!, navbarController: self.navigationController!, tabbarController: self.tabBarController!)
        fieldTable.delegate = tableDelegate
        fieldTable.dataSource = tableDelegate
    }

    @IBAction func unwindToField(segue:UIStoryboardSegue) {}
    
    @IBAction func sortFields(_ sender: UISortSegmentedControl) {
        sortBy = sender.selectedSegmentIndex
        sortDirection = sender.direction
        updateTableView()
    }
    
    func updateOperation() {
        if (DataManager.shared.currentOperation != nil) {
            navigationItem.title = DataManager.shared.currentOperation?.name
        } else {
            navigationItem.title = "Keine Arbeiten"
        }
    }
    
    func updateTableView(){
        fields = realm.objects(Field.self)
        if(sortBy == 0){
            fields = fields?.sorted(byKeyPath: "name", ascending: sortDirection)
        }else{
            fields = fields?.sorted(byKeyPath: "area", ascending: sortDirection)
        }
        fields = fields?.filter("name contains '" + searchFor + "'")
        tableDelegate?.fields = fields
        fieldTable.reloadData()
    }
    
    @IBAction func createNewField(_ sender: Any) {
        tabBarController?.selectedIndex = 1
        createNewField = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if (createNewField) {
            NotificationCenter.default.post(name: .createNewField, object: nil)
            createNewField = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateTableView()
        updateOperation()
    }
    
    @IBAction func renewOperation(_ sender: UIBarButtonItem) {
        if (DataManager.shared.currentOperation != nil && (DataManager.shared.currentOperation?.done.count)!>0) {
            let alert = UIAlertController(title: "Zurücksetzen", message: "Wollen Sie wirklich den gesamten Arbeitsschritt zurücksetzen?", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Zurücksetzen", style: .default, handler:{(_) in
                try! self.realm.write {
                    let operation = DataManager.shared.currentOperation
                    for doneField in (operation?.done)! {
                        operation?.todo.append(doneField)
                    }
                    operation?.doneArea  = 0
                    operation?.done.removeAll()
                }
                self.updateTableView()
            }))
        }
    }
    
}

/*
 * Checks the input of the searchBar and updates the UITableView
 */
extension FieldsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchFor = searchText
        updateTableView()
    }
    
}
