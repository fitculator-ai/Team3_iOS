//
//  HeartRateRequest.swift
//  Core
//
//  Created by JIHYE SEOK on 2/19/25.
//

import Foundation

public struct HeartRateRequest: Codable {
    let userId: Int
    let userHeartRate: Int
    
    public func toDictionary() -> [String: Any] {
        return [
            "userId": userId,
            "userHeartRate": userHeartRate
        ]
    }
}
