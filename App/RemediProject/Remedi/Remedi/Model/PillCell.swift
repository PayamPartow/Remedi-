//
//  PillCell.swift
//  Remedi
//
//  Created by Ngan Nguyen on 2019-11-30.
//  Copyright © 2019 Krystal Nguyen. All rights reserved.
//

import UIKit

// Pill cell configuration
class PillCell: UITableViewCell {

    // elements of the cell connected.
    
    @IBOutlet weak var pillNameLabel: UILabel!
    @IBOutlet weak var pillTimeLabel: UILabel!
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
