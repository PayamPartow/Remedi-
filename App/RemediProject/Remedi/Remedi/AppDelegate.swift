//
//  AppDelegate.swift
//  Remedi
//
//  Created by Ngan Nguyen on 2019-10-28.
//  Copyright © 2019 Krystal Nguyen. All rights reserved.
//
//Programmers: Ngan Nguyen, David Song, Payam Partow, HuyThong Bui

import UIKit
import UserNotifications
import Firebase

// Default file to control the application
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (accepted, error) in
            if !accepted{
                print ("Authorization denied")
            }
        }
        let takeAction = UNNotificationAction(identifier: "takePill", title: "Take pill", options: [])
        let laterAction = UNNotificationAction(identifier: "laterPill", title: "Postpone pill", options: [])
        let category = UNNotificationCategory(identifier: "pillCategory", actions:[takeAction, laterAction], intentIdentifiers: [], options:[])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        return true
    }
    func schedulePillNotification (from pill: Pill, at time: Date ){
        let timeComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: time) as NSDateComponents

        print ("Pill time: \(timeComponents.hour):\(timeComponents.minute):\(timeComponents.second)")

        let trigger = UNCalendarNotificationTrigger(dateMatching: timeComponents as DateComponents, repeats:true)

        let content = UNMutableNotificationContent()
        content.title = "REMINDER!!"
        content.subtitle = "Pill and Exercise reminder!"
        content.body = "Time to take \(pill.pillName). "
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "pillCategory" // This option makes appear buttons into the notification.
        
        
        // Request identifier MUST be different.
        // TODO: Use it to add it +30 min when later pill is pressed.
        
        // if pill status is later we add a "l" at the end of the uuid as pillIdentifier
        // if not, pillIdentifier is just uuid
        var pillIdentifier = ""
        if (pill.status != 0){
            pillIdentifier = pill.uuid
        }
        else{
            pillIdentifier = pill.uuid + "l"
        }
        
        let request = UNNotificationRequest(identifier: pillIdentifier, content: content, trigger: trigger)
        

        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate //as? UNUserNotificationCenterDelegate
        
        // --> Això fa que només salti la última request???????????
        //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print (error)
            }
        }
        
        // Checking number of pending notifications
        var displayString = "Current Pending Notifications "
        
        UNUserNotificationCenter.current().getPendingNotificationRequests {
            (requests) in
            displayString += "count: \(requests.count)\t"
            for request in requests{
                displayString += request.identifier + "\t"
            }
            print(displayString)
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound, .badge])
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.actionIdentifier == "takePill" {
            print ("Action take pill pressed from notification")
            
        }
        else { //laterPill
            print ("Action later pill pressed from notification")
        }
        
        completionHandler()
    }


}

