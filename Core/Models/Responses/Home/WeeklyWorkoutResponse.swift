//
//  WeeklyWorkoutResponse.swift
//  Core
//
//  Created by JIHYE SEOK on 2/19/25.
//

import Foundation

public struct WeeklyWorkoutResponse: Codable {
    public let success: Bool
    public let message: String
    public let data: WorkoutData
}

public struct WorkoutData: Codable {
    public let records: [WorkoutRecord]
    public let weekStrengthCount: Int
    public let weekIntensity: String
}

public struct WorkoutRecord: Codable, Identifiable {
    public var id: Int { recordId }
    
    public let recordId: Int
    public let exerciseKorName: String
    public let exerciseEngName: String
    public let exerciseImg: String
    public let exerciseColor: String
    public let avgHeartRate: Int
    public let recordStart: String
    public let recordEnd: String
    public let duration: Int
    public let intensity: String
    public let recordPoint: Int
    public let memo: String?
}
