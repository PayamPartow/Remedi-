//
//  MedicationDetailViewController.swift
//  Remedi
//
//  Created by Ngan Nguyen on 2019-11-15.
//  Copyright © 2019 Krystal Nguyen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
class MedicationDetailViewController: UIViewController {
    var userEmail = Auth.auth().currentUser!.email!
    @IBOutlet weak var presInforRectangle: UIImageView!
    @IBOutlet weak var medicationLabel: UILabel!
    @IBOutlet weak var medicationLabel2: UILabel!
    var medArray = ""
    var medNotes = ""
    var doseSize = ""
    var instruction = ""
    override func viewDidLoad() {
        super.viewDidLoad()
//        Utilities.rectangle8(medDetailLabel)
        presInforRectangle.image = UIImage(named: "Rectangle_big")
        medicationLabel.text = "DRUG NAME: \(medArray) \(doseSize)"
        medicationLabel2.text = "Instructions: \(instruction) \nDoctor note: \(medNotes)"
        // Do any additional setup after loading the view.
    }
    

    
//     @IBAction func onClickDone(_ sender: UIButton) {
//        let db = Firestore.firestore()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd"
//        let datestr = "day" + formatter.string(from: Date())
//        let docData: [String: Any] = ["dayMedTaken": [datestr]]
//        if !sender.isSelected{
//            db.collection("users").document(userEmail).collection("medications").document(medArray).setData(docData, merge:true)
//            print(datestr)
//        } else {
//            print("NO")
//        }
//     }
    /*
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
