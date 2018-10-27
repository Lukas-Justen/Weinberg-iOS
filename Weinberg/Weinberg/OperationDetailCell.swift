//
//  OperationDetailCellTableViewCell.swift
//  Weinberg
//
//  Created by Student on 09.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit



/*
 * @author Lukas Justen
 * @email lukas.justen@th-bingen.de
 * @version 1.0
 *
 * The class OperationDetailCell acts like a wrapper for the UIElements in the UITableViewCell.
 * You can changes the values or properties of the all these fields.
 */
class OperationDetailCell: UITableViewCell {

    
    
    // The UIElements within the detail cell which display the operation
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelDone: UILabel!
    @IBOutlet weak var labelAll: UILabel!
    @IBOutlet weak var imageDone: UIImageView!
    @IBOutlet weak var labelSlash: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    
}
