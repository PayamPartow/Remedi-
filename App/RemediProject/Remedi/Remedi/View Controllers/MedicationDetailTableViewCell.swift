//
//  MedicationDetailTableViewCell.swift
//  Remedi
//
//  Created by Ngan Nguyen on 2019-11-15.
//  Copyright © 2019 Krystal Nguyen. All rights reserved.
//

import UIKit
protocol myProctocol {
    func onClickCell(index: Int)
    func onUnClickCell(index: Int)
}

class MedicationDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var doseFrequencyLabel: UILabel!
    @IBOutlet weak var medicineNameLabel: UILabel!
    @IBOutlet weak var doseSizeLabel: UILabel!
    @IBOutlet weak var rectangleImage: UIImageView!
    @IBOutlet weak var timePrefLabel: UILabel!
    @IBOutlet weak var chkButton: UIButton!
    var cellDelegate:myProctocol?
    var index: IndexPath?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func clickDone(_ sender: UIButton) {
        if !sender.isSelected{
            cellDelegate?.onClickCell(index: (index?.row)!)
            sender.isSelected = true
        } else {
//            cellDelegate?.onUnClickCell(index: (index?.row)!)
            sender.isSelected = true
        }
    }
    
}
