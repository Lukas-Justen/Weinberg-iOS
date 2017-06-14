//
//  OperationTableViewController.swift
//  Weinberg
//
//  Created by Student on 02.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

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
    var ops:[Operation] = [Operation]()
    // The UITableView which shows the operations
    @IBOutlet weak var operationTable: UITableView!
    // The complete area the winery has to cultivate
    let all:String = "15.5"
    
    
    /*
     * Fills the list of operations with data and creates an empty UIView for the header and footer in the UITableView
     */
    override func viewDidLoad() {
        ops.append(Operation(name: "Heften" , date: "25.08.2017 - 30.08.2017", done: "all"))
        ops.append(Operation(name: "Grubbern" , date: "12.04.2017 - 15.04.2017", done: "6.84"))
        ops.append(Operation(name: "Schneiden" , date: "20.05.2017 - 15.06.2017", done: "0.0"))
        ops.append(Operation(name: "Ausbessern" , date: "11.06.2017 - 17.06.2017", done: "all"))
        ops.append(Operation(name: "Ausbrechen" , date: "23.02.2016 - 28.02.2016", done: "3.56"))
        ops.append(Operation(name: "Entlauben 1" , date: "19.01.2017 - 22.01.2017", done: "0.0"))
        ops.append(Operation(name: "Entlauben 2" , date: "30.02.2017 - 27.4.2017", done: "8.87"))
        ops.append(Operation(name: "Spritzen 1" , date: "29.09.2017 - 14.10.2017", done: "10.5"))
        ops.append(Operation(name: "Spritzen 2" , date: "30.10.2017 - 11.11.2017", done: "0.0"))
        ops.append(Operation(name: "Spritzen 3" , date: "24.12.2017 - 04.02.2018", done: "12.4"))
        
        operationTable.tableHeaderView = UIView()
        operationTable.tableFooterView = UIView()
    }

    /*
     * This segue closes the EditOperation- or AddOperationViewController
     */
    @IBAction func unwindToOperation(segue:UIStoryboardSegue) {}
    
}



/*
 * The extensions for OperationsViewController handle all tasks which relate to the UITableView
 */
extension OperationsViewController : UITableViewDataSource, UITableViewDelegate {
    
    /*
     * Returns the number of rows displayed by the UITableView
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ops.count
    }
    
    /*
     * Creates an empty OperationDetailCell and fills the labels with the correct data
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let operation = ops[indexPath.row]
        let cellIdentifier = "OperationDetailCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! OperationDetailCell
        let gesture:UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleOperationTap))
        
        if (operation.done != "all") {
            cell.labelName.text = operation.name
            cell.labelDate.text = operation.date
            cell.labelDone.text = operation.done
            cell.labelAll.text = self.all
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
            self.ops.remove(at: indexPath.row)
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




struct Operation {
    
    // The name of the given operation
    var name: String
    // The start- and enddate concatenated to one string
    var date: String
    // The area which is already done
    var done: String
    
}
