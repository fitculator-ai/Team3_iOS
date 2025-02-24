//
//  HeartRateRequest.swift
//  Core
//
//  Created by JIHYE SEOK on 2/19/25.
//

import Foundation

public struct HeartRateRequest: Codable {
    let userId: Int
    public var userHeartRate: Int
    
    public init(userId: Int, userHeartRate: Int) {
        self.userId = userId
        self.userHeartRate = userHeartRate
    }
    
    public func toDictionary() -> [String: Any] {
        return [
            "userId": userId,
            "userHeartRate": userHeartRate
        ]
    }
}
