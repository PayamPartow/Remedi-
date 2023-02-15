//
//  ProfileViewController.swift
//  Remedi
//
//  Created by Ngan Nguyen on 2019-11-02.
//  Copyright © 2019 Krystal Nguyen. All rights reserved.
//
//Programmers: Ngan Nguyen, David Song, Payam Partow, HuyThong Bui

import UIKit
import FirebaseFirestore
import FirebaseAuth

//Class to control the main storyboard, it will connect with Firebase for retrieving data
class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var firestore: Firestore!
    var userID = Auth.auth().currentUser!.uid
    var userEmail = Auth.auth().currentUser!.email!
    var firstName = ""
    var lastName = ""
    var physID = ""
    var physFirstName = ""
    var physLastName = ""
    var physEmail = ""
    var image = UIImagePickerController()
    @IBOutlet weak var patientPicture: UIImageView!
    //These varialbes using to connect the Profile storyboard with Controller
    @IBOutlet weak var patientnameLabel: UILabel!
    @IBOutlet weak var patientMednumLabel: UILabel!
    @IBOutlet weak var patientPhoneLabel: UILabel!
    @IBOutlet weak var patientEmailLabel: UILabel!
    @IBOutlet weak var patientHomeAddressLabel: UILabel!
    @IBOutlet weak var physNameLabel: UILabel!
    @IBOutlet weak var physPhoneLabel: UILabel!
    @IBOutlet weak var physEmailLabel: UILabel!
    @IBOutlet weak var physHomeAddLabel: UILabel!
    
    @IBAction func backtabTapped(_ sender: Any) {
        let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()}
    
    //Function using to retrieve information from Firebase
    @IBAction func logoutTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error logging out: %@", signOutError)
        }
        
        let loginViewController = self.storyboard?.instantiateViewController(identifier: "LoginVC") as? ViewController
        self.view.window?.rootViewController = loginViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    
    @IBOutlet weak var displayPatientPicture: UIImageView!
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
            //Save Image in Persistence
        let imageData:NSData = image.jpegData(compressionQuality: 1)! as NSData
        UserDefaults.standard.set(imageData, forKey: "savedImage")
        let data = UserDefaults.standard.object(forKey: "savedImage") as! NSData
        displayPatientPicture.image = UIImage(data: data as Data)
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func importFromLibrary(_ sender: Any) {
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        
        self.present(image, animated: true) {
            // After it is complete
        }
    }
    
    @IBAction func importFromCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            myPickerController.allowsEditing = true
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        Auth.auth().addStateDidChangeListener { auth, user in
//          guard let user = user else { return }
//        }
        let db = Firestore.firestore()
        let collectionRef = db.collection("users")
        collectionRef.document(userEmail).getDocument(completion: {(snapshot, error) in
            if let d = snapshot?.data() {
                self.firstName = d["firstname"] as! String
                self.lastName = d["lastname"] as! String
                self.patientMednumLabel.text = d["healthID"] as! String
                self.patientPhoneLabel.text = d["phoneNumber"] as! String
                self.patientEmailLabel.text = self.userEmail
                self.patientHomeAddressLabel.text = d["homeAddress"] as! String
                self.physID = d["doctorID"] as! String
            }
            self.patientName()
            self.physInfor()
        })
        
        let data = UserDefaults.standard.object(forKey: "savedImage") as? NSData
        if data != nil {
            displayPatientPicture.image = UIImage(data: data! as Data)
        }
    }
    
    func patientName() {
        patientnameLabel.text = firstName +  " " + lastName
    }

    // Function to display information of physician
    func physInfor(){
        let db = Firestore.firestore()
        let collectionRef = db.collection("doctor")
        collectionRef.document(physID).getDocument(completion: {(snapshot, error) in
            if let d = snapshot?.data() {
                self.physFirstName = d["firstName"] as! String
                self.physLastName = d["lastName"] as! String
                self.physEmailLabel.text = d["physEmail"] as! String
                self.physPhoneLabel.text = d["physPhone"] as! String
                self.physHomeAddLabel.text = d["physHomeAdd"] as! String
            }
            self.physName()
        })
    }
    
    func physName() {
        physNameLabel.text = physFirstName +  " " + physLastName
    }
    //Normal mode
//    self.lbl.hidden = NO;
//    self.textfield.enabled = NO;
//    self.textfield.hidden = YES;
    //Edit mode
//    self.lbl.hidden = YES;
//    self.textfield.enabled = YES;
//    self.textfield.hidden = NO;
    func editButton(){
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
