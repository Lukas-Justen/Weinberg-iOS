//
//  NumberPadDelegate.swift
//  Weinberg
//
//  Created by ema on 07.07.17.
//  Copyright © 2017 Student. All rights reserved.
//

import Foundation
import UIKit

class NumberPadDelegate: NSObject, UITextFieldDelegate {
    
    var button:UIButton?
    var textField:UITextField?
    
    init(textField: UITextField) {
        super.init()
        self.textField = textField
        button = UIButton(type: .custom)
        button?.setTitle("Done", for: UIControlState())
        button?.setTitleColor(UIColor.black, for: UIControlState())
        button?.frame = CGRect(x: 0, y: 163, width: 106, height: 53)
        button?.adjustsImageWhenHighlighted = false
        button?.addTarget(self, action: #selector(hideNumberPad), for: UIControlEvents.touchUpInside)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func keyboardWillShow(_ note : Notification) -> Void{
        DispatchQueue.main.async { () -> Void in
            self.button?.isHidden = false
            let keyBoardWindow = UIApplication.shared.windows.last
            self.button?.frame = CGRect(x: 0, y: (keyBoardWindow?.frame.size.height)!-53, width: 106, height: 53)
            keyBoardWindow?.addSubview(self.button!)
            keyBoardWindow?.bringSubview(toFront: self.button!)
        }
    }
    
    func hideNumberPad() {
        self.textField?.endEditing(true)
    }
    
}
