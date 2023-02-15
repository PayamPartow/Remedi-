//
//  ChartsViewController.swift
//  Remedi
//
//  Created by Ngan Nguyen on 2019-11-25.
//  Copyright © 2019 Krystal Nguyen. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Charts

class ChartsViewController: UIViewController {
    
    

    @IBOutlet weak var todayDateLabel: UILabel!
    @IBOutlet weak var pieChart: PieChartView!
    var fstore: Firestore!
    var userID = Auth.auth().currentUser!.uid
    //All of the exercise entries
    var armsEntry = PieChartDataEntry(value:0)
    var balanceEntry = PieChartDataEntry(value:0)
    var bicepCurlEntry = PieChartDataEntry(value:0)
    var calfRaiseEntry = PieChartDataEntry(value: 0)
    var handEntry = PieChartDataEntry(value:0)
    var legsEntry = PieChartDataEntry(value: 0)
    
    var armsCounter:Int = 0
    var balanceCounter:Int = 0
    var bicepCurlCounter:Int = 0
    var calfRaiseCounter:Int = 0
    var handCounter:Int = 0
    var legsCounter:Int = 0
    
    var numberOfDownloadsDataEntries = [PieChartDataEntry]()
    
    func updatePieChart(){
        let chartDataSet = PieChartDataSet(entries:numberOfDownloadsDataEntries, label: "")
        let chartData = PieChartData(dataSet: chartDataSet)
        chartDataSet.entryLabelColor = UIColor.clear
        chartData.setValueTextColor(UIColor.black)
        chartData.setValueFont(UIFont(name: "boldSystemFontOfSize", size:14.0) ?? UIFont.systemFont(ofSize: 14))
        let colors = [UIColor(named:"armsColor"), UIColor(named:"balanceColor"), UIColor(named:"bicepCurlColor"), UIColor(named:"carfRaiseColor"), UIColor(named:"handColor"), UIColor(named:"legsColor")]
        chartDataSet.colors = colors as! [NSUIColor]
        let legend = pieChart.legend
        legend.font = UIFont(name: "boldSystemFontOfSize", size:20.0) ?? UIFont.systemFont(ofSize: 20)
        legend.textColor = UIColor.black
        legend.form = .circle
        legend.formSize = 20
        pieChart.animate(xAxisDuration: 2, yAxisDuration: 2)
        pieChart.data = chartData
        pieChart.chartDescription?.text = ""
        pieChart.drawHoleEnabled = false
        chartDataSet.drawValuesEnabled = true
        pieChart.drawEntryLabelsEnabled = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDate()
        self.armsEntry.value = 1
        self.armsEntry.label = "Arms"
        self.balanceEntry.value = 2
        self.balanceEntry.label = "Balance"
        self.bicepCurlEntry.value = 3
        self.bicepCurlEntry.label = "Bicep Curl"
        self.calfRaiseEntry.value = 4
        self.calfRaiseEntry.label = "Carl raise"
        self.handEntry.value = 5
        self.handEntry.label = "Hand"
        self.legsEntry.value = 6
        self.legsEntry.label = "Legs"
        self.numberOfDownloadsDataEntries = [self.armsEntry, self.balanceEntry, self.bicepCurlEntry, self.calfRaiseEntry,self.handEntry, self.legsEntry]
        updatePieChart()
    }
    
    func setUpDate(){
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM, dd, yyyy"
        let str = formatter.string(from: Date())
        todayDateLabel.text = "Medication for \n" + str
        
    }
    
//    @IBAction func pressInfo(_ sender: Any) {
//        showAlert()
//    }
//    
//    func showAlert(){
//        let alert:UIAlertController = UIAlertController(title:"", message: "View the 'Food Suggestions' topic in our guide for suggested servings and recommendations.", preferredStyle: .alert )
//        let action1: UIAlertAction = UIAlertAction(title: "OK", style: .cancel)
//        alert.addAction(action1)
//        self.present(alert,animated:true)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
