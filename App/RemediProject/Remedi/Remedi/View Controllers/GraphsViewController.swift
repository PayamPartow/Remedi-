//
//  GraphsViewController.swift
//  Remedi
//
//  Created by Ngan Nguyen on 2019-11-26.
//  Copyright © 2019 Krystal Nguyen. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Charts

class GraphsViewController: UIViewController {
    


    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var todayDateLabel: UILabel!
    
    var advil:Double = 0.0
    var telynol:Double = 0.0
    var aspirin:Double = 0.0
    var medication: [String]!
    var intake: [Double]!
    var reactionCount: [Double] = []
    var medMap: [String:Any] = [:]

    var fstore: Firestore!
    var userID = Auth.auth().currentUser!.uid
    var userEmail = Auth.auth().currentUser!.email!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDate()
//        setUpValue()
        medication = ["Selegiline","Amantadine","Levodopa","Safinamide","Trihexyphenidyl","Selegiline","Tolcapone","Promethzine","Biperidin"]
        intake = [20.0,15.0,17.0,16.0,14.0,12.0,11.0,15.0,20.0]
//        self.reactionCount.append(self.advil)
//        self.reactionCount.append(self.telynol)
//        self.reactionCount.append(self.aspirin)
        self.updateBarChart(dataPoints: self.medication, values: intake)
    }
    
//    func setUpValue(){
//        let db = Firestore.firestore()
//        db.collection("users").document(userEmail).collection("medications").getDocuments { (querySnapshot, err) in
//            if let err = err{
//                print("error getting documents")
//            }else{
//                print("Aa")
//                for document in querySnapshot!.documents{
//                    self.medMap = document.data()
////                    self.medication.append(document["medName"])
//                    do{
//                        var value = self.medMap["dayMedTaken"]
//                        var value2 = self.medMap["medName"]
//                        print("value")
//                        print(value)
//                        print(self.medMap["medName"] as! String)
//                        print("value2")
//                        print(self.medMap["doseSize"] as! String)
//                        if let number = value, let number2 = value2{
//                            self.medication.append(self.medMap["medName"] as! String)
//                            self.intake.append(Double((self.medMap["dayMedTaken"] as! [String]).count))
//                        }else{
//                            print("Error")
//                        }
//                    }
//                    catch _ {
//                        print("Error")
//                    }
//                }
//            }
//        }
//    }
    
    func setUpDate(){
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM, dd, yyyy"
        let str = formatter.string(from: Date())
        todayDateLabel.text = "Exercises for \n" + str
        
    }
    func updateBarChart(dataPoints: [String], values: [Double]){
        var dataEntries: [BarChartDataEntry] = []
        var counter = 0.0
        
        for i in 0..<dataPoints.count {
            counter += 1.0
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
            
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Medications")
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        chartDataSet.colors = ChartColorTemplates.colorful()
        barChart.leftAxis.enabled = true
        barChart.rightAxis.enabled = true
        barChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:self.medication)
        barChart.xAxis.granularity = 1
        barChart.xAxis.labelFont = UIFont(name:"Helvetica", size: 11.0)!
        barChart.data = chartData
        let legend = barChart.legend
        legend.enabled = true
        legend.font = UIFont(name: "boldSystemFontOfSize", size:15.0) ?? UIFont.systemFont(ofSize: 20)
        legend.textColor = UIColor.black
        legend.formSize = 20
        barChart.chartDescription?.text = ""
    }


    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
