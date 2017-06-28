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

class FieldsViewController: UIViewController {

    var fields: Results<Field>?
    let realm = try! Realm()
    
    @IBOutlet weak var fieldTable: UITableView!
    let all:String = "15.5"
    var sortBy: Int = 0
    var sortDirection: Bool = true
    var searchFor: String = ""
    var createNewField:Bool = false
    
    override func viewDidLoad() {
        fieldTable.tableHeaderView = UIView()
        fieldTable.tableFooterView = UIView()
        
        fields = realm.objects(Field.self).sorted(byKeyPath: "name", ascending: true)
    }

    @IBAction func unwindToField(segue:UIStoryboardSegue) {}
    
    @IBAction func sortFields(_ sender: UISortSegmentedControl) {
        sortBy = sender.selectedSegmentIndex
        sortDirection = sender.direction
        updateTableView()
    }
    
    func updateOperation() {
        navigationItem.title = DataManager.shared.currentOperation?.name
    }
    
    func updateTableView(){
        fields = realm.objects(Field.self)
        if(sortBy == 0){
            fields = fields?.sorted(byKeyPath: "name", ascending: sortDirection)
        }else{
            fields = fields?.sorted(byKeyPath: "area", ascending: sortDirection)
        }
        fields = fields?.filter("name contains '" + searchFor + "'")
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
        try! realm.write {
            let operation = DataManager.shared.currentOperation
            for doneField in (operation?.done)! {
                operation?.todo.append(doneField)
            }
            operation?.doneArea  = 0
            operation?.done.removeAll()
        }
        updateTableView()
    }
    
}

extension FieldsViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(fields != nil){
            return (fields?.count)!
        }
        
        return realm.objects(Field.self).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let field = fields![indexPath.row]
        let cellIdentifier = "FieldDetailCell"	
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! FieldDetailCell
        
        cell.name.text = field.name
        cell.size.text = String(describing: field.area)
        cell.checkBox.field = nil
        cell.checkBox.isChecked = (DataManager.shared.currentOperation?.done.contains(field))!
        cell.checkBox.field = field
        cell.viewBackground.layer.shadowColor = UIColor.black.cgColor
        cell.viewBackground.layer.shadowOpacity = 0.2
        cell.viewBackground.layer.shadowOffset = CGSize.init(width: -1, height: 1)
        cell.viewBackground.layer.shadowRadius = 1
        
        return cell
    }
    /*
     *
     *
     */
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Editieren", handler: {(action,indexPath) in
            let field:Field = self.fields![indexPath.row]
            let storyBoard: UIStoryboard = UIStoryboard(name:"Field",bundle:nil)
            let editController : EditFieldViewController = storyBoard.instantiateViewController(withIdentifier: "EditField") as! EditFieldViewController
            editController.field = field
            self.navigationController?.pushViewController(editController, animated: true)
        })
        editAction.backgroundColor = UIColor.orange
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Löschen", handler: {(action,indexPath) in
            try! self.realm.write {
                self.realm.delete(self.fields![indexPath.row])
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        })
        deleteAction.backgroundColor = UIColor.red
        
        return [deleteAction, editAction]
    }
    
    /*
    *Handles clicks on the Field detailCell
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        DataManager.shared.currentcoordinates = CLLocationCoordinate2D(latitude: (self.fields![indexPath.row].boundaries.first?.lat)!, longitude: (self.fields![indexPath.row].boundaries.first?.lng)!)
        tabBarController?.selectedIndex = 1
        // TODO Zoom an position mit Notification
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
