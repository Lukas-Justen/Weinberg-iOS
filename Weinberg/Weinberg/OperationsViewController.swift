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
        ops.append(Operation(name: "Grubbern" , date: "12.04.2017 - 15.04.2017", done: "6.84" ))
        ops.append(Operation(name: "Schneiden" , date: "20.05.2017 - 15.06.2017", done: "0.0" ))
        ops.append(Operation(name: "Ausbessern" , date: "11.06.2017 - 17.06.2017", done: "0.0" ))
        ops.append(Operation(name: "Ausbrechen" , date: "12.04.2017 - 15.04.2017", done: "3.56" ))
        ops.append(Operation(name: "Entlauben 1" , date: "12.04.2017 - 15.04.2017", done: "0.0" ))
        ops.append(Operation(name: "Entlauben 2" , date: "12.04.2017 - 15.04.2017", done: "8.87" ))
        ops.append(Operation(name: "Heften" , date: "12.04.2017 - 15.04.2017", done: "0.0" ))
        ops.append(Operation(name: "Spritzen 1" , date: "12.04.2017 - 15.04.2017", done: "10.5" ))
        ops.append(Operation(name: "Spritzen 2" , date: "12.04.2017 - 15.04.2017", done: "0.0" ))
        ops.append(Operation(name: "Spritzen 3" , date: "12.04.2017 - 15.04.2017", done: "12.4" ))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: nil, action: nil)
        operationTable.tableFooterView = UIView()
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
        cell.name.text = operation.name
        cell.datex.text = operation.date
        cell.done.text = operation.done
            
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Entfernt das ausgewählte Element aus der Liste aller Operations
            self.ops.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

struct Operation {
    var name: String
    var date: String
    var done: String
}
