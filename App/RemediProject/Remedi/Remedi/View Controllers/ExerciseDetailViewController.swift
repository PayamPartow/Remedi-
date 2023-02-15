//
//  ExerciseDetailViewController.swift
//  Remedi
//
//  Created by Thong Bui on 2019-11-14.
//  Copyright © 2019 Krystal Nguyen. All rights reserved.
//

import UIKit
import WebKit

class ExerciseDetailViewController: UIViewController {

    
    @IBOutlet weak var lbl: UILabel!

    @IBOutlet weak var exerciseLabel1: UILabel!
    @IBOutlet weak var exerciseLabel2: UILabel!
    @IBOutlet weak var ExerciseWebView: WKWebView!
    
    var image = ""
    var video = ""
    var exArray = ""
    var exNotes = ""
    var exReps = ""
    var exSets = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        exerciseLabel1.text = "EXERCISE NAME: \(exArray)"
        exerciseLabel2.text = "Number of reps: \(exReps) \nNumber of sets: \(exSets) \nInstructions: Please follow the video above \nDoctor note: \(exNotes)"
        if image=="Arms"{
                  let url = URL(string: "https://youtu.be/Wa8Fk8TaXPk")
                  let request = URLRequest(url: url!)
                  ExerciseWebView.load(request)
              }
              else if image=="Legs"{
                  let url = URL(string: "https://youtu.be/8BcPHWGQO44")
                  let request = URLRequest(url: url!)
                  ExerciseWebView.load(request)
              }
              else if image=="Balance"{
                  let url = URL(string: "https://youtu.be/mQLzNf8VOIc")
                  let request = URLRequest(url: url!)
                  ExerciseWebView.load(request)
              }
                else if image=="Calf raise"{
                    let url = URL(string: "https://youtu.be/mQLzNf8VOIc")
                    let request = URLRequest(url: url!)
                    ExerciseWebView.load(request)
                }
                else if image=="Hand"{
                    let url = URL(string: "https://youtu.be/mQLzNf8VOIc")
                    let request = URLRequest(url: url!)
                    ExerciseWebView.load(request)
                }
                else if image=="Bicep curl"{
                    let url = URL(string: "https://youtu.be/mQLzNf8VOIc")
                    let request = URLRequest(url: url!)
                    ExerciseWebView.load(request)
                }
            
        
        //img.image = image
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func checkBoxTapped(_ sender: UIButton) {
        
        if sender.isSelected{
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
}
