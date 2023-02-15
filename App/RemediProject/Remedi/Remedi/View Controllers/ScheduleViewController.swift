//
//  ScheduleViewController.swift
//  Remedi
//
//  Created by Huy thong Bui on 2019-11-26.
//  Copyright © 2019 Krystal Nguyen. All rights reserved.
//

import UIKit

var dateString = ""
class ScheduleViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {


    @IBOutlet weak var MonthLabel: UILabel!
    @IBOutlet weak var Calendar: UICollectionView!
    
    let Months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let DaysOfMonth = ["Monday","Tueday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    var DaysInMonths = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonth = String()
    
    var NumberOfEmptyBox = Int()
    var NextNumberOfEmptyBox = Int()
    var PreviousNumberOfEmptyBox = 0
    var Direction = 0
    var PositionIndex = 0
    var dayCounter = 0
    var highlightdate = -1
    //var dateString = ""
    
    override func viewDidLoad() {
          super.viewDidLoad()
          currentMonth = Months[month]
          MonthLabel.text="\(currentMonth) \(year)"
      }
    
    @IBAction func Back(_ sender: Any) {
        switch currentMonth{
        case "January":
            month = 11
            year -= 1
            Direction = -1
            GetStartDateDayPosition()
            currentMonth = Months[month]
            MonthLabel.text="\(currentMonth)\(year)"
            Calendar.reloadData()
        default:
            month-=1
            Direction = -1
            GetStartDateDayPosition()
            currentMonth=Months[month]
            MonthLabel.text="\(currentMonth) \(year)"
            Calendar.reloadData()
        }
    }
        
    @IBAction func Next(_ sender: Any) {
        switch currentMonth{
        case "December":
            month = 0
            year += 1
            Direction = 1
            GetStartDateDayPosition()
            currentMonth = Months[month]
            MonthLabel.text="\(currentMonth)\(year)"
            Calendar.reloadData()
        default:
            Direction = 1
            GetStartDateDayPosition()
            month+=1

            currentMonth=Months[month]
            MonthLabel.text="\(currentMonth) \(year)"
            Calendar.reloadData()
        }
    }

    func GetStartDateDayPosition() {
        switch Direction{
            case 0 :
                switch day{
                    case 1...7:
                        NumberOfEmptyBox = weekday - day
                    case 8...14:
                        NumberOfEmptyBox = weekday - day - 7
                    case 15...21:
                        NumberOfEmptyBox = weekday - day - 14
                    case 22...28:
                        NumberOfEmptyBox = weekday - day - 21
                    case 29...31:
                        NumberOfEmptyBox = weekday - day - 28
                    default:
                        break
                }
                PositionIndex = NumberOfEmptyBox
            
            case 1...:
                NextNumberOfEmptyBox = (PositionIndex + DaysInMonths[month])%7
                PositionIndex = NextNumberOfEmptyBox
            case -1:
                PreviousNumberOfEmptyBox = (7 - (DaysInMonths[month] - PositionIndex)%7)
                if PreviousNumberOfEmptyBox == 7 {
                    PreviousNumberOfEmptyBox = 0
            }
            PositionIndex = PreviousNumberOfEmptyBox
        default:
            fatalError()
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Direction {
        case 0:
            return DaysInMonths[month] + NumberOfEmptyBox
        case 1...:
            return DaysInMonths[month] + NextNumberOfEmptyBox
        case -1:
            return DaysInMonths[month] + PreviousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calendar", for: indexPath) as! DateCollectionViewCell
        cell.backgroundColor=UIColor.clear
        if cell.isHidden{
            cell.isHidden = false
        }
        switch Direction{
               case 0:
                   cell.DateLabel.text="\(indexPath.row + 1 - NumberOfEmptyBox)"
               case 1:
                    cell.DateLabel.text="\(indexPath.row + 1 - NextNumberOfEmptyBox)"
               case -1:
                    cell.DateLabel.text="\(indexPath.row + 1 - PreviousNumberOfEmptyBox)"
               default:
                    fatalError()
           }
        
        if Int(cell.DateLabel.text!)! < 1{
            cell.isHidden = true
        }
        
        // Marks red the cell that show the current date
        if currentMonth == Months[calendar.component(.month, from: date) - 1] && year == calendar.component(.year, from: date) && indexPath.row + 1 == day{
            cell.backgroundColor = UIColor(displayP3Red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        }
        
        if highlightdate == indexPath.row{
            cell.backgroundColor = UIColor(hue: 222/360, saturation: 30/100, brightness: 75/100, alpha: 1.0) /* #8597bf */
        }
        
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        dateString = "\(indexPath.row - PositionIndex + 1) \(currentMonth) \(year)"
        print(dateString)
        
        performSegue(withIdentifier: "NextView", sender: self)
        
        highlightdate = indexPath.row
        collectionView.reloadData()
        print(highlightdate)
    }

}
