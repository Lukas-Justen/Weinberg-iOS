//
//  OperationTableViewController.swift
//  Weinberg
//
//  Created by Student on 02.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class OperationsViewController: UIViewController {

    // Die Liste der Todos, die dargestellt werden soll
    var ops:[Operation] = [Operation]()
    @IBOutlet weak var operationTable: UITableView!
    
    override func viewDidLoad() {
        ops.append(Operation(name: "Grubbern" , date: "12.04.2017 - 15.04.2017", done: "6.84", all: "15.5" ))
        ops.append(Operation(name: "Schneiden" , date: "20.05.2017 - 15.06.2017", done: "0.0", all: "15.5"  ))
        ops.append(Operation(name: "Ausbessern" , date: "11.06.2017 - 17.06.2017", done: "all", all: "15.5"  ))
        ops.append(Operation(name: "Ausbrechen" , date: "23.02.2016 - 28.02.2016", done: "3.56" , all: "15.5" ))
        ops.append(Operation(name: "Entlauben 1" , date: "19.01.2017 - 22.01.2017", done: "0.0" , all: "15.5" ))
        ops.append(Operation(name: "Entlauben 2" , date: "30.02.2017 - 27.4.2017", done: "8.87", all: "15.5"  ))
        ops.append(Operation(name: "Heften" , date: "25.08.2017 - 30.08.2017", done: "all", all: "15.5"  ))
        ops.append(Operation(name: "Spritzen 1" , date: "29.09.2017 - 14.10.2017", done: "10.5", all: "15.5"  ))
        ops.append(Operation(name: "Spritzen 2" , date: "30.10.2017 - 11.11.2017", done: "0.0" , all: "15.5" ))
        ops.append(Operation(name: "Spritzen 3" , date: "24.12.2017 - 04.02.2018", done: "12.4", all: "15.5"  ))
        operationTable.tableFooterView = UIView()
    }

    @IBAction func unwindToOperation(segue:UIStoryboardSegue) {
        
    }
    
}

extension OperationsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ops.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Holt ein neues Element aus der Liste aller Operations
        let operation = ops[indexPath.row]
        let cellIdentifier = "OperationDetailCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! OperationDetailCell
        if (operation.done != "all") {
            cell.labelName.text = operation.name
            cell.labelDate.text = operation.date
            cell.labelDone.text = operation.done
            cell.labelAll.text = operation.all
        } else {
            cell.labelName.text = operation.name
            cell.labelDate.text = operation.date
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Editieren", handler: {(action,indexPath) in
            print("Edit tapped")
            let edit: EditOperationViewController = EditOperationViewController()
            self.navigationController?.pushViewController(edit, animated: true)
        })
        editAction.backgroundColor = UIColor.orange
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Löschen", handler: {(action,indexPath) in
            print("Delete tapped")
            self.ops.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        })
        deleteAction.backgroundColor = UIColor.red
        
        return [deleteAction, editAction]
    }
    
}

struct Operation {
    var name: String
    var date: String
    var done: String
    var all: String
}
