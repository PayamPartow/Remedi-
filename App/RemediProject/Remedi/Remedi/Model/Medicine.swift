//
//  File.swift
//  Remedi
//
//  Created by Ngan Nguyen on 2019-11-17.
//  Copyright © 2019 Krystal Nguyen. All rights reserved.
//

import Foundation
class Medicine{
    var doseSize: String
    var doseNotes: String
    var timePref: String
    var medNotes: String
    var instructions: String
    var dayMedTaken: [String] = []
    init(doseSizeString: String, doseNotesString: String, timePrefString: String, medNotesString: String, instructionsString: String, dayMedTakenString: [String]){
        doseSize = doseSizeString
        doseNotes = doseNotesString
        timePref = timePrefString
        medNotes = medNotesString
        instructions = instructionsString
        dayMedTaken = dayMedTakenString
    }
}
