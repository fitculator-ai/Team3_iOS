//
//  AddWorkoutRequest.swift
//  Fitculator
//
//  Created by Song Kim on 2/24/25.
//

public struct AddExerciseTypeResponse: Codable {
    public let success: Bool
    public let message: String
    public let data: AddWorkoutType
}

public struct AddWorkoutType: Codable {
    let userId: Int
    let exerciseType: String
    let exerciseKorName: String
    let exerciseEngName: String
    let recordDate: String
    let recordStart: String
    let recordEnd: String
    let avgHeartRate: Int
    let highHeartRate: Int
    let memo: String
    let recordPoint: Int
    let createdAt: String
    let intensity: String
}
