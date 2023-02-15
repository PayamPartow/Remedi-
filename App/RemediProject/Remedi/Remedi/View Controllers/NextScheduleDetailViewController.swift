//
//  NextScheduleDetailViewController.swift
//  Remedi
//
//  Created by Thong Bui on 2019-11-30.
//  Copyright © 2019 Krystal Nguyen. All rights reserved.
//

import UIKit
import WebKit


class NextScheduleDetailViewController: UIViewController {

    @IBOutlet var ExerciseWebView: WKWebView!

    var image = UIImage()
    var name = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if name=="Arms"{
                  let url = URL(string: "https://youtu.be/Wa8Fk8TaXPk")
                  let request = URLRequest(url: url!)
                  ExerciseWebView.load(request)
              }
              else if name=="Legs"{
                  let url = URL(string: "https://youtu.be/8BcPHWGQO44")
                  let request = URLRequest(url: url!)
                  ExerciseWebView.load(request)
              }
              else if name=="Balance"{
                  let url = URL(string: "https://youtu.be/mQLzNf8VOIc")
                  let request = URLRequest(url: url!)
                  ExerciseWebView.load(request)
              }
    }
 
    

}
