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
    //TODO: init 삭제 -> test 위해 생성
    public init(records: [WorkoutRecord], weekStrengthCount: Int, weekIntensity: String) {
        self.records = records
        self.weekStrengthCount = weekStrengthCount
        self.weekIntensity = weekIntensity
    }
    public let records: [WorkoutRecord]
    public let weekStrengthCount: Int
    public let weekIntensity: String
}

public struct WorkoutRecord: Codable, Identifiable, Hashable {
    //TODO: init 삭제 -> test 위해 생성
    public init(recordId: Int, exerciseKorName: String, exerciseEngName: String, exerciseImg: String, exerciseColor: String, avgHeartRate: Int, duration: Int, intensity: String, recordPoint: Int, memo: String?) {
        self.recordId = recordId
        self.exerciseKorName = exerciseKorName
        self.exerciseEngName = exerciseEngName
        self.exerciseImg = exerciseImg
        self.exerciseColor = exerciseColor
        self.avgHeartRate = avgHeartRate
        self.duration = duration
        self.intensity = intensity
        self.recordPoint = recordPoint
        self.memo = memo
    }
    
    public var id: Int { recordId }
    
    public let recordId: Int
    public let exerciseKorName: String
    public let exerciseEngName: String
    public let exerciseImg: String
    public let exerciseColor: String
    public let avgHeartRate: Int
    public let duration: Int
    public let intensity: String
    public let recordPoint: Int
    public let memo: String?
}
