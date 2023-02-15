//
//  File.swift
//  Remedi
//
//  Created by Ngan Nguyen on 2019-11-18.
//  Copyright © 2019 Krystal Nguyen. All rights reserved.
//

import Foundation
class Exercise{
    var exName: String
    var exNotes: String
    var exReps: String
    var exSets: String
    var video: String
    var image: String
    var dayExTaken: [String] = []
    init(exNameString: String, exNotesString: String, exRepsString: String, exSetsString: String, dayExTakenString: [String], videoString: String, imageString: String){
        exName = exNameString
        exNotes = exNotesString
        exReps = exRepsString
        exSets = exSetsString
        dayExTaken = dayExTakenString
        video = videoString
        image = imageString
    }
}
