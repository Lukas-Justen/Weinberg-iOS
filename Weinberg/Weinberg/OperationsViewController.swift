//
//  OperationTableViewController.swift
//  Weinberg
//
//  Created by Student on 02.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import Floaty

class OperationsViewController: UIViewController {

    // Die Liste der Todos, die dargestellt werden soll
    var todos:[Todo] = [Todo]()
    
    
    override func viewDidLoad() {
        todos.append(Todo(title: "BLA" , description: "BSDOIHIH"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: nil, action: nil)
    }

}

extension OperationsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Holt ein neues Element aus der Liste aller Todos
        let todo = todos[indexPath.row]
        let cellIdentifier = "ElementCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        
        cell.textLabel?.text = todo.title
        cell.detailTextLabel?.text = todo.description
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Entfernt das ausgewählte Element aus der Liste aller Todos
            self.todos.remove(at: indexPath.row)
            
            // Entfernt das Element aus der UITableView
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

struct Todo {
    
    var title: String
    var description: String
    
}
