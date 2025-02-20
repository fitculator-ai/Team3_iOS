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

