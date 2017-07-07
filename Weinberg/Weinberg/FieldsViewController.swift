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
 *@version 1.0
 *
 *The class FieldsViewController is reponsible for creating Cells of the UITableView with
 *the content of Fields. The List can be sorted, by name or size of the field. A search
 *functionality is also part of the view. A checkbox inside the cell marks, if the Field
 *is done in relation to the currently chosen operation. The user can check or uncheck.
 *By clicking on the cell the ViewController switches to the map, and moves to the excapt location
 *of the Field. You can edit or delete the Field by swiping over the cell. A Method to uncheck all
 *is also provided
 */

class FieldsViewController: UIViewController {

    //The List of Fields
    var fields: Results<Field>?
    //The realm instance
    let realm = try! Realm()
    //The tabel view
    @IBOutlet weak var fieldTable: UITableView!
    //sort and search criteria
    var sortBy: Int = 0
    var sortDirection: Bool = true
    var searchFor: String = ""
    //Indicates if a new Field is being created or not
    var createNewField:Bool = false
    //The reponsible object to fill the Tabel cells
    var tableDelegate: FieldsVCRTableViewDelegate?
    
    /*
     *Creates the UIView and fills the List
     */
    override func viewDidLoad() {
        fieldTable.tableHeaderView = UIView()
        fieldTable.tableFooterView = UIView()
        
        fields = realm.objects(Field.self).sorted(byKeyPath: "name", ascending: true)
        tableDelegate = FieldsVCRTableViewDelegate(fields: fields!, navbarController: self.navigationController!, tabbarController: self.tabBarController!)
        fieldTable.delegate = tableDelegate
        fieldTable.dataSource = tableDelegate
        
        navigationController?.navigationBar.accessibilityIdentifier = "FieldNavigationItemID"
    }

    /*
     *This seque closes the Edit/AddFieldViewController
     */
    @IBAction func unwindToField(segue:UIStoryboardSegue) {}
    
    @IBAction func sortFields(_ sender: UISortSegmentedControl) {
        sortBy = sender.selectedSegmentIndex
        sortDirection = sender.direction
        updateTableView()
    }
    
    /*
     *Displays the Name of the currently selected Operation
     */
    func updateOperation() {
        if (DataManager.shared.currentOperation != nil) {
            navigationItem.title = DataManager.shared.currentOperation?.name
        } else {
            navigationItem.title = "Keine Arbeiten"
        }
    }
    /*
    *Updates the content of the TableView
    */
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
    
    /*
     *Is called when the user wants to create a new field.
     *The App switches to the mapView where the User marks
     *the field on the map.
     */
    @IBAction func createNewField(_ sender: Any) {
        tabBarController?.selectedIndex = 1
        createNewField = true
    }
    
    /*
     *Is called when the user cancels the creation of a new Field.
     */
    override func viewDidDisappear(_ animated: Bool) {
        if (createNewField) {
            NotificationCenter.default.post(name: .createNewField, object: nil)
            createNewField = false
        }
    }
    /*
     *updates the content each time the view appears.
     */
    override func viewWillAppear(_ animated: Bool) {
        updateTableView()
        updateOperation()
    }
    /*
     *Set all fields unckecked and updates the date in the database.
     */
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
 * Checks the input of the searchBar and updates the UITableView. Furthermore it hides 
 * the keyboard if the searchbutton is pressed.
 */
extension FieldsViewController: UISearchBarDelegate {
        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchFor = searchText
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
