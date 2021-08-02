//
//  Data.swift
//  MediTime
//
//  Created by Maitri Vira on 14/07/21.
//

import Foundation

struct DataExample{
    let name: String
    let sick: String
}

let userData: [DataExample] = [
    DataExample(name: "adi", sick: "batuk"),
    DataExample(name: "bapak", sick: "demam"),
    DataExample(name: "ani", sick: "demam"),
]

struct ReminderData{
    let hour: Int
}

let one: [ReminderData] = [
    ReminderData(hour: 9),
]

let two: [ReminderData] = [
    ReminderData(hour: 8),
    ReminderData(hour: 20),
]

let three: [ReminderData] = [
    ReminderData(hour: 7),
    ReminderData(hour: 15),
    ReminderData(hour: 23),
]

let four: [ReminderData] = [
    ReminderData(hour: 6),
    ReminderData(hour: 12),
    ReminderData(hour: 18),
    ReminderData(hour: 24),
]

struct Time {
    let fullDate: Date
}
