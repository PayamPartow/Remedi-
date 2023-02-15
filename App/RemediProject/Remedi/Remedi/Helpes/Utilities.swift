//
//  Utilities.swift
//  customauth
//
//  Created by Christopher Ching on 2019-05-09.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit

//This Class using to modify the background of interfaces
class Utilities {
    
    static func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
//        bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        bottomLine.backgroundColor = UIColor.init(white: 1, alpha: 1).cgColor
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
//        button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        button.backgroundColor = UIColor(red: 0/255, green: 99/255, blue: 170/255, alpha: 1.0)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    static func rectangle8(_ label:UILabel) {
        let view = label
        view.center.x = view.center.x
        view.center.y = view.center.y
        view.frame = CGRect(x: 0, y: 0, width: 340, height: 120)
        view.backgroundColor = .white
        view.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(red: 0.561, green: 0.694, blue: 0.8, alpha: 1).cgColor
    }
    static func rectangleBig(_ label:UILabel) {
        let view = label
        view.center.x = view.center.x
        view.center.y = view.center.y
        view.frame = CGRect(x: 0, y: 0, width: 316, height: 400)
        view.backgroundColor = .white
        view.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(red: 0.561, green: 0.694, blue: 0.8, alpha: 1).cgColor
    }
    static func presInfor(_ label:UILabel){
        let view = label
        view.frame = CGRect(x: 0, y: 0, width: 246, height: 41)
        view.backgroundColor = .white
        view.textColor = UIColor(red: 0.459, green: 0.612, blue: 0.788, alpha: 1)
        view.font = UIFont(name: "Sarabun-SemiBold", size: 16)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
    }
}
