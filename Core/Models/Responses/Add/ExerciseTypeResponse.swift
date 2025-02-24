//
//  ExerciseTypeResponse.swift
//  Fitculator
//
//  Created by Song Kim on 2/24/25.
//

public struct ExerciseTypeResponse: Codable {
    public let success: Bool
    public let message: String
    public let data: [ExerciseType]
}
