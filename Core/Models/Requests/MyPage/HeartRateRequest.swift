//
//  HeartRateRequest.swift
//  Core
//
//  Created by JIHYE SEOK on 2/19/25.
//

import Foundation

public struct HeartRateRequest: Codable {
    public let userId: Int
    public var userHeartRate: Int
    
    // 초기값을 설정한 init 메서드
    public init(userId: Int = 1, userHeartRate: Int = 40) {
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
