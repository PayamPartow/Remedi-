//
//  MedicationViewController.swift
//  Remedi
//
//  Created by Ngan Nguyen on 2019-11-15.
//  Copyright © 2019 Krystal Nguyen. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class MedicationViewController: UIViewController {
    var userEmail = Auth.auth().currentUser!.email!
    var medSize = 0
    var medMap: [String:Any] = [:]
    var medArray: [String] = []
    var medicines = [Medicine]()
    @IBOutlet weak var todayMedicationLabel: UILabel!
    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var todayDateLabel: UILabel!
    @IBOutlet weak var medicationTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let yourBackImage = UIImage(named: "Back tab")
//        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
//        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
//        self.navigationController?.navigationBar.backItem?.title = "Custom"
        setUpDate()
        loadData()
    }
    func loadData(){
        let db = Firestore.firestore()
        db.collection("users").document(userEmail).collection("medications").getDocuments { (querySnapshot, err) in
            if (querySnapshot!.documents.count == 0){
                print("error getting documents")
                return
            }else{
                for document in querySnapshot!.documents{
                    self.medMap = document.data()
                    self.medArray.append(document.documentID)
                    do{
                        let doseNotes = self.medMap["doseNotes"] as! String
                        let timePref = self.medMap["timePref"] as! String
                        let medNotes = self.medMap["medNotes"] as! String
                        let doseSize = self.medMap["doseSize"] as! String
                        let instructions = self.medMap["instructions"] as! String
                        let dayMedTaken = self.medMap["dayMedTaken"] as! [String]
                        let medicine = Medicine(doseSizeString: doseSize, doseNotesString: doseNotes, timePrefString: timePref, medNotesString: medNotes, instructionsString: instructions, dayMedTakenString: dayMedTaken)
                        self.medicines.append(medicine)
                    }
                    catch _ {
                        print("Error")
                    }
                }
                self.medSize = querySnapshot!.count
                self.medicationTableView.reloadData()
            }
        }
    }
//    func checkTaken(){
//        let db = Firestore.firestore()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd"
//        let datestr = "day" + formatter.string(from: Date())
//        db.collection("users").document(userEmail).collection("medications").document(self.medArray).collection(datestr).whereField("medAssigned", isEqualTo: "taken").getDocuments { (snapshot, err) in
//            if let err = err {
//                print("Error getting document: \(err)")
//            } else if (snapshot?.isEmpty)! {
//                completion(false)
//            }
//        }
//    }
    func setUpDate(){
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM, dd, yyyy"
        let str = formatter.string(from: Date())
        todayDateLabel.text = str
        
    }
}
extension MedicationViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MedicationDetailTableViewCell
        cell?.medicineNameLabel.text = medArray[indexPath.row]
        cell?.doseFrequencyLabel.text = medicines[indexPath.row].doseNotes
        cell?.doseSizeLabel.text = medicines[indexPath.row].doseSize
        cell?.timePrefLabel.text = medicines[indexPath.row].timePref
        cell?.cellDelegate = self as! myProctocol
        cell?.index = indexPath
        
//        self.tblEvents.dataSource = self;
        //This is for if we ever want to make the click button to be on the detail page
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        let datestr = "day" + formatter.string(from: Date())
        if medicines[indexPath.row].dayMedTaken.contains(datestr){
            cell?.chkButton.isSelected = true
            print("yes")
        }
        else{
            cell?.chkButton.isSelected = false
            print("no")
        }
        cell?.rectangleImage.image = UIImage(named: "Rectangle 8")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MedicationDetailViewController") as? MedicationDetailViewController
        vc?.medArray = medArray[indexPath.row]
        vc?.doseSize = medicines[indexPath.row].doseSize
        vc?.medNotes = medicines[indexPath.row].medNotes
        vc?.instruction = medicines[indexPath.row].instructions
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}

extension MedicationViewController: myProctocol{
    func onClickCell(index: Int){
        let db = Firestore.firestore()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        let datestr = "day" + formatter.string(from: Date())
        let docData: [String: Any] = ["dayMedTaken": [datestr]]
        db.collection("users").document(userEmail).collection("medications").document(medArray[index]).setData(docData, merge:true)
        print(datestr)
    }
    func onUnClickCell(index: Int) {
        let db = Firestore.firestore()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        let datestr = "day" + formatter.string(from: Date())
        let docData: [String: Any] = ["dayMedTaken": [datestr]]
        db.collection("users").document(userEmail).collection("medications").document(medArray[index]).setData(docData, merge:true)
    }
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


