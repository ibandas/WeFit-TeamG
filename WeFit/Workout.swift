//
//  Workout.swift
//  WeFit
//
//  Created by Irinel Bandas on 4/25/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.
//

import Foundation

// TODO: Add date
struct Workout {
    var exercises: Array = [Exercise]()
}

struct Exercise {
    var exercise_id: String = ""
    var title: String = ""
    var sets: Array = [Set]()
    var created_at: Date
}

struct Set {
    var set_id: String = ""
    var weight: Int = 0
    var reps: Int = 0
}

