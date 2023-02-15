//
//  ReminderTableViewController.swift
//  Remedi
//
//  Created by Ngan Nguyen on 2019-11-30.
//  Copyright © 2019 Krystal Nguyen. All rights reserved.
//

import UIKit
import os.log
import UserNotifications

class ReminderTableViewController: UITableViewController {
    var pillList = [Pill]()
    override func viewDidLoad() {
        super.viewDidLoad()

//        let button = UIButton(type: .custom)
//        //set image for button
//        button.setImage(UIImage(named: "add 1"), for: .normal)
//        //add function for button
//        button.addTarget(self, action: #selector(ViewController.fbButtonPressed), for: UIControlEvents.touchUpInside)
//        //set frame
//        button.frame = CGRect(x: 0, y: 0, width: 53, height: 51)
//
//        let barButton = UIBarButtonItem(customView: button)
//        //assign button to navigationbar
//        self.navigationItem.rightBarButtonItem = barButton
        //load data when the ViewController is loaded.
        let titleImageView = UIImage(named: "add 1")
        let imageView = UIImageView(image: titleImageView)
        navigationItem.titleView = imageView
        if let savedPills = loadPills() {
            pillList += savedPills
        }
    }
    @IBAction func unwindToMain(sender:UIStoryboardSegue){
        
        // we need to create reference to the newPill view controller
        guard let newPillVC = sender.source as? NewPill else {return}
        
        // obtain new pill data and add it to our pill list
        let new = Pill(name:newPillVC.pillNameTxt.text!, time:newPillVC.pillTimePick.date)
        pillList.append(new)
        
        // sort pill list.
        // objet 1 compare object 2.
        // sorted by time(ascending)
        pillList.sort {
            $0.time.compare($1.time) == ComparisonResult.orderedAscending
        }
        
        //schedule pill notification
        let delegate = UIApplication.shared.delegate as? AppDelegate
        delegate?.schedulePillNotification(from: new, at: new.time)
        
        // now we have new pill.
        // repaint data and save list
        tableView.reloadData()
        savePills()
        
    }
    // MARK: - Table view data source

    // Number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Number of rows per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pillList.count
    }
    
    // Cell configuration
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PillCell  else {
            fatalError("The dequeued cell is not an instance of PillTableViewCell.")
        }
                
        // fetches the appropiate pill for the data source layout.
        let pill = pillList[indexPath.row]
        
        cell.pillNameLabel.text = "Notification " + String(indexPath.row + 1) + pill.pillName
        
        // --- time format ----
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        
        let timeTxt = formatter.string(from:pill.time)
        cell.pillTimeLabel.text? = timeTxt
        //----------------------
        
        // cell color based on pill status
        // TODO: use an enum object to avoid this integer
        if (pill.status == 1){
            cell.backgroundColor = UIColor(named:"Color1")
        }
        else
        {
            if (pill.status == 0)
            {
                cell.backgroundColor = UIColor(named:"Color2")
            }
            else
            {
                cell.backgroundColor = UIColor.white
            }
        }
        
        // making cell rows rounded
//        cell.layer.cornerRadius = 12
//        cell.layer.masksToBounds = true
//        cell.layer.borderWidth = 1
    
        return cell
    }
    // Configuration for a cell element pressed.
    internal override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // we have the cell pressed in the indexPath var.
        // So, don't need a selected cell row.
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        // obtain the pill data
        let pill = pillList[indexPath.row]
        
        // manage the status
        // TODO: Use a better option. (switch)
        
        if (pill.status == -1){
            
            pill.status = 1 // new status = taken
            // remove request notification with uuid
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [pill.uuid])

            let delegate = UIApplication.shared.delegate as? AppDelegate
            delegate?.schedulePillNotification(from: pill, at: pill.time)
        
        }
        else{
            if (pill.status == 0){
                // Si tenim la pastilla com a later i ens la prenen.
                // posem-la a taken i eliminem el request notification pending
                
                pill.status = 1  // new status = taken
                // identifier per als pending recodem que es: uid + "l"
                let pendingIdentifier = pill.uuid + "l"
                print (pendingIdentifier)
                
                // remove pending request notification with uuid
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [pendingIdentifier])
                
                // remove also usual notification to be created for the next day.
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [pill.uuid])
                

                let delegate = UIApplication.shared.delegate as? AppDelegate
                delegate?.schedulePillNotification(from: pill, at: pill.time)
                
                // delete -1 al counter del badge
                UIApplication.shared.applicationIconBadgeNumber -= 1
            }
            else{
                pill.status = -1 // current status = new
            }
        }
        
        // Repaint the table as status may have changed.
        tableView.reloadData()
        
    }
    
    // Swipe configuration
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        //TODO: > Answer why this function just right swipe?
        //      > Make left swipe
        
        // fetches the appropiate pill for the data source layout.
        let pill = pillList[indexPath.row]
        
        // Create a later option.
        // This option will be used when a pill is postponed
        let laterAction = UIContextualAction(style: .destructive, title: "Later") { (action, view, handler) in
            os_log("Later pill action Tapped.", log: OSLog.default, type: .debug)
            
            // === TAKING LATER A PILL ===
            
            //schedule pill notification + 30 min
            let delegate = UIApplication.shared.delegate as? AppDelegate
            let laterTime = pill.time.addingTimeInterval(TimeInterval(30.0 * 60.0)) // we are adding 30 min from the initial time
            pill.uuid = pill.uuid + "l"
            delegate?.schedulePillNotification(from: pill, at:laterTime)
            
            // add 1 al counter del badge
            UIApplication.shared.applicationIconBadgeNumber += 1
            pill.status = 0
            
            tableView.reloadData()
        }
        laterAction.backgroundColor = UIColor(named:"Color2")
        
        // Create a delete option.
        // This option will be used when a pill is deleted
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            os_log("Delete pill action Tapped.", log: OSLog.default, type: .debug)
            
            // === DELETING A PILL ===
            
            //schedule pill notification
            //let delegate = UIApplication.shared.delegate as? AppDelegate
            //delegate?.schedulePillNotification(from: new, at: new.time)
            
            // remove request notification with uuid
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [pill.uuid])

            // Delete the row from the data source and save pills
            self.pillList.remove(at: indexPath.row)
            tableView.reloadData()
            self.savePills()
            
        }
        deleteAction.backgroundColor = UIColor(named:"Color1")
        
        let configuration = UISwipeActionsConfiguration(actions: [laterAction,deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    // ==== END tableView config ====

    // Save pills
    private func savePills() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(pillList, toFile: Pill.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Pills successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save pills...", log: OSLog.default, type: .error)
        }
    }
    
    // Load pills
    private func loadPills() -> [Pill]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Pill.ArchiveURL.path) as? [Pill]
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
