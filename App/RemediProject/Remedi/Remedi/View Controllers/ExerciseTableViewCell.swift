//
//  ExerciseTableViewCell.swift
//  Remedi
//
//  Created by Thong Bui on 2019-11-12.
//  Copyright © 2019 Krystal Nguyen. All rights reserved.
//

import UIKit
protocol myProctocol1 {
    func onClickCell(index: Int)
    func onUnClickCell(index: Int)
}
class ExerciseTableViewCell: UITableViewCell {

    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var lbl: UILabel!
    
    @IBOutlet weak var rectangleImage: UIImageView!
    var cellDelegate:myProctocol1?
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
