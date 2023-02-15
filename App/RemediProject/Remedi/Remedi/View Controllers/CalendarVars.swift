//
//  CalendarVars.swift
//  Remedi
//
//  Created by Huy thong Bui on 2019-11-26.
//  Copyright © 2019 Krystal Nguyen. All rights reserved.
//

import Foundation

let date = Date()
let calendar = Calendar.current

let day = calendar.component(.day, from: date)
let weekday = calendar.component(.weekday, from: date)
var month = calendar.component(.month, from: date)  - 1
var year = calendar.component(.year, from: date)

