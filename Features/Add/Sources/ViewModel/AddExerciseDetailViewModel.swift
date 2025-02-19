//
//  AddExerciseDetailViewModel.swift
//  Fitculator
//
//  Created by Song Kim on 2/17/25.
//

import SwiftUI

class AddExerciseDetailViewModel: ObservableObject {
    @Published var averageHeartRate: String = ""
    @Published var maxHeartRate: String = ""
    @Published var workoutDuration: String = ""
    @Published var workoutMemo: String = ""
    @Published var selectedDate = Date()
}
