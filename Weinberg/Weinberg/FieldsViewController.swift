//
//  FieldsTableViewController.swift
//  Weinberg
//
//  Created by Student on 02.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class FieldsViewController: UIViewController {

    var fields:[FieldDummy] = [FieldDummy]()
    
    @IBOutlet weak var fieldTable: UITableView!
    let all:String = "15.5"
    
    
    override func viewDidLoad() {
        fields.append(FieldDummy(name: "Sommerberg", fruit: "Riesling", treatment: "Normalerziehung", size: 1385, done: false))
        fields.append(FieldDummy(name: "Guldenbach", fruit: "Bacchus", treatment: "Umkehranlage", size: 1683, done: false))
        fields.append(FieldDummy(name: "Schlossgarten", fruit: "Riesling", treatment: "Normalerziehung", size: 1870, done: false))
        fields.append(FieldDummy(name: "Wintertal", fruit: "Chardonnay", treatment: "Minimalschnitt", size: 876, done: false))
        fields.append(FieldDummy(name: "Hirtental", fruit: "Bacchus", treatment: "Minimalschnitt", size: 1790, done: false))
        
        fieldTable.tableHeaderView = UIView()
        fieldTable.tableFooterView = UIView()
    }
    
    @IBAction func unwindToField(segue:UIStoryboardSegue) {}
    
}

extension FieldsViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let field = fields[indexPath.row]
        let cellIdentifier = "FieldDetailCell"	
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! FieldDetailCell
        let gesture:UIGestureRecognizer = UIGestureRecognizer(target: self, action: #selector(handleFieldTap))
        
        cell.name.text = field.name
        cell.size.text = String(field.size)
        cell.viewBackground.layer.shadowColor = UIColor.black.cgColor
        cell.viewBackground.layer.shadowOpacity = 0.2
        cell.viewBackground.layer.shadowOffset = CGSize.init(width: -1, height: 1)
        cell.viewBackground.layer.shadowRadius = 1
        cell.addGestureRecognizer(gesture)
        
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
            self.fields.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        })
        deleteAction.backgroundColor = UIColor.red
        
        return [deleteAction, editAction]
    }
    
    func handleFieldTap() -> Void {
        self.tabBarController?.selectedIndex = 1
    }
    
}

struct FieldDummy {
    var name : String
    var fruit : String
    var treatment : String
    var size : Int
    var done : Bool
}
