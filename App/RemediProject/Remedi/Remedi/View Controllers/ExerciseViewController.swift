//
//  ExerciseViewController.swift
//  Remedi
//
//  Created by Thong Bui on 2019-11-12.
//  Copyright © 2019 Krystal Nguyen. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
class ExerciseViewController: UIViewController {
    var userEmail = Auth.auth().currentUser!.email!
    @IBOutlet weak var tableView: UITableView!
    var exMap: [String:Any] = [:]
    var exArray: [String] = []
    var exercises = [Exercise]()
    var exSize = 0
    @IBOutlet weak var ExerciseListLabel: UILabel!
    @IBOutlet weak var exerciseTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM, dd, yyyy"
        let str = formatter.string(from: Date())
        ExerciseListLabel.text = str
        loadData()
    }
    func loadData(){
        var video = ""
        var image = ""
        let db = Firestore.firestore()
        db.collection("users").document(userEmail).collection("exercises").getDocuments { (querySnapshot, err) in
            if (querySnapshot!.documents.count == 0){
                print("error getting documents")
                return
            }else{
                for document in querySnapshot!.documents{
                    self.exMap = document.data()
                    self.exArray.append(document.documentID)
                    do{
                        let exName = self.exMap["exName"] as! String
                        let exNotes = self.exMap["exNotes"] as! String
                        let exReps = self.exMap["exReps"] as! String
                        let exSets = self.exMap["exSets"] as! String
                        let dayExTaken = self.exMap["dayExTaken"] as! [String]
                        db.collection("exercises").document(self.exMap["exName"] as! String).getDocument { (document2, error) in
                            if let document2 = document2, document2.exists {
                                video = document2.get("url") as! String
                                image = document2.get("exName") as! String
                            } else {
                                print("Document does not exist")
                            }
                        }
                        let exercise = Exercise(exNameString: exName, exNotesString: exNotes, exRepsString: exReps, exSetsString: exSets, dayExTakenString: dayExTaken, videoString: video, imageString: image)
                        self.exercises.append(exercise)
                    }
                    catch _ {
                        print("Error")
                    }
                }
                self.exSize = querySnapshot!.count
                self.exerciseTableView.reloadData()
            }
        }
    }
}
extension ExerciseViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ExerciseTableViewCell
        cell?.rectangleImage.image = UIImage(named: "Rectangle 8")
        cell?.lbl.text = exArray[indexPath.row]
        cell?.img.image = UIImage(named: exercises[indexPath.row].exName)
        cell?.cellDelegate = self as! myProctocol1
        cell?.index = indexPath
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        let datestr = "day" + formatter.string(from: Date())
        if exercises[indexPath.row].dayExTaken.contains(datestr){
            cell?.button5.isSelected = true
//            print("yes")
        }
        else{
            cell?.button5.isSelected = false
//            print("no")
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ExerciseDetailViewController") as? ExerciseDetailViewController
//        vc?.image = UIImage(named: exercises[indexPath.row].exName)!
//        vc?.name = name[indexPath.row]
        vc?.video = exercises[indexPath.row].video
        vc?.image = exercises[indexPath.row].exName
        vc?.exArray = exArray[indexPath.row]
        vc?.exNotes = exercises[indexPath.row].exNotes
        vc?.exReps = exercises[indexPath.row].exReps
        vc?.exSets = exercises[indexPath.row].exSets
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension ExerciseViewController: myProctocol1{
    func onClickCell(index: Int){
        let db = Firestore.firestore()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        let datestr = "day" + formatter.string(from: Date())
        let docData: [String: Any] = ["dayExTaken": [datestr]]
        db.collection("users").document(userEmail).collection("exercises").document(exArray[index]).setData(docData, merge:true)
        print(datestr)
    }
    func onUnClickCell(index: Int) {
        let db = Firestore.firestore()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        let datestr = "day" + formatter.string(from: Date())
        let docData: [String: Any] = ["dayExTaken": [datestr]]
        db.collection("users").document(userEmail).collection("exercises").document(exArray[index]).setData(docData, merge:true)
        print(datestr+"1")
    }
}
