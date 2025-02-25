//
//  WorkoutRequest.swift
//  Core
//
//  Created by JIHYE SEOK on 2/19/25.
//

import Foundation

public struct WorkoutRequest: Codable {
    let userId: Int
    let exerciseType: String
    let exerciseKorName: String
    let exerciseEngName: String
    let recordDate: String
    let recordStart: String
    let duration: Int
    let avgHeartRate: Int
    let highHeartRate: Int
    let memo: String

    public init(userId: Int, exerciseType: String, exerciseKorName: String, exerciseEngName: String, recordDate: String, recordStart: String, duration: Int, avgHeartRate: Int, highHeartRate: Int, memo: String) {
        self.userId = userId
        self.exerciseType = exerciseType
        self.exerciseKorName = exerciseKorName
        self.exerciseEngName = exerciseEngName
        self.recordDate = recordDate
        self.recordStart = recordStart
        self.duration = duration
        self.avgHeartRate = avgHeartRate
        self.highHeartRate = highHeartRate
        self.memo = memo
    }

    public func toDictionary() -> [String: Any] {
        return [
            "userId": userId,
            "exerciseType": exerciseType,
            "exerciseKorName": exerciseKorName,
            "exerciseEngName": exerciseEngName,
            "recordDate": recordDate,
            "recordStart": recordStart,
            "duration": duration,
            "avgHeartRate": avgHeartRate,
            "highHeartRate": highHeartRate,
            "memo": memo
        ]
    }
}
