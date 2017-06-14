//
//  FieldsTableViewController.swift
//  Weinberg
//
//  Created by Student on 02.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class FieldsViewController: UIViewController {

    var fields:[Field] = [Field]()
    
    @IBOutlet weak var fieldTable: UITableView!
    let all:String = "15.5"
    
    
    override func viewDidLoad() {
        fields.append(Field(name: "Sommerberg", fruit: "Riesling", treatment: "Normalerziehung", size: 2000, done: false))
        
        fieldTable.tableHeaderView = UIView()
        fieldTable.tableFooterView = UIView()
    }
    
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
        cell.size.text = String(field.size) + " m²"
        
        cell.viewBackground.layer.shadowColor = UIColor.black.cgColor
        cell.viewBackground.layer.shadowOpacity = 0.2
        cell.viewBackground.layer.shadowOffset = CGSize.init(width: -1, height: 1)
        cell.viewBackground.layer.shadowRadius = 1
        cell.addGestureRecognizer(gesture)
        
        return cell
    }
    
    /*
     * Handles all clicks on a FieldDetailCell
     */
    func handleFieldTap() -> Void {
        self.tabBarController?.selectedIndex = 1
    }
}

struct Field {
    var name : String
    var fruit : String
    var treatment : String
    var size : Int
    var done : Bool
}
