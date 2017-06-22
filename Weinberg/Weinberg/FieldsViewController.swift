//
//  FieldsTableViewController.swift
//  Weinberg
//
//  Created by Student on 02.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import RealmSwift

class FieldsViewController: UIViewController {

    var fields: Results<Field>?
    let realm = try! Realm()
    
    @IBOutlet weak var fieldTable: UITableView!
    let all:String = "15.5"
    var sortBy: Int = 0
    var searchFor: String = ""
    
    
    override func viewDidLoad() {
       
        fieldTable.tableHeaderView = UIView()
        fieldTable.tableFooterView = UIView()
        
        fields = realm.objects(Field.self).sorted(byKeyPath: "name", ascending: true)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: .update, object: nil)
    }

    @IBAction func unwindToField(segue:UIStoryboardSegue) {}
    
    @IBAction func sortFields(_ sender: UISegmentedControl) {
        sortBy = sender.selectedSegmentIndex
        updateTableView()
    }
    
    
    func updateTableView(){
        fields = realm.objects(Field.self)
        if(sortBy == 0){
            fields = fields?.sorted(byKeyPath: "name", ascending: true)
        }else{
            fields = fields?.sorted(byKeyPath: "name", ascending: false)
        }
        fields = fields?.filter("name contains '" + searchFor + "'")
        fieldTable.reloadData()
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
        cell.size.text = String(field.area) + " m²"
        cell.viewBackground.layer.shadowColor = UIColor.black.cgColor
        cell.viewBackground.layer.shadowOpacity = 0.2
        cell.viewBackground.layer.shadowOffset = CGSize.init(width: -1, height: 1)
        cell.viewBackground.layer.shadowRadius = 1
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Editieren", handler: {(action,indexPath) in
            let storyBoard: UIStoryboard = UIStoryboard(name:"Field",bundle:nil)
            let editController : EditFieldViewController = storyBoard.instantiateViewController(withIdentifier: "EditField") as! EditFieldViewController
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
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tabBarController?.selectedIndex = 1
    }
    
}

struct FieldDummy {
    var name : String
    var fruit : String
    var treatment : String
    var size : Int
    var done : Bool
}
