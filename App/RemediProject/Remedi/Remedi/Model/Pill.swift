//
//  Pill.swift
//  Remedi
//
//  Created by Ngan Nguyen on 2019-11-30.
//  Copyright © 2019 Krystal Nguyen. All rights reserved.
//

import Foundation
import UIKit
import os.log


class Pill: NSObject, NSCoding {
    
    // Pill properties
    var pillName: String = ""
    var status: Int8  // -1 = new, 0 = later, 1 = taken
    var time: Date
    var uuid: String = ""
    //var triggerTime: NSDateComponents
    
    // Persistence data file config.
    // MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("pills")
    
    // MARK: Types
    // Property keys used on NSCoding
    struct PropertyKey {
        static let name = "name"
        static let status = "status"
        static let time = "time"
        static let uuid = "uuid"
    }
    
    // Init method for pill objects
    init(name:String, time:Date) {
        // Initialize stored properties.
        self.pillName = name
        self.status = -1
        self.time = time
        self.uuid = UUID().uuidString
        //self.triggerTime = Calendar.current.dateComponents([.hour, .minute, .second], from: self.time) as NSDateComponents

    }
    
    // MARK: NSCoding methods
    // Encode & DeCode methods are required

    func encode(with aCoder: NSCoder) {
        aCoder.encode(pillName as String, forKey:PropertyKey.name)
        aCoder.encode(status as Int8,  forKey:PropertyKey.status)
        aCoder.encode(time as Date, forKey:PropertyKey.time)
        aCoder.encode(uuid as String, forKey:PropertyKey.uuid)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Pill object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        /*
         Decode method used if enum object is used
         
        guard let status = aDecoder.decodeObject(forKey: PropertyKey.status) as? PillStatus else {
            os_log("Unable to decode the status for a Pill object.", log: OSLog.default, type: .debug)
            return nil
        }
        */
        
        guard let time = aDecoder.decodeObject(forKey: PropertyKey.time) as? Date else {
            os_log("Unable to decode the time for a Pill object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard (aDecoder.decodeObject(forKey: PropertyKey.uuid) as? String) != nil else {
            os_log("Unable to decode the uuid for a Pill object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(name: name, time: time)
    }
    
}

