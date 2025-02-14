//
//  Exercise.swift
//  Fitculator
//
//  Created by Song Kim on 2/14/25.
//

import Foundation

public struct ExerciseType: Identifiable {  // <- public 추가
    public let id = UUID()
    public var exerciseName: String
    public var exerciseType: String
    public var exerciseColor: String
    public var exerciseImage: String

    public init(exerciseName: String, exerciseType: String, exerciseColor: String, exerciseImage: String) {
        self.exerciseName = exerciseName
        self.exerciseType = exerciseType
        self.exerciseColor = exerciseColor
        self.exerciseImage = exerciseImage
    }
}
